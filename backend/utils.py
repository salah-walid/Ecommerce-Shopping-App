import json
from appConf.models.estimatedTax import estimatedTax
from django.utils.deconstruct import deconstructible
import os
from uuid import uuid4
import datetime
import xlwt
from django.core.exceptions import ObjectDoesNotExist
from django.forms.utils import pretty_name
from django.db.models.fields.files import ImageFieldFile

@deconstructible
class PathAndRename(object):

    def __init__(self, sub_path):
        self.path = sub_path

    def __call__(self, instance, filename):
        ext = filename.split('.')[-1]
        # set filename as random string
        filename = '{}.{}'.format(uuid4().hex, ext)
        print(os.path.join(self.path, filename))
        # return the whole path to the file
        return os.path.join(self.path, filename)

products_path_and_rename = PathAndRename("products")
categories_path_and_rename = PathAndRename("products")
subCategories_path_and_rename = PathAndRename("subCategories")
carrouselImages_path_and_rename = PathAndRename("promos")

#!---------------------------------------------------------------------------

HEADER_SYTLE = xlwt.easyxf('font:bold on')
DEFAULT_STYLE = xlwt.easyxf()
CELL_STYLE_MAP = (
    (datetime.datetime, xlwt.easyxf(num_format_str="YYYY/MM/DD HH:MM")),
    (datetime.date, xlwt.easyxf(num_format_str='DD/MM/YYYY')),
    (datetime.time, xlwt.easyxf(num_format_str="HH:MM")),
    (bool, xlwt.easyxf(num_format_str="BOOLEAN")),
)


def multi_getattr(obj, attr, default=None):
    attributes = attr.split(".")

    for i in attributes:
        try:
            if obj._meta.get_field(i).choices:
                obj = getattr(obj, f"get_{i}_display")()
            else:
                obj = getattr(obj, i)
        except AttributeError:
            if default:
                return default
            else:
                raise

    return obj


def get_column_head(obj, name):
    names = name.split(".")

    tmp = ''

    for i in names:
        tmp += obj._meta.get_field(i).verbose_name
        tmp += '.'


    return pretty_name(tmp)


def get_column_cell(obj, name):
    try:
        attr = multi_getattr(obj, name)
    except ObjectDoesNotExist:
        return None

    if hasattr(attr, '_meta'):
        return str(attr).strip()
    elif hasattr(attr, 'all'):
        return ', '.join(str(x).strip() for x in attr.all())

    if isinstance(attr, datetime.datetime):
        from django.utils.timezone import localtime
        attr = localtime(attr)
        attr = attr.replace(tzinfo=None)
    elif isinstance(attr, ImageFieldFile):
        attr = attr.url

    return attr


def queryset_to_workbook(queryset,
                         columns,
                         header_style=HEADER_SYTLE,
                         default_style=DEFAULT_STYLE,
                         cell_style_map=CELL_STYLE_MAP):
    workbook = xlwt.Workbook()
    report_date = datetime.date.today()
    sheet_name = f"Export {report_date.strftime('%Y-%m-%d')}"
    sheet = workbook.add_sheet(sheet_name)

    obj = queryset.first()

    for num, column in enumerate(columns):
        value = get_column_head(obj, column)
        sheet.write(0, num, value, header_style)

    for x, obj in enumerate(queryset, start=1):
        for y, column in enumerate(columns):
            value = get_column_cell(obj, column)
            style = default_style

            for value_type, cell_style in cell_style_map:
                if isinstance(value, value_type):
                    style = cell_style

                    break
            sheet.write(x, y, value, style)

    return workbook

def calculateTotal(listOrder, sameDayDelivery, promoAmount):
    subTotal = float(0.0)
    total = float(0.0)
    shipping = float(0.0)
    tax = float(0.0)

    uomAmount = 0

    from backend.models.product import product
    from backend.models.uom import UOM

    for orderProduct in listOrder:
        price = product.objects.get(pk=orderProduct["product"]).priceWithDiscount()
        uom = UOM.objects.get(pk=orderProduct["uom"])
        if not orderProduct["isRedeemed"]:
            subTotal += orderProduct["quantity"] * price * uom.value

        uomAmount += uom.weight * orderProduct["quantity"]
    
    if sameDayDelivery:
        shipping += 30.0


    #! calculate products shipping charges
    from backend.models.deliveryCart import DeliveryCart
    deliveryC = DeliveryCart.objects.filter(fromValue__lte=uomAmount, toValue__gte=uomAmount).first()
    if deliveryC:
        shipping += deliveryC.price

    tax = subTotal * (estimatedTax.objects.first().taxPercentage / 100)

    total = (subTotal + tax) - promoAmount + shipping
    if total < 0:
        total = 0
    
    return subTotal, shipping, tax, total
