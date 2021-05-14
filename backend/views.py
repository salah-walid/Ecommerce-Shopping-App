from backend.models.variation import Variations
from backend.models.variationOptions import VariationOptions
from backend.models.uom import UOM
from appConf.models.user import User
from backend.models.redeemed import redeemed
from backend.utils import calculateTotal
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes
from django.shortcuts import get_object_or_404

import json
import stripe

from .models.product import product
from .models.productOrderData import productOrderData
from .models.orderData import orderData
from .models.category import category
from .models.promoCodes import promoCode
from .models.carrouselPromos import carrouselPromo
from .models.stripeCharge import stripeCharge

from .serializers.productSerializer import productSerializer
from .serializers.productOrderDataSerializer import productsOrderSerializer
from .serializers.orderSerializer import orderDataSerializer, orderDataSerializerDetailed
from .serializers.categorySerializer import categorySerializer
from .serializers.carrouselPromosSerializer import carrouselPromoSerializer
from .serializers.reviewsSerializer import reviewsSerializer

# Create your views here.


#! product view
@api_view(['GET'])
def get_products(request):
    products = product.objects.all()
    serialized = productSerializer(products, context={'request': request}, many=True)

    return Response(serialized.data)

@api_view(['GET'])
def get_product(request, product_id):
    pro = get_object_or_404(product, id=product_id)
    serialized = productSerializer(pro, context={'request': request})

    return Response(serialized.data)

@api_view(['GET'])
def get_topSales(request):
    from backend.models.SalesAndBalance import SalesAndBalance
    sales = SalesAndBalance.objects.all().order_by("-totalSales")[:10]
    productIds = [pId.chooseProduct.id for pId in sales]
    products = product.objects.filter(id__in=productIds)
    serialized = productSerializer(products, context={'request': request}, many=True)

    return Response(serialized.data)

@api_view(['GET'])
def searchProducts(request, product_name):
    products = product.objects.filter(title__contains=product_name)
    serialized = productSerializer(products, context={'request': request}, many=True)

    return Response(serialized.data)

#! order views
@api_view(['GET'])
@permission_classes((IsAuthenticated, ))
def get_orders(request):
    orders = orderData.objects.filter(user=request.user)

    serialized = orderDataSerializerDetailed(orders, context={'request': request}, many=True)

    return Response(serialized.data)

@api_view(['POST'])
@permission_classes((IsAuthenticated, ))
def post_orders(request):
    data = json.loads(request.data.get("order"))
    serialized = orderDataSerializer(data=data)
    if serialized.is_valid():
        try:
            order = serialized.save()
            
            order_data = data.pop("orderList")

            usr = User.objects.get(pk=data.get("user"))
            #! check if points are bigger then user points
            orderPointCount = 0
            for proOrder in order_data:
                if proOrder.get("isRedeemed"):
                    pro = product.objects.get(id=proOrder.get("product"))
                    uomTemp = UOM.objects.get(id=proOrder.get("uom"))
                    orderPointCount += pro.redeemPoints * proOrder.get("quantity") * uomTemp.value
             
            if orderPointCount > usr.points:
                raise Exception("Redeem points are more then user points")

            #! create product order datas
            for jProOrder in order_data:
                pr = product.objects.get(pk=jProOrder.pop("product"))
                uom = UOM.objects.get(pk=jProOrder.pop("uom"))
                variationsIds = jProOrder.pop("chosenVariations")
                variations = []
                for varId in variationsIds:
                    variations.append(VariationOptions.objects.get(pk=varId.get("id")))

                proOrder = productOrderData.objects.create(**jProOrder, uom=uom, product=pr, order=order)
                proOrder.chosenVariations.set(variations)
                if proOrder.isRedeemed:
                    redeemed.objects.create(user=usr, productOrder=proOrder, pointsRedeemed=proOrder.product.redeemPoints)

            if order.promoCode:
                promoAmount = promoCode.objects.get(code=order.promoCode).promo
            else:
                promoAmount = 0
            subTotal, shipping, tax, total = calculateTotal(serialized.data.get("orderList"), order.sameDayDelivery, promoAmount)
            order.subTotal = subTotal
            order.shipping = shipping
            order.estimatedTax = tax
            order.total = total
            order.promo = promoAmount
            order.save()

            if order.total > 0:
                response = stripe.Charge.create(
                    source=request.data.get("sid"),
                    currency="DZD",
                    amount=int(order.total*100),
                    description="#ORD" + str(order.id).zfill(7),
                )
                stripeCharge.objects.create(chargeId=response.get("id"), order=order)
            else:
                stripeCharge.objects.create(chargeId="", order=order)
            
        except Exception as e:
            print(e)
            order.delete()
            return Response(status=status.HTTP_400_BAD_REQUEST)
        return Response(str(order.id).zfill(7) ,status=status.HTTP_201_CREATED)
    
    print(serialized.errors)
    return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes((IsAuthenticated, ))
def refund_order(request, order_id):
    try:
        order = orderData.objects.get(id=order_id)
    except orderData.DoesNotExist:
        return Response(status=status.HTTP_400_BAD_REQUEST)
    
    if order.user == request.user and order.orderState < 3:
        #charge = stripeCharge.objects.get(order=order)
        #stripe.Refund.create(charge=charge.chargeId)
        order.orderState = 5
        order.save()
        return Response(status=status.HTTP_200_OK)
    else:
        return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST']) 
def orderCalculateTotal(request):

    listOrder = request.data.get("listOrder")
    sameDayDelivery = request.data.get("sameDayDelivery")
    promoC = request.data.get("promo")

    if listOrder is not None and sameDayDelivery is not None and promoC is not None:
        if promoC:
            promoAmount = get_object_or_404(promoCode, code=promoC).promo
        else:
            promoAmount = 0
        subTotal, shipping, tax, total = calculateTotal(listOrder, sameDayDelivery, promoAmount)
        context = {
            "subTotal" : subTotal,
            "shipping" : shipping,
            "tax" : tax,
            "total" : total
        }
        return Response(context, status=status.HTTP_200_OK)
    
    return Response(status=status.HTTP_400_BAD_REQUEST)

#! subcategory
@api_view(['GET'])
def get_categories(request):
    categories = category.objects.all()

    serialized = categorySerializer(categories, context={'request': request}, many=True)

    return Response(serialized.data)

#! promo codes
@api_view(['POST'])
def check_promoCode(request):
    try:
        data = promoCode.objects.get(code=request.data.get("code"))
        return Response({"promo" : data.promo}, status=status.HTTP_200_OK)
    except promoCode.DoesNotExist:
        return Response({"error" : "no promo code"}, status=status.HTTP_204_NO_CONTENT)

#! carrousel
@api_view(['GET'])
def get_carrouselPromos(request):
    carrousels = carrouselPromo.objects.all()

    serialized = carrouselPromoSerializer(carrousels, context={'request': request}, many=True)

    return Response(serialized.data)

#! reviews
@api_view(['POST'])
@permission_classes((IsAuthenticated, ))
def postReview(request):
    data = request.data.copy()
    data["user"] = request.user.id
    productOrderId = data.pop("productOrder")
    serialized = reviewsSerializer(data=data)
    if serialized.is_valid():
        productOrder = get_object_or_404(productOrderData, pk=productOrderId)
        productOrder.reviewed = True
        productOrder.save()

        serialized.save(user=request.user)
        
        return Response(status=status.HTTP_201_CREATED)

    return Response(serialized.errors ,status=status.HTTP_400_BAD_REQUEST)
