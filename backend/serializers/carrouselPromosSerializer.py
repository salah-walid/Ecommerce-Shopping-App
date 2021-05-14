from rest_framework import serializers
from backend.models.carrouselPromos import carrouselPromo
from .productSerializer import productSerializer

class carrouselPromoSerializer(serializers.ModelSerializer):

    class Meta:
        model = carrouselPromo
        fields = ('__all__')