from django.db import models

class UOM(models.Model):
    unit = models.CharField(max_length=40, default="UNIT", blank=False, null=False)
    value = models.PositiveIntegerField(default=0)
    weight = models.FloatField(default=1)
    height = models.FloatField(default=1)
    width = models.FloatField(default=1)
    length = models.FloatField(default=1)

    def __str__(self):
        return "{} - {} ({} UNIT)".format(self.id, self.unit, self.value)