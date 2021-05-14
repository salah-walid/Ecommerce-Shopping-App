import 'package:ecom/UI/views/addReview.dart';
import 'package:ecom/UI/views/cartView.dart';
import 'package:ecom/UI/views/categoryView.dart';
import 'package:ecom/UI/views/checkOut.dart';
import 'package:ecom/UI/views/forgotPasswordView.dart';
import 'package:ecom/UI/views/homePage.dart';
import 'package:ecom/UI/views/imageFullScreenHero.dart';
import 'package:ecom/UI/views/loginView.dart';
import 'package:ecom/UI/views/moreView.dart';
import 'package:ecom/UI/views/notificationView.dart';
import 'package:ecom/UI/views/ordersView.dart';
import 'package:ecom/UI/views/phoneVerificationView.dart';
import 'package:ecom/UI/views/productDetail.dart';
import 'package:ecom/UI/views/redeemPointsView.dart';
import 'package:ecom/UI/views/searchView.dart';
import 'package:ecom/UI/views/splashScreenView.dart';
import 'package:ecom/UI/views/registerView.dart';
import 'package:ecom/UI/views/subCategoryView.dart';
import 'package:ecom/UI/views/termsAndConditions.dart';
import 'package:ecom/core/models/categoryData.dart';
import 'package:ecom/core/models/imagesData.dart';
import 'package:ecom/core/models/notificationData.dart';
import 'package:ecom/core/models/orderState.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:ecom/core/models/subCategoryData.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:ecom/core/models/orderData.dart';
import 'package:ecom/UI/views/orderViewDetail.dart';
import 'package:flutter/material.dart';


class RoutesManager {
  static const String splashScreen = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String homePage = "/homePage";
  static const String productDetail = "/productDetail";
  static const String productDetailRedeem = "/productDetailRedeem";
  static const String imageFullScreen = "/imgFullScreen";
  static const String category = "/category";
  static const String categoryRedeeming = "/categoryRedeeming";
  static const String subCategory = "/subCategory";
  static const String subCategoryRedeeming = "/subCategoryRedeeming";
  static const String shoppingCart = "/shoppingCart";
  static const String search = "/search";
  static const String searchForRedeeming = "/searchForRedeem";
  static const String checkOut = "/checkOut";
  static const String forgotPassword = "/forgotPassword";
  static const String addReview = "/addReview";
  static const String termsAndConditions = "/termsAndConditions";
  static const String orders = "/orders";
  static const String orderViewDetail = '/ordViewDetail';
  static const String moreView = "/more";
  static const String moreViewRedeem = "/moreR";
  static const String redeemPointsView = "/redPV";
  static const String notification = "/notif";
  static const String phoneVerification = "/phoneVerification";

  static Map<String, Widget Function(BuildContext)> generateRoutes(){

    return {
      RoutesManager.splashScreen: (_) => SplashScreenView(),
      RoutesManager.login: (_) => LoginView(),
      RoutesManager.register: (_) => RegisterView(),
      RoutesManager.homePage: (_) => HomePage(),
      RoutesManager.shoppingCart: (_) => CartView(),
      RoutesManager.checkOut: (_) => CheckOut(),
      RoutesManager.forgotPassword: (_) => ForgotPasswordView(),
      RoutesManager.termsAndConditions: (_) => TermsAndConfitions(),
      RoutesManager.redeemPointsView: (_) => RedeemPointsView(),

      RoutesManager.orders: (context) {
        OrderState orderState = ModalRoute.of(context).settings.arguments as OrderState;
        return OrderView(orderState: orderState,);
      },

      RoutesManager.addReview: (context) {
        ProductOrderData productData = ModalRoute.of(context).settings.arguments as ProductOrderData;
        return AddReview(productData: productData,);
      },
      
      RoutesManager.imageFullScreen: (context) {
        ImageData imageUrl = ModalRoute.of(context).settings.arguments as ImageData;
        return ImageFullScreenHero(image: imageUrl,);
      },

      RoutesManager.productDetailRedeem: (context) {
        ProductData productData = ModalRoute.of(context).settings.arguments as ProductData;
        return ProductDetail(productData: productData, isRedeeming: true,);
      },

      RoutesManager.productDetail: (context) {
        ProductData productData = ModalRoute.of(context).settings.arguments as ProductData;
        return ProductDetail(productData: productData,);
      },

      RoutesManager.category: (context) {
        CategoryData categoryData = ModalRoute.of(context).settings.arguments as CategoryData;
        return CategoryView(categoryData: categoryData,);
      },

      RoutesManager.categoryRedeeming: (context) {
        CategoryData categoryData = ModalRoute.of(context).settings.arguments as CategoryData;
        return CategoryView(categoryData: categoryData, forRedeeming: true,);
      },

      RoutesManager.subCategory: (context) {
        SubCategoryData subCategoryData = ModalRoute.of(context).settings.arguments as SubCategoryData;
        return SubCategoryView(subCategoryData: subCategoryData,);
      },

      RoutesManager.subCategoryRedeeming: (context) {
        SubCategoryData subCategoryData = ModalRoute.of(context).settings.arguments as SubCategoryData;
        return SubCategoryView(subCategoryData: subCategoryData, forRedeeming: true,);
      }, 

      RoutesManager.search: (context) {
        String search = ModalRoute.of(context).settings.arguments as String;
        return SearchView(search: search,);
      },

      RoutesManager.searchForRedeeming: (context) {
        String search = ModalRoute.of(context).settings.arguments as String;
        return SearchView(search: search, forRedeaming: true,);
      },

      RoutesManager.orderViewDetail: (context){
        OrderData order = ModalRoute.of(context).settings.arguments as OrderData;
        return OrderViewDetail(orderData: order,);
      },

      RoutesManager.moreView: (context){
        List args = ModalRoute.of(context).settings.arguments as List;
        return MoreView(title: args[0], products: args[1],);
      },

      RoutesManager.moreViewRedeem: (context){
        List args = ModalRoute.of(context).settings.arguments as List;
        return MoreView(title: args[0], products: args[1], isRedeeming : true);
      },

      RoutesManager.notification: (context){
        NotificationData notificationData = ModalRoute.of(context).settings.arguments as NotificationData;
        return NotificationView(notificationData: notificationData);
      },

      RoutesManager.phoneVerification: (context){
        String token = ModalRoute.of(context).settings.arguments as String;
        return PhoneVerificationView(token: token,);
      }
    };
    
  }
}
