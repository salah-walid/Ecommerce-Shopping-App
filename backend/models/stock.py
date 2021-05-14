from datetime import datetime

from django.db import models
from django.db.models.signals import pre_save
from django.dispatch import receiver

from .product import product
from .SalesAndBalance import SalesAndBalance

class Stock(models.Model):
    chooseProduct = models.ForeignKey(product, on_delete=models.CASCADE)
    stockIn = models.PositiveIntegerField(default=0)
    stockInDate = models.DateTimeField(default=datetime.now)

    def __str__(self) :
        return "{} stocks, for product {}, in {}".format(self.stockIn, self.chooseProduct, self.stockInDate)

@receiver(pre_save, sender=Stock)
def _stock_post_save_receiver(sender, instance, **kwargs):
    sales, c = SalesAndBalance.objects.get_or_create(chooseProduct=instance.chooseProduct)
    if not instance.pk:
        sales.balance += instance.stockIn
    else:
        oldStock = sender.objects.get(pk=instance.pk)
        sales.balance += instance.stockIn - oldStock.stockIn
    sales.save()