from django.db import models

from backend.utils import categories_path_and_rename

class category(models.Model):
    title = models.CharField(max_length=40, unique=False)
    image = models.ImageField(upload_to=categories_path_and_rename, blank=True, null=True)

    def __str__(self):
        return self.title