from datetime import date

from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator
from backend.utils import products_path_and_rename

from backend.models.reviews import reviews

from backend.models.category import category
from backend.models.subCategory import subCategory
from backend.models.uom import UOM
from backend.models.variation import Variations

from appConf.models.GeneralSettings import GeneralSettings

# Create your models here.

class image(models.Model):
    title = models.CharField(max_length=40, unique=False)
    image = models.ImageField(upload_to=products_path_and_rename ,blank=True, null=True)

    def __str__(self):
        return self.title

class product(models.Model):
    title = models.CharField(max_length=40, unique=False)
    description = models.TextField(default="", blank=True)
    creationDate = models.DateField(default=date.today)
    images = models.ManyToManyField(image)
    price = models.FloatField(default=0)
    discount = models.FloatField(default=0, validators=[MinValueValidator(0), MaxValueValidator(100)])
    redeemPoints = models.IntegerField(default=50)

    variations = models.ManyToManyField(Variations, blank=True)

    uoms = models.ManyToManyField(UOM, blank=False)

    categories = models.ManyToManyField(category)
    subCategories = models.ManyToManyField(subCategory)
    
    #! price with discount
    def priceWithDiscount(self):
        return self.price * (1 - (self.discount / 100))

    #! review count
    def reviewsCount(self):
        return reviews.objects.filter(product=self).count()

    #! reviews
    def getReviews(self):
        return reviews.objects.filter(product=self)

    #! new Product
    def newProduct(self):
        daysCap = GeneralSettings.objects.first().newProductCap
        return (date.today() - self.creationDate).days < daysCap

    #! get avreage review
    def getAvreageReviews(self):
        rev = reviews.objects.filter(product=self)
        
        if len(rev) == 0:
            return 0;
        
        totalReviews = 0
        for item in rev:
            totalReviews += item.stars
        
        return int(round(totalReviews / len(rev)))

    #! quantity
    def quantity(self):
        from .SalesAndBalance import SalesAndBalance
        sales, c = SalesAndBalance.objects.get_or_create(chooseProduct=self)
        return sales.balance

    def salesCount(self):
        from .SalesAndBalance import SalesAndBalance
        sales, c = SalesAndBalance.objects.get_or_create(chooseProduct=self)
        return sales.totalSales

    #! increment sales
    def increment_sales(self, quantity):
        from .SalesAndBalance import SalesAndBalance
        sales, c = SalesAndBalance.objects.get_or_create(chooseProduct=self)
        sales.balance -= quantity
        sales.totalSales += quantity

    def __str__(self):
        return str(self.id) + " - " + self.title

