from rest_framework import serializers
from backend.models.variation import Variations

from .variationsOptionsSerializer import VariationsOptionsSerializer

class VariationSerializer(serializers.ModelSerializer):

    options = VariationsOptionsSerializer(read_only=True, many=True)

    class Meta:
        model = Variations
        fields = ('__all__')