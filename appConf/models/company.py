from django.db import models

class company(models.Model):
    name = models.CharField(max_length=40, blank=True)
    registrationNumber = models.CharField(max_length=60, blank=True)

    companyAdress = models.TextField(blank=True)
    companyCity = models.CharField(max_length=40, blank=True)
    companyState = models.CharField(max_length=40, blank=True)
    companyZipCode = models.CharField(max_length=40, blank=True)
    companyCountry = models.CharField(max_length=40, blank=True)

    companyPhoneNumber = models.TextField(blank=True)

    warehouseAdress = models.TextField(blank=True)
    warehouseCity = models.CharField(max_length=40, blank=True)
    warehouseState = models.CharField(max_length=40, blank=True)
    warehouseZipCode = models.CharField(max_length=40, blank=True)
    warehouseCountry = models.CharField(max_length=40, blank=True)

    warehousePhoneNumber = models.TextField(blank=True)

    maxDistanceForSameDayDelivery = models.FloatField(default=50000)

    def __str__(self):
        return "Company"