from .models.company import company
from appConf.models.termsAndConditions import termsAndConditions
from django.shortcuts import get_object_or_404
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models.user import User
from validate_email import validate_email
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from rest_framework.decorators import permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import MultiPartParser
from rest_framework.decorators import parser_classes
from django.core.mail import send_mail
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes

from appConf.tokenGenerator import account_activation_token
from appConf.models.activationTokens import accountActivationToken

from .serializers.userSerializer import userSerializer
from .serializers.notificationSerializer import notificationSerializer

from .models.user import User
from .models.notification import notification
from .models.activationTokens import accountActivationToken
from .models.passwordResetTokens import passwordResetToken
from .models.mobileActivation import mobileActivation
from .tokenGenerator import generatePasswordResetToken, generatePhoneVerificationCode
from settings.settings import twilioClient, from_phone, gmapClient

# Create your views here.

@api_view(['POST'])
def customAuth(request):
    auth = request.data.get("auth")
    password = request.data.get("password")

    if auth and password:
        if(validate_email(auth)):
            try:
                auth = User.objects.get(email=auth).username
            except User.DoesNotExist:
                pass

        user = authenticate(username=auth, password=password)

        if user and user.is_active:
            token, created = Token.objects.get_or_create(user=user)
            try:
                mobileActivation.objects.get(user=user)
                return Response({"status" : 1, "token": token.key}, status=status.HTTP_401_UNAUTHORIZED)
            except mobileActivation.DoesNotExist:
                pass

            serialized = userSerializer(user, context={'request': request})
            content = {
                'token': token.key,
                'user' : serialized.data
            }

            return Response(content ,status=status.HTTP_200_OK)

        return Response({"status" : 2}, status=status.HTTP_401_UNAUTHORIZED)

    return Response({"status" : 3}, status=status.HTTP_401_UNAUTHORIZED)

@api_view(['POST'])
@permission_classes((IsAuthenticated, ))
def resendPhoneActivation(request):
    activation, created = mobileActivation.objects.update_or_create(user=request.user)
    code = generatePhoneVerificationCode()
    activation.code = code
    activation.save()

    twilioClient.messages.create(
        body="Ved Store verification code : {}".format(code),
        from_=from_phone,
        to=request.user.billingMobileNumber
    )

    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes((IsAuthenticated, ))
def verifyPhoneNumber(request):
    mobileCode = request.data.get("mobileCode")
    
    if mobileCode:
        try:
            userCode = mobileActivation.objects.get(user=request.user)
        except:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        if userCode.code == mobileCode:
            userCode.delete()
            notification.objects.create(user=request.user, title="Verification", content="Your account has been verified")
            return Response(status=status.HTTP_200_OK)

    return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes((IsAuthenticated, ))
def getUser(request):

    try:
        mobileActivation.objects.get(user=request.user)
        return Response(status=status.HTTP_401_UNAUTHORIZED)
    except mobileActivation.DoesNotExist:
        pass

    serialized = userSerializer(request.user, context={'request': request})

    return Response(serialized.data, status=status.HTTP_200_OK)

@api_view(['PATCH'])
@permission_classes((IsAuthenticated, ))
@parser_classes([MultiPartParser])
def updateUser(request):
    serialized = userSerializer(request.user, context={'request': request}, data=request.data, partial=True)
    if serialized.is_valid():
        serialized.save()
        return Response(status=status.HTTP_200_OK)

    return Response(serialized.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes((IsAuthenticated, ))
def updateUserPassword(request):
    password = request.data.get("password")
    newPassword = request.data.get("newPassword")

    if password and newPassword:
        passwordValid = request.user.check_password(password)

        if passwordValid:
            request.user.set_password(newPassword)
            request.user.save()
            return Response(status=status.HTTP_200_OK)

    return Response(status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@parser_classes([MultiPartParser])
def registerUser(request, format=None):

    serialized = userSerializer(data=request.data, context={'request': request})
    if serialized.is_valid():
        user = serialized.save()
        user.set_password(request.data.get("password"))
        #user.is_active = False
        user.save()

        activation, created = mobileActivation.objects.update_or_create(user=user)
        code = generatePhoneVerificationCode()
        activation.code = code
        activation.save()

        """ token = account_activation_token.make_token(user)
        message = request.META['HTTP_HOST'] + "/vedapiservice/settings/confirmAccount/" + token
        accountActivationToken.objects.create(user=user, token=token)
        send_mail(
            "VED : Account verification",
            message,
            "noreply@backend.com",
            [user.email],
            fail_silently=False
        ) """

        try:
            twilioClient.messages.create(
                body="Ved Store verification code : {}".format(code),
                from_=from_phone,
                to=user.billingMobileNumber
            )

            send_mail(
                "VED",
                "Thanks for Registration",
                "noreply@backend.com",
                [user.email],
                fail_silently=False
            )
        except:
            pass

        token, created = Token.objects.get_or_create(user=user)

        notif = notification.objects.create(title="Welcome", content="Thanks for Registration {}, \n and continue Shopping with US. \nFrom VED".format(user.username))
        notif.user.add(user)
        notif.save()
        return Response({"token": token.key} ,status=status.HTTP_201_CREATED)
    
    return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def confirmAccount(request, token):
    try:
        activation = accountActivationToken.objects.get(token=token)
        user = activation.user
        user.is_active = True
        user.save()
        activation.delete()
        return Response("Your account has been activated")
    except accountActivationToken.DoesNotExist:
        return Response("Account already confirmed")

@api_view(['POST'])
def generateResetToken(request):
    email = request.data.get("email")
    if email:
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        
        token = generatePasswordResetToken()

        try:
            token = passwordResetToken.objects.get(user=user).token
        except passwordResetToken.DoesNotExist:
            passwordResetToken.objects.create(user=user, token=token)
        
        send_mail(
            "VED : Password reset code",
            token,
            "noreply@backend.com",
            [user.email],
            fail_silently=False
        )

        return Response(status=status.HTTP_200_OK)
    
    return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def checkResetToken(request):
    token = request.data.get("token")
    email = request.data.get("email")
    if token and email:
        try:
            user = User.objects.get(email=email)
            passwordResetToken.objects.get(user=user, token=token)
            return Response(status=status.HTTP_200_OK)
        except:
            return Response(status=status.HTTP_400_BAD_REQUEST)

    return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def updatePassWord(request):
    token = request.data.get("token")
    email = request.data.get("email")
    password = request.data.get("password")
    if token and email and password:
        try:
            user = User.objects.get(email=email)
            passToken = passwordResetToken.objects.get(user=user, token=token)
        except:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        user.set_password(password)
        passToken.delete()

        user.save()
        return Response(status=status.HTTP_200_OK)

    return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes((IsAuthenticated, ))
def getNotification(request):
    notifications = notification.objects.filter(user__in=[request.user], hiden=False)

    serialized = notificationSerializer(notifications, context={'request': request}, many=True)

    return Response(serialized.data, status=status.HTTP_200_OK)

@api_view(['PUT'])
@permission_classes((IsAuthenticated, ))
def markNotifAsRead(request, notifId):
    try:
        notif = notification.objects.get(id=notifId)
    except notification.DoesNotExist:
        return Response(status=status.HTTP_400_BAD_REQUEST)

    notif.notificationRead.add(request.user)
    notif.save()
    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes((IsAuthenticated, ))
def deleteNotification(request, notifId):
    notif = get_object_or_404(notification, pk=notifId)
    notif.hiden = True
    notif.save()

    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])
def getSettings(request, slug):
    result = ""

    if slug == 'terms':
        result = termsAndConditions.objects.first().terms
    elif slug == 'home_position':
        comp = company.objects.first()
        try:
            mapResult = gmapClient.distance_matrix(
                request.data.get("adress"),
                "{}, {}, {} {}, {}".format(
                    comp.warehouseAdress,
                    comp.warehouseCity,
                    comp.warehouseState,
                    comp.warehouseZipCode,
                    comp.warehouseCountry,
                )
            )
            print(mapResult)

            requestStatus = mapResult["rows"][0]["elements"][0]["status"]
            if requestStatus == "OK":
                result = mapResult["rows"][0]["elements"][0]["distance"]["value"] < comp.maxDistanceForSameDayDelivery
            else:
                result = False
        except Exception as e:
            print(e)
            result = False
    else:
        return Response(status=status.HTTP_400_BAD_REQUEST)
    
    return Response(result, status=status.HTTP_200_OK)
