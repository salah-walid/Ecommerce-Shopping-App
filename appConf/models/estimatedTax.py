from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator

class estimatedTax(models.Model):
    taxPercentage = models.FloatField(default=3, validators=[MinValueValidator(0), MaxValueValidator(100)],)

    def __str__(self):
        return "Estimated tax"