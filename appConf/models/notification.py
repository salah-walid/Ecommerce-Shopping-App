from django.db import models

from .user import User

class notification(models.Model):
    user = models.ManyToManyField(User, blank=True, related_name="Users_to_send_notif_to", help_text="Users to send notifications to")
    notificationRead = models.ManyToManyField(User, blank=True, related_name="Users_who_read_the_notif", help_text="Users who read the notification")
    title = models.CharField(max_length=50, blank=False, null=False)
    content = models.TextField(blank=False, null=False)
    hiden = models.BooleanField(default=False)

    def __str__(self):
        return self.title + " - " + str([usr.username + ", " for usr in self.user.all()])