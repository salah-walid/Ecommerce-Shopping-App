from rest_framework import serializers

from backend.models.reviews import reviews
from appConf.serializers.userSerializer import userSimplifiedSerialiser


class reviewsSerializer(serializers.ModelSerializer):

    class Meta:
        model = reviews
        fields = ('id', 'content', 'stars', 'user', 'product')
        extra_kwargs = {'product': {'write_only': True}}

    def to_representation(self, instance):
        self.fields['user'] = userSimplifiedSerialiser(read_only=True)
        return super(reviewsSerializer, self).to_representation(instance)

