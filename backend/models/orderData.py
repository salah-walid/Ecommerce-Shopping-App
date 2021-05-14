from datetime import datetime

from django.db import models
from django.conf import settings
from django.db.models.signals import pre_save
from django.dispatch import receiver

from django.core.validators import MaxValueValidator, MinValueValidator

class orderData(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    creationDate = models.DateTimeField(default=datetime.now, blank=False)
    orderState = models.IntegerField(default=0, 
                                    validators=[MinValueValidator(0), MaxValueValidator(6)], 
                                    choices=(
                                        (0, 'Accepted'),
                                        (1, 'In progress'),
                                        (2, 'Shipped'),
                                        (3, 'Delivered'),
                                        (4, 'Completed'),
                                        (5, 'Canceled by user'),
                                        (6, 'Canceled by admin'),
                                    ))
    refundId = models.CharField(max_length=60, default="", blank=True, null=False)
    courierNoteNumber = models.CharField(max_length=60, default="", blank=True, null=False)

    #orderList = models.ManyToManyField(productOrderData)
    promoCode = models.CharField(max_length=40, blank=True)
    sameDayDelivery = models.BooleanField(default=False)

    subTotal = models.FloatField(default=0)
    promo = models.FloatField(default=0)
    shipping = models.FloatField(default=0)
    estimatedTax = models.FloatField(default=0)
    total = models.FloatField(default=0)

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

    def orderList(self):
        from .productOrderData import productOrderData
        return productOrderData.objects.filter(order=self)

    def __str__(self):
        return "#ORD" + str(self.id).zfill(7)

@receiver(pre_save, sender=orderData)
def _post_save_receiver(sender, instance, **kwargs):
    try:
        obj = sender.objects.get(pk=instance.pk)
    except sender.DoesNotExist:
        return
    else:
        if not obj.courierNoteNumber and instance.courierNoteNumber:
            instance.orderState = 2
