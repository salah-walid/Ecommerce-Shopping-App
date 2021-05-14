import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/models/categoryData.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:ecom/locator.dart';
import 'package:dartz/dartz.dart';

class ShopeeViewModel extends BaseModel {
  ApiService _apiService = locator<ApiService>();

  bool productsAreLoading =false;
  Either<Failure, List<ProductData>> products;

  bool topSalesAreLoading =false;
  Either<Failure, List<ProductData>> topSales;

  bool categoriesAreLoading =false;
  Either<Failure, List<CategoryData>> categories;

  Future getProducts() async{
    
    productsAreLoading = true;
    notifyListeners();
    
    await Task(
      () => _apiService.getDatas<ProductData>(
        urlPath: "backend/getProducts", 
        perItemCreation: (item) => ProductData.fromMap(item)
      )
    )
      .attempt()
      .mapLeftToFailure()
      .run()
      .then((value) => products = value);
    
    productsAreLoading = false;
    notifyListeners();
  }

  Future getTopSales() async{
    
    topSalesAreLoading = true;
    notifyListeners();
    
    await Task(
      () => _apiService.getDatas<ProductData>(
        urlPath: "backend/getTopSales", 
        perItemCreation: (item) => ProductData.fromMap(item)
      )
    )
      .attempt()
      .mapLeftToFailure()
      .run()
      .then((value) => topSales = value);
    
    topSalesAreLoading = false;
    notifyListeners();
  }

  Future getCategories() async{
    
    categoriesAreLoading = true;
    notifyListeners();
    
    await Task(
      () => _apiService.getDatas<CategoryData>(
        urlPath: "backend/getCategories", 
        perItemCreation: (item) => CategoryData.fromMap(item)
      )
    )
      .attempt()
      .mapLeftToFailure()
      .run()
      .then((value) => categories = value);
    
    categoriesAreLoading = false;
    notifyListeners();
  }

  Future init() {
  
    var futures = <Future>[];

    futures.add(getProducts());
    futures.add(getTopSales());
    futures.add(getCategories());

    return Future.wait(futures);
  }
  
}