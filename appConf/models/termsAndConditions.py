from django.db import models

class termsAndConditions(models.Model):
    terms = models.TextField(blank=True)

    def __str__(self):
        return "Terms and conditions"
