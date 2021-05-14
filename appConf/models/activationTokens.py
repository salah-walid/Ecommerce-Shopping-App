from django.db import models

from .user import User

class accountActivationToken(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    token = models.CharField(max_length=255, blank=True, null=False)