from django.db import models

from backend.models.variationOptions import VariationOptions

class Variations(models.Model):
    title = models.CharField(max_length=40, blank=False, null=False)
    options = models.ManyToManyField(VariationOptions, blank=False)

    def __str__(self):
        return self.title