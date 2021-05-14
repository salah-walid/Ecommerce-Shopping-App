from rest_framework import serializers
from backend.models.product import product, image
from .uomSerializer import UomSerializer
from .variationsSerializer import VariationSerializer

class imageSerializer(serializers.ModelSerializer):

    class Meta:
        model = image
        fields = ('__all__')


class productSerializer(serializers.ModelSerializer):
    priceWithDiscount = serializers.SerializerMethodField("getPriceWithDiscount")
    newProduct = serializers.SerializerMethodField("getNewProduct")
    reviewList = serializers.SerializerMethodField("getProductReview")
    reviewsCount = serializers.SerializerMethodField("getReviewsCount")
    quantity = serializers.SerializerMethodField("getQuantity")
    images = imageSerializer(read_only=True, many=True)
    stars = serializers.SerializerMethodField("getAvreageReviews")
    uoms = UomSerializer(read_only=True, many=True)
    variations = VariationSerializer(read_only=True, many=True)

    class Meta:
        model = product
        fields = ('id',
                 'title',
                 'description',
                 'images',
                 'price',
                 'quantity',
                 'discount',
                 'stars',
                 'reviewsCount',
                 'priceWithDiscount',
                 'newProduct',
                 'reviewList',
                 'redeemPoints',
                 'uoms',
                 'variations',)

    def getReviewsCount(self, obj):
        return obj.reviewsCount()

    def getPriceWithDiscount(self, obj):
        return obj.priceWithDiscount()

    def getNewProduct(self, obj):
        return obj.newProduct()

    def getAvreageReviews(self, obj):
        return obj.getAvreageReviews()

    def getProductReview(self, obj):
        from backend.serializers.reviewsSerializer import reviewsSerializer
        return reviewsSerializer(obj.getReviews(), context=self.context, many=True).data

    def getAvailable(self, obj):
        return obj.available()

    def getQuantity(self, obj):
        return obj.quantity()