from django.db import models

class VariationOptions(models.Model):
    content = models.CharField(max_length=40, unique=True)

    def __str__(self):
        return self.content