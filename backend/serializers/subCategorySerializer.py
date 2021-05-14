from rest_framework import serializers
from backend.models.subCategory import subCategory
from backend.models.product import product
from .productSerializer import productSerializer

class subCategorySerializer(serializers.ModelSerializer):
    topSales = serializers.SerializerMethodField("get_top_sales")
    products = serializers.SerializerMethodField("get_products")
    
    class Meta:
        model = subCategory
        fields = ("id", "title", "image", "topSales", "products")
    
    def get_top_sales(self, obj):
        from backend.models.SalesAndBalance import SalesAndBalance
        sales = SalesAndBalance.objects.filter(chooseProduct__subCategories=obj).order_by("-totalSales")[:10]
        productIds = [pId.chooseProduct.id for pId in sales]
        return productSerializer(product.objects.filter(id__in=productIds), context=self.context, many=True).data

    def get_products(self, obj):
        return productSerializer(product.objects.filter(subCategories=obj) , context=self.context, many=True).data