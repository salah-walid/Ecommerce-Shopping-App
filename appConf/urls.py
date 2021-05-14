from django.urls import path
from .views import customAuth, getUser, updateUser, registerUser, confirmAccount
from .views import generateResetToken, checkResetToken, updatePassWord, updateUserPassword
from .views import getNotification, markNotifAsRead, deleteNotification
from .views import verifyPhoneNumber, resendPhoneActivation
from .views import getSettings

urlpatterns = [
    path("auth", customAuth),
    path("registerUser", registerUser),
    path("confirmAccount/<token>", confirmAccount),
    path("getUser", getUser),
    path("updateUser", updateUser),

    path("verifyPhoneNumber", verifyPhoneNumber),
    path("resendPhoneActivation", resendPhoneActivation),

    path("updateUserPassword", updateUserPassword),
    path("generateResetToken", generateResetToken),
    path("checkResetToken", checkResetToken),
    path("updatePassWord", updatePassWord),

    path("getNotification", getNotification),
    path("markNotifAsRead/<notifId>", markNotifAsRead),
    path("deleteNotification/<notifId>", deleteNotification),

    path("getSettings/<slug>", getSettings),
]