from django.db import models
from django.dispatch import receiver
from django.db.models.signals import post_save, post_delete

from .orderData import orderData
from .uom import UOM
from .variationOptions import VariationOptions

class productOrderData(models.Model):
    chosenSubProduct = models.IntegerField(default=0)
    uom = models.ForeignKey(UOM, on_delete=models.CASCADE, null=True)
    chosenVariations = models.ManyToManyField(VariationOptions, blank=True)

    quantity = models.PositiveIntegerField(default=0)
    price = models.FloatField(default=0)
    unitPrice = models.FloatField(default=0)

    product = models.ForeignKey("backend.product",null=True, on_delete=models.SET_NULL)
    reviewed = models.BooleanField(default=False, null=False)
    isRedeemed = models.BooleanField(default=False, null=False)
    order = models.ForeignKey(orderData, null=True, on_delete=models.CASCADE)

    def __str__(self):
        return "N°" + str(self.id) + " -- " + str(self.quantity) + " " + self.product.title + " - Variant " + str(self.chosenSubProduct)


@receiver(post_save, sender=productOrderData)
def _productOrderData_postSave(sender, instance, created, **kwargs):
    if created:
        instance.product.increment_sales(instance.quantity)

@receiver(post_delete, sender=productOrderData)
def _productOrderData_postDelete(sender, instance, **kwargs):
    instance.product.increment_sales(-instance.quantity)