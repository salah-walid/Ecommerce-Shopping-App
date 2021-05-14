from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
import os

from appConf.utils import user_pics_path_and_rename

class User(AbstractUser):
    phoneNumber = models.CharField(max_length=40, blank=True)
    userPic = models.ImageField(upload_to=user_pics_path_and_rename, default="user.png", null=True)
    points = models.IntegerField(default=0)
    totalPoints = models.IntegerField(default=0)
    email = models.EmailField(unique=True, blank=False, null=False)
    username = models.CharField(max_length=40, unique=True, null=False, blank=False)

    billingAdress = models.TextField(blank=True)
    billingCity = models.CharField(max_length=40, blank=True)
    billingState = models.CharField(max_length=40, blank=True)
    billingZipCode = models.CharField(max_length=40, blank=True)
    billingCountry = models.CharField(max_length=40, blank=True)
    billingMobileNumber = models.TextField(blank=True)

    deliveryAdress = models.TextField(blank=True)
    deliveryCity = models.CharField(max_length=40, blank=True)
    deliveryState = models.CharField(max_length=40, blank=True)
    deliveryZipCode = models.CharField(max_length=40, blank=True)
    deliveryCountry = models.CharField(max_length=40, blank=True)
    deliveryMobileNumber = models.TextField(blank=True)
    
    
    