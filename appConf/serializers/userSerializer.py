from appConf.models.user import User

from rest_framework import serializers

from backend.serializers.orderSerializer import orderDataSerializerDetailed
from backend.models.orderData import orderData

class userSimplifiedSerialiser(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'id',
            'username', 
            'userPic', 
        )

class userSerializer(serializers.ModelSerializer):
    orders = serializers.SerializerMethodField("get_user_order")
    userPic = serializers.ImageField(required=False, allow_null=True)

    class Meta:
        model = User
        fields = (
            'id',
            'username', 
            'password', 
            'email', 
            'userPic', 
            'points', 
            'billingAdress', 
            'deliveryAdress', 
            'orders',

            'billingCity',
            'billingState',
            'billingZipCode',
            'billingCountry',
            'billingMobileNumber',

            'deliveryCity',
            'deliveryState',
            'deliveryZipCode',
            'deliveryCountry',
            'deliveryMobileNumber',
        )
        extra_kwargs = {'password': {'write_only': True}, 'userPic': {'required': False}}

    def get_user_order(self, obj):
        orders = orderData.objects.filter(user=obj)
        serialized = orderDataSerializerDetailed(orders, context={'request': self.context.get("request")}, many=True)
        return serialized.data
