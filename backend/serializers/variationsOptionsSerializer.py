from rest_framework import serializers
from backend.models.variationOptions import VariationOptions

class VariationsOptionsSerializer(serializers.ModelSerializer):

    class Meta:
        model = VariationOptions
        fields = ('__all__')