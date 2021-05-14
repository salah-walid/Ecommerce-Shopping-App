from django.db import models
from .orderData import orderData
from appConf.models.user import User
from django.utils import timezone

class printManage(models.Model):
    order = models.ForeignKey(orderData, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    printDate = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return "Print number {}, {} printed by {}".format(self.id ,self.order, self.user.username)