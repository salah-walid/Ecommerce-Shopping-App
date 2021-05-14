from django.urls import path
from .views import get_products, searchProducts, get_topSales, get_product
from .views import get_orders, post_orders, refund_order, orderCalculateTotal
from .views import get_categories
from .views import check_promoCode
from .views import get_carrouselPromos
from .views import postReview

urlpatterns = [
    path("getProducts", get_products),
    path("get_product/<product_id>", get_product),
    path("getTopSales", get_topSales),
    path("searchProduct/<product_name>", searchProducts),

    path("getOrders", get_orders),
    path("postOrders", post_orders),
    path("refund_order/<order_id>", refund_order),
    path("orderCalculateTotal", orderCalculateTotal),

    path("getCategories", get_categories),

    path("checkPromoCode", check_promoCode),

    path("getCarrouselPromo", get_carrouselPromos),

    path("postReview", postReview),
]
