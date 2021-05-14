from rest_framework import serializers

from appConf.models.notification import notification
from appConf.serializers.userSerializer import userSimplifiedSerialiser

class notificationSerializer(serializers.ModelSerializer):
    isRead = serializers.SerializerMethodField("is_read")

    class Meta:
        model = notification
        fields = ('id' ,'title', "content", "isRead")

    def is_read(self, obj):
        usr = self.context.get("request").user
        return usr in obj.notificationRead.all()