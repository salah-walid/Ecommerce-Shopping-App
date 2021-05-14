from rest_framework import serializers
from backend.models.productOrderData import productOrderData

class productsOrderSerializer(serializers.ModelSerializer):

    class Meta:
        model = productOrderData
        fields = ('__all__')

class productsOrderSerializerDetailed(serializers.ModelSerializer):
    from .productSerializer import productSerializer
    from .uomSerializer import UomSerializer
    from .variationsOptionsSerializer import VariationsOptionsSerializer
    
    product = productSerializer(read_only=True)
    uom = UomSerializer(read_only=True)
    chosenVariations = VariationsOptionsSerializer(read_only=True, many=True)

    class Meta:
        model = productOrderData
        fields = ('__all__')