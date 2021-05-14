from django.db import models

class pointMultiplier(models.Model):
    multiplier = models.FloatField(default=0.5)

    def __str__(self):
        return "Point multilier"