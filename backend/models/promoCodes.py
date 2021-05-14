from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator

class promoCode(models.Model):
    title = models.CharField(max_length=40, unique=True, blank=False, null=False)
    code = models.CharField(max_length=40, blank=False, null=False)
    promo = models.FloatField(default=0, validators=[MinValueValidator(0)])

    def __str__(self):
        return self.title
