from django.db import models
from django.conf import settings
from django.core.validators import MaxValueValidator, MinValueValidator


class reviews(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=False)
    product = models.ForeignKey("backend.product", on_delete=models.CASCADE, null=False)

    content = models.TextField(blank=False, null=False)
    stars = models.IntegerField(default=5, validators=[MinValueValidator(0), MaxValueValidator(5)])

    def __str__(self):
        return "Comment on : " + self.product.title + " ,from user : " + self.user.username