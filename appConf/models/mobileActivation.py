from django.db import models

from .user import User

class mobileActivation(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    code = models.CharField(max_length=6, blank=True)

    def __str__(self):
        return "Activation for user : {}".format(self.user.username)

