from django.db import models

class DeliveryCart(models.Model):
    fromValue = models.FloatField(default=0)
    toValue = models.FloatField(default=0)
    price = models.FloatField(default=0)

    def __str__(self):
        return "from {} to {} => RM{}".format(self.fromValue, self.toValue, self.price)