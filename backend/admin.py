from datetime import datetime
from django import template

from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse, path

from .models.product import product, image
from .models.productOrderData import productOrderData
from .models.orderData import orderData
from .models.category import category
from .models.subCategory import subCategory
from .models.promoCodes import promoCode
from .models.carrouselPromos import carrouselPromo
from .models.reviews import reviews
from .models.stripeCharge import stripeCharge
from .models.redeemed import redeemed
from .models.printManage import printManage
from .models.uom import UOM
from .models.variation import Variations
from .models.variationOptions import VariationOptions
from .models.deliveryCart import DeliveryCart
from .models.SalesAndBalance import SalesAndBalance
from .models.stock import Stock

from django.http import HttpResponse, response
from django.template import loader
from .utils import queryset_to_workbook

# Register your models here.
class productModelAdmin(admin.ModelAdmin):
    readonly_fields = ['priceWithDiscount', 'newProduct', "reviewsCount"]
    list_filter = ["title", "price", "categories", "subCategories"]
    list_display = [f.name for f in product._meta.fields]
    actions = ['print_list']

    def print_list(modeladmin, request, queryset):
        columns = [f.name for f in product._meta.fields]
        workbook = queryset_to_workbook(queryset, columns)
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="product_list_{}.xls"'.format(datetime.now())
        workbook.save(response)
        return response
    
    print_list.short_description = "Print to excel"

    def reviewsCount(self, obj):
        return obj.reviewsCount()

    def priceWithDiscount(self, obj):
        return obj.priceWithDiscount()
    
    def newProduct(self, obj):
        return obj.newProduct()
    
    def uoms(self, obj):
        return ["{} {} ({} UNIT) ({})".format(u.id, u.unit, u.value, u.product.id) for u in obj.uoms()]

admin.site.register(product, productModelAdmin)

#!-----------------------------------------------------------------------------------------------------------------------------------------

admin.site.register(image)


#!-----------------------------------------------------------------------------------------------------------------------------------------

class productOrderModelAdmin(admin.ModelAdmin):
    actions = ['print_list']
    list_filter = ["product", "reviewed", "product", "isRedeemed", "price"]
    list_display = [f.name for f in productOrderData._meta.fields]

    def print_list(modeladmin, request, queryset):
        columns = [f.name for f in productOrderData._meta.fields]
        workbook = queryset_to_workbook(queryset, columns)
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="productOrderData_list_{}.xls"'.format(datetime.now())
        workbook.save(response)
        return response
    print_list.short_description = "Print to excel"

admin.site.register(productOrderData, productOrderModelAdmin)


#!-----------------------------------------------------------------------------------------------------------------------------------------

class orderDataAdminModel(admin.ModelAdmin):
    list_display = [
        'order_number',
        'order_actions',
    ] + [f.name for f in orderData._meta.fields]
    actions = ["print_invoices", "print_list", "printBulk"]

    readonly_fields = ["productOrderList"]
    list_filter = ["user", "creationDate", "orderState"]

    def print_list(modeladmin, request, queryset):
        columns = [f.name for f in orderData._meta.fields]
        workbook = queryset_to_workbook(queryset, columns)
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="productOrderData_list_{}.xls"'.format(datetime.now())
        workbook.save(response)
        return response
    print_list.short_description = "Print to excel"

    #TODO delete this function if you want to not make order state read only
    def get_readonly_fields(self, request, obj=None):
        readonly_fields = super(orderDataAdminModel, self).get_readonly_fields(request, obj=obj)
        if not request.user.is_superuser:
            readonly_fields.append("orderState")
        return readonly_fields

    def get_queryset(self, request):
        qs = super(orderDataAdminModel, self).get_queryset(request)
        self.request = request
        return qs

    def productOrderList(self, obj):
        return [p.id for p in productOrderData.objects.filter(order=obj)]

    def order_number(self, obj):
        return "#ORD" + str(obj.id).zfill(7)
    order_number.short_description = "Order number"


    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path(
                '<order_id>/invoice/',
                self.admin_site.admin_view(self.print_invoice),
                name='order-print-invoice',
            ),
        ]
        return custom_urls + urls
    
    def printBulk(modeladmin, request, queryset):
        bulk = []

        for order in queryset:
            printM, created = printManage.objects.get_or_create(user=request.user, order=order)

            if not created or order.orderState != 0 or not request.user.is_superuser:
                continue

            if order.orderState == 0:
                order.orderState = 1
                order.save()

            bulk.append(
                {
                    "order" : order,
                    "orderNumber": "#ORD" + str(order.id).zfill(7),
                    "invoiceNumber" : "#" + str(printM.id).zfill(7),
                }
            )
        
        htmlInvoice = loader.get_template("VED/invoice-A4.html")
        context = {
            "context" : bulk
        }
        return HttpResponse(htmlInvoice.render(context, request))
    printBulk.short_description = 'Print invoices in bulk'
    
    def print_invoices(modeladmin, request, queryset):
        list_prints = []
        
        for order in queryset:
            printM, created = printManage.objects.get_or_create(user=request.user, order=order)

            if not created or order.orderState != 0 or not request.user.is_superuser:
                continue

            if order.orderState == 0:
                order.orderState = 1
                order.save()
            
            list_prints.append(
                {
                    "link": reverse('admin:print_manager_order-print-invoice', args=[printM.pk]),
                    "name": "#" + str(printM.id).zfill(7)
                }
            )
        
        htmlInvoice = loader.get_template("VED/listinvoices.html")
        context = {
            "prints" : list_prints,
        }
        return HttpResponse(htmlInvoice.render(context, request))
    print_invoices.short_description = 'Print orders'


    def print_invoice(self, request, order_id, *args, **kwargs):
        order = orderData.objects.get(id=order_id)

        printM, created = printManage.objects.get_or_create(user=request.user, order=order)
        if not created or order.orderState != 0 or not request.user.is_superuser:
            return HttpResponse("You can't print this invoice")

        if order.orderState == 0:
            order.orderState = 1
            order.save()

        htmlInvoice = loader.get_template("VED/invoice-A4.html")
        context = {
            "context" : [
                {
                    "order" : order,
                    "orderNumber": "#ORD" + str(order.id).zfill(7),
                    "invoiceNumber" : "#" + str(printM.id).zfill(7),
                }
            ]
        }
        return HttpResponse(htmlInvoice.render(context, request))


    def order_actions(self, obj):
        if obj.orderState != 0 or not self.request.user.is_superuser:
            return ""
        
        try:
            printManage.objects.get(order=obj)
            return ""
        except printManage.DoesNotExist:
            return format_html(
                '<a class="button" href="{}">Print invoice</a>&nbsp;',
                reverse('admin:order-print-invoice', args=[obj.pk]),
            )
    order_actions.short_description = 'Order actions'

admin.site.register(orderData, orderDataAdminModel)


#!-----------------------------------------------------------------------------------------------------------------------------------------

class categoryModelAdmin(admin.ModelAdmin):
    list_display = [f.name for f in category._meta.fields]

    actions = ['print_list']
    list_filter = ['title']

    def print_list(modeladmin, request, queryset):
        columns = [f.name for f in category._meta.fields]
        workbook = queryset_to_workbook(queryset, columns)
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="category_list_{}.xls"'.format(datetime.now())
        workbook.save(response)
        return response
    print_list.short_description = "Print to excel"

admin.site.register(category, categoryModelAdmin)


#!-----------------------------------------------------------------------------------------------------------------------------------------

class subCategoryModelAdmin(admin.ModelAdmin):
    actions = ['print_list']
    list_filter = ["title", "categories"]
    list_display = [f.name for f in subCategory._meta.fields]

    def print_list(modeladmin, request, queryset):
        columns = [f.name for f in subCategory._meta.fields]
        workbook = queryset_to_workbook(queryset, columns)
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="subCategories_list_{}.xls"'.format(datetime.now())
        workbook.save(response)
        return response
    print_list.short_description = "Print to excel"

admin.site.register(subCategory, subCategoryModelAdmin)


#!-----------------------------------------------------------------------------------------------------------------------------------------

class promoCodeModelAdmin(admin.ModelAdmin):
    actions = ['print_list']
    list_display = [f.name for f in promoCode._meta.fields]
    list_filter = ["promo", "title"]

    def print_list(modeladmin, request, queryset):
        columns = [f.name for f in promoCode._meta.fields]
        workbook = queryset_to_workbook(queryset, columns)
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="promo_code_list_{}.xls"'.format(datetime.now())
        workbook.save(response)
        return response
    print_list.short_description = "Print to excel"

admin.site.register(promoCode, promoCodeModelAdmin)


#!-----------------------------------------------------------------------------------------------------------------------------------------


admin.site.register(carrouselPromo)


#!-----------------------------------------------------------------------------------------------------------------------------------------


class reviewModelAdmin(admin.ModelAdmin):
    actions = ['print_list']
    list_display = [f.name for f in reviews._meta.fields]
    list_filter = ["product", "user", "stars"]

    def print_list(modeladmin, request, queryset):
        columns = [f.name for f in reviews._meta.fields]
        workbook = queryset_to_workbook(queryset, columns)
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="reviews_list_{}.xls"'.format(datetime.now())
        workbook.save(response)
        return response
    print_list.short_description = "Print to excel"

admin.site.register(reviews, reviewModelAdmin)


#!-----------------------------------------------------------------------------------------------------------------------------------------


class stripeChargeModelAdmin(admin.ModelAdmin):
    actions = ['print_list']
    list_display = [f.name for f in stripeCharge._meta.fields]
    list_filter = ["order"]

    def print_list(modeladmin, request, queryset):
        columns = [f.name for f in stripeCharge._meta.fields]
        workbook = queryset_to_workbook(queryset, columns)
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="stripe_charge_list_{}.xls"'.format(datetime.now())
        workbook.save(response)
        return response
    print_list.short_description = "Print to excel"

admin.site.register(stripeCharge, stripeChargeModelAdmin)


#!-----------------------------------------------------------------------------------------------------------------------------------------


class redeemedModelAdmin(admin.ModelAdmin):
    actions = ['print_list']
    list_display = [f.name for f in redeemed._meta.fields]

    def print_list(modeladmin, request, queryset):
        columns = [f.name for f in redeemed._meta.fields]
        workbook = queryset_to_workbook(queryset, columns)
        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="redeemed_list_{}.xls"'.format(datetime.now())
        workbook.save(response)
        return response
    print_list.short_description = "Print to excel"

admin.site.register(redeemed, redeemedModelAdmin)


#!-----------------------------------------------------------------------------------------------------------------------------------------


class printManageAdminModel(admin.ModelAdmin):

    list_display = (
        'order',
        'user',
        'printDate',
        'order_actions'
    )
    actions = [
        'printBulk'
    ]

    def has_change_permission(self, request, obj=None):
        return False
    
    def has_delete_permission(self, request, obj=None):
        return request.user.is_superuser

    def has_add_permission(self, request):
        return False

    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path(
                '<print_id>/invoice/',
                self.admin_site.admin_view(self.print_invoice),
                name='print_manager_order-print-invoice',
            ),
        ]
        return custom_urls + urls

    def printBulk(modeladmin, request, queryset):
        bulk = []

        for printM in queryset:
            bulk.append(
                {
                    "order" : printM.order,
                    "orderNumber": "#ORD" + str(printM.order.id).zfill(7),
                    "invoiceNumber" : "#" + str(printM.id).zfill(7),
                }
            )
        
        htmlInvoice = loader.get_template("VED/invoice-A4.html")
        context = {
            "context" : bulk
        }
        return HttpResponse(htmlInvoice.render(context, request))
    printBulk.short_description = 'Print invoices in bulk'
    
    def print_invoice(self, request, print_id, *args, **kwargs):
        printM = printManage.objects.get(id=print_id)

        htmlInvoice = loader.get_template("VED/invoice-A4.html")
        context = {
            "context" : [
                {
                    "order" : printM.order,
                    "orderNumber": "#ORD" + str(printM.order.id).zfill(7),
                    "invoiceNumber" : "#" + str(printM.id).zfill(7),
                }
            ]
        }
        return HttpResponse(htmlInvoice.render(context, request))


    def order_actions(self, obj):
        return format_html(
            '<a class="button" href="{}">Print invoice</a>&nbsp;',
            reverse('admin:print_manager_order-print-invoice', args=[obj.pk]),
        )
    order_actions.short_description = 'Order actions'

    

admin.site.register(printManage, printManageAdminModel)

#!-----------------------------------------------------------------------------------------------------------------------------------------

admin.site.register(UOM)

#!-----------------------------------------------------------------------------------------------------------------------------------------

admin.site.register(Variations)

#!-----------------------------------------------------------------------------------------------------------------------------------------

admin.site.register(VariationOptions)

#!-----------------------------------------------------------------------------------------------------------------------------------------

admin.site.register(DeliveryCart)

#!-----------------------------------------------------------------------------------------------------------------------------------------
class SalesAndBalanceAdmin(admin.ModelAdmin):
    list_display = [f.name for f in SalesAndBalance._meta.fields]

admin.site.register(SalesAndBalance, SalesAndBalanceAdmin)

#!-----------------------------------------------------------------------------------------------------------------------------------------

class StockAdmin(admin.ModelAdmin):
    list_display = [f.name for f in Stock._meta.fields]

admin.site.register(Stock, StockAdmin)
