from django.db import models

class GeneralSettings(models.Model):
    newProductCap = models.PositiveIntegerField(default=30)

    def __str__(self):
        return "Config"