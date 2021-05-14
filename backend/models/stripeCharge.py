from django.db import models

from .orderData import orderData

class stripeCharge(models.Model):
    chargeId = models.CharField(max_length=50, blank=True)
    order = models.ForeignKey(orderData, on_delete=models.CASCADE)

    def __str__(self):
        return "#ORD" + str(self.order.id).zfill(7) + "'s charge"