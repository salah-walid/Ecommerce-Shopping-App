from django.db.models import fields
from rest_framework import serializers
from backend.models.uom import UOM

class UomSerializer(serializers.ModelSerializer):

    class Meta:
        model = UOM
        fields = ('id',
                  'unit',
                  'value',
                  'weight',
                  'height',
                  'width',
                  'length',
                )