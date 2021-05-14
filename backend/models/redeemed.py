from django.db import models

from .productOrderData import productOrderData
from appConf.models.user import User

class redeemed(models.Model):
    productOrder = models.ForeignKey(productOrderData, on_delete=models.CASCADE, null=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=False)

    pointsRedeemed = models.IntegerField(default=0)

    def __str__(self):
        return "{} points reddemed by {}".format(self.pointsRedeemed, self.user.username)
    
    def save(self, *args, **kwargs):
        if not self.pk:
            self.user.points -= self.pointsRedeemed
            self.user.save()

        super(redeemed, self).save(*args, **kwargs)