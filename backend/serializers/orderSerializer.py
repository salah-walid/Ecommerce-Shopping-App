from rest_framework import serializers
from backend.models.orderData import orderData

from appConf.models.pointMultiplier import pointMultiplier

from .productOrderDataSerializer import productsOrderSerializer, productsOrderSerializerDetailed

class orderDataSerializer(serializers.ModelSerializer):
    orderList = serializers.SerializerMethodField("getOrderList")

    def getOrderList(self, obj):
        return productsOrderSerializer(obj.orderList(), many=True).data

    class Meta:
        model = orderData
        fields = ('__all__')

    def create(self, validated_data):
        
        order = orderData.objects.create(**validated_data)

        multiplier = pointMultiplier.objects.first().multiplier
        order.user.points += int(order.total * multiplier)
        order.user.totalPoints += int(order.total * multiplier)
        order.user.save()

        return order

class orderDataSerializerDetailed(serializers.ModelSerializer):
    orderList = serializers.SerializerMethodField("getOrderList")

    def getOrderList(self, obj):
        return productsOrderSerializerDetailed(obj.orderList(), context={'request': self.context.get("request")}, many=True).data

    class Meta:
        model = orderData
        fields = ('__all__')
