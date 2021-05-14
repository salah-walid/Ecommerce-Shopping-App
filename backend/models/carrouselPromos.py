from django.db import models

from backend.utils import carrouselImages_path_and_rename

class carrouselPromo(models.Model):
    title = models.CharField(max_length=40, unique=True, null=False, blank=False)
    image = models.ImageField(upload_to=carrouselImages_path_and_rename, blank=False, null=False)

    def __str__(self):
        return self.title