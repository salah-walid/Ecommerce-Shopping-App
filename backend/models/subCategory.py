from django.db import models

from backend.utils import subCategories_path_and_rename

from backend.models.category import category

class subCategory(models.Model):
    title = models.CharField(max_length=40, unique=False)
    image = models.ImageField(upload_to=subCategories_path_and_rename, blank=True, null=True)
    categories = models.ForeignKey(category, on_delete=models.CASCADE)

    def __str__(self):
        return self.title