from rest_framework import serializers

from backend.models.product import product

from .productSerializer import productSerializer
from .subCategorySerializer import subCategorySerializer

class categorySerializer(serializers.ModelSerializer):
    topSales = serializers.SerializerMethodField("get_top_sales")
    products = serializers.SerializerMethodField("get_products")
    subCategories = serializers.SerializerMethodField("get_subCategories")

    class Meta:
        from backend.models.category import category
        model = category
        fields = ("__all__")

    def get_top_sales(self, obj):
        from backend.models.SalesAndBalance import SalesAndBalance
        sales = SalesAndBalance.objects.filter(chooseProduct__categories=obj).order_by("-totalSales")[:10]
        productIds = [pId.chooseProduct.id for pId in sales]
        return productSerializer(product.objects.filter(id__in=productIds), context=self.context, many=True).data

    def get_products(self, obj):
        return productSerializer(product.objects.filter(categories=obj) , context=self.context, many=True).data

    def get_subCategories(self, obj):
        from backend.models.subCategory import subCategory
        return subCategorySerializer(subCategory.objects.filter(categories=obj), context=self.context, many=True).data