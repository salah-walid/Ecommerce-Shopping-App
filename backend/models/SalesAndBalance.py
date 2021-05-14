from django.db import models

from .product import product

class SalesAndBalance(models.Model):
    chooseProduct = models.OneToOneField(product, on_delete=models.CASCADE)
    totalSales = models.PositiveIntegerField(default=0)
    balance = models.IntegerField(default=0)

    def __str__(self):
        return "{}'s balance".format(self.chooseProduct)
