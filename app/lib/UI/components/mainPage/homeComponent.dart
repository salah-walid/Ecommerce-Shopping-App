import 'package:ecom/UI/components/SearchAppBar.dart';
import 'package:ecom/UI/components/carrouselBanner.dart';
import 'package:ecom/UI/components/categoryCard.dart';
import 'package:ecom/UI/components/productCard.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/homeComponentViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/categoryData.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:flutter/material.dart';

class HomeComponent extends StatefulWidget {
  const HomeComponent({Key key}) : super(key: key);

  @override
  _HomeComponentState createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeComponentViewModel>(
      viewModel: HomeComponentViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, _) => RefreshIndicator(
        color: SharedColors.defaultColor,
        onRefresh: model.init,
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SearchAppBar(),
            //! banner
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                height: 170,
                child: CarrouselBanner(),
              ),
            ),

//            SliverToBoxAdapter(
//                child: Divider(
//              height: 20,
//              indent: 30,
//              endIndent: 30,
//              color: Colors.grey,
//              thickness: 0.4,
//            )),

//            //! categories
//            SliverToBoxAdapter(
//              child: Padding(
//                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
//                child: Text(
//                  "Categories",
//                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                ),
//              ),
//            ),
//
//            if (model.categoriesAreLoading || model.categories == null)
//              SliverToBoxAdapter(
//                  child: Center(
//                child: CircularProgressIndicator(
//                  backgroundColor: SharedColors.defaultColor,
//                ),
//              ))
//            else
//              model.categories.fold(
//                (Failure f) => SliverToBoxAdapter(
//                  child: Text(
//                    f.toString(),
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                        color: SharedColors.secondaryColor, fontSize: 20),
//                  ),
//                ),
//                (List<CategoryData> categories) => SliverToBoxAdapter(
//                  child: Container(
//                    width: double.infinity,
//                    height: 250.0,
//                    child: Center(
//                      child: GridView.count(
//                        scrollDirection: Axis.horizontal,
//                        crossAxisCount: 2,
//                        children: [
//                          for (int i = 0; i < categories.length; i++)
//                            Container(
//                                width: 150.0,
//                                child: CategoryCard(categoryData: categories[i]))
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//
//            SliverToBoxAdapter(
//                child: Padding(
//              padding: const EdgeInsets.symmetric(vertical: 10),
//              child: Divider(
//                height: 20,
//                indent: 50,
//                endIndent: 50,
//                color: Colors.grey,
//                thickness: 0.4,
//              ),
//            )),

            //Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Text(
                  "Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            if (model.categoriesAreLoading || model.categories == null)
              SliverToBoxAdapter(
                  child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: SharedColors.defaultColor,
                ),
              ))
            else
              model.categories.fold(
                (Failure f) => SliverToBoxAdapter(
                  child: Text(
                    f.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: SharedColors.secondaryColor, fontSize: 20),
                  ),
                ),
                (List<CategoryData> categories) => SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 250.0,
                    child: Center(
                      child: GridView.count(
                        scrollDirection: Axis.horizontal,
                        crossAxisCount: 2,
                        children: [
                          for (int i = 0; i < categories.length; i++)
                            Container(
                                width: 150.0,
                                child:
                                    CategoryCard(categoryData: categories[i]))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            //! top sales
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, bottom: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      "Best Seller",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    if (!model.topSalesAreLoading &&
                        model.topSales != null &&
                        model.topSales.isRight())
                      FlatButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                                  RoutesManager.moreView,
                                  arguments: [
                                    "More Top Sales",
                                    model.topSales.getOrElse(null)
                                  ]),
                          // color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "More",
                            style: TextStyle(
                                color: SharedColors.defaultColor,
                                fontFamily: 'Product Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          )),
                  ],
                ),
              ),
            ),

            if (model.topSalesAreLoading || model.topSales == null)
              SliverToBoxAdapter(
                  child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: SharedColors.defaultColor,
                ),
              ))
            else
              model.topSales.fold(
                (Failure f) => SliverToBoxAdapter(
                  child: Text(
                    f.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: SharedColors.secondaryColor, fontSize: 20),
                  ),
                ),
                (List<ProductData> topSales) => SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 330,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: topSales.length > 10 ? 10 : topSales.length,
                      itemBuilder: (context, index) {
                        return Container(
                            width: 200,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: ProductCard(productData: topSales[index]));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 15,
                        );
                      },
                    ),
                  ),
                ),
              ),

            //Divider
            // SliverToBoxAdapter(
            //     child: Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: Divider(
            //     height: 20,
            //     indent: 50,
            //     endIndent: 50,
            //     color: Colors.grey,
            //     thickness: 0.4,
            //   ),
            // )),

            //! New products

            if (model.productsAreLoading || model.products == null)
              SliverToBoxAdapter(
                  child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: SharedColors.defaultColor,
                ),
              ))
            else
              model.products.fold(
                  (Failure f) => SliverToBoxAdapter(
                        child: Text(
                          f.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: SharedColors.secondaryColor, fontSize: 20),
                        ),
                      ), (List<ProductData> products) {
                List<ProductData> newProducts =
                    products.where((element) => element.newProduct).toList();
                List<Widget> newWidget = new List<Widget>();
                newWidget.clear();
                newProducts.forEach((element) {
//                  newWidget.add(Stack(
//                    children: [
//                      Image(
//                        image: NetworkImage(element.images[0].image),
//                      ),
//                      Positioned(
//                        right: 0,
//                        child: Text(element.discount.toString() + ""),
//                      )
//                    ],
//                  ));
                  newWidget.add(ProductCard(productData: element));
                });
                if (newWidget.length != 0)
                  return SliverToBoxAdapter(
                    // child:
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 10),
                    //    height: 330,
                    //   child: CarouselSlider(
                    //     options: CarouselOptions(
                    //          height: 330,
                    //       aspectRatio: 16 / 9,
                    //       viewportFraction: 0.8,
                    //       initialPage: 0,
                    //       enableInfiniteScroll: true,
                    //       reverse: false,
                    //       autoPlay: true,
                    //       autoPlayInterval: Duration(seconds: 3),
                    //       autoPlayAnimationDuration: Duration(milliseconds: 1500),
                    //       autoPlayCurve: Curves.fastOutSlowIn,
                    //       enlargeCenterPage: true,
                    //       scrollDirection: Axis.horizontal,
                    //     ),
                    //     items: newWidget,
                    //   ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "New Products",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              if (!model.productsAreLoading &&
                                  model.products != null &&
                                  model.products.isRight())
                                FlatButton(
                                    onPressed: () => Navigator.of(context)
                                            .pushNamed(RoutesManager.moreView,
                                                arguments: [
                                              "More New Products",
                                              model.products
                                                  .getOrElse(null)
                                                  .where((element) =>
                                                      element.newProduct)
                                                  .toList(),
                                            ]),
                                    //  color: ,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      "More",
                                      style: TextStyle(
                                          color: SharedColors.defaultColor,
                                          fontFamily: 'Product Sans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 330,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: newProducts.length > 10
                                ? 10
                                : newProducts.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: 200,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: ProductCard(
                                      productData: newProducts[index]));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                width: 15,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                return SliverToBoxAdapter(
                  child: SizedBox(),
                );
              }),

            //Divider
            // SliverToBoxAdapter(
            //     child: Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: Divider(
            //     height: 20,
            //     indent: 50,
            //     endIndent: 50,
            //     color: Colors.grey,
            //     thickness: 0.4,
            //   ),
            // )),

            //! products
//            SliverToBoxAdapter(
//              child: Padding(
//                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
//                child: Row(
//                  children: [
//                    Text(
//                      "Products",
//                      style:
//                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                    ),
//                    Spacer(),
//                    if (!model.productsAreLoading &&
//                        model.products != null &&
//                        model.products.isRight())
//                      FlatButton(
//                          onPressed: () => Navigator.of(context).pushNamed(
//                                  RoutesManager.moreView,
//                                  arguments: [
//                                    "More Products",
//                                    model.products.getOrElse(null)
//                                  ]),
//                          color: SharedColors.defaultColor,
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(10)),
//                          child: Text(
//                            "More",
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontFamily: 'Raleway',
//                                fontSize: 16,
//                                fontWeight: FontWeight.w700),
//                          )),
//                  ],
//                ),
//              ),
//            ),

//            if (model.productsAreLoading || model.products == null)
//              SliverToBoxAdapter(
//                  child: Center(
//                child: CircularProgressIndicator(
//                  backgroundColor: SharedColors.defaultColor,
//                ),
//              ))
//            else
//              model.products?.fold(
//                (Failure f) => SliverToBoxAdapter(
//                  child: Text(
//                    f.toString(),
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                        color: SharedColors.secondaryColor, fontSize: 20),
//                  ),
//                ),
//                (List<ProductData> products) => SliverPadding(
//                  padding:
//                      EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 15),
//                  sliver: SliverGrid.count(
//                    crossAxisCount: 2,
//                    crossAxisSpacing: 10,
//                    mainAxisSpacing: 15,
//                    childAspectRatio: (1 / 1.4),
//                    children: [
//                      for (int i = 0;
//                          i < (products.length > 10 ? 10 : products.length);
//                          i++)
//                        ProductCard(
//                          productData: products[i],
//                        )
//                    ],
//                  ),
//                ),
//              )

            //! products
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      "Products",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    if (!model.productsAreLoading &&
                        model.products != null &&
                        model.products.isRight())
                      FlatButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                                  RoutesManager.moreView,
                                  arguments: [
                                    "More Products",
                                    model.products.getOrElse(null)
                                  ]),
                          // color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "More",
                            style: TextStyle(
                                color: SharedColors.defaultColor,
                                fontFamily: 'Product Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          )),
                  ],
                ),
              ),
            ),

            if (model.productsAreLoading || model.products == null)
              SliverToBoxAdapter(
                  child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: SharedColors.defaultColor,
                ),
              ))
            else
              model.products?.fold(
                (Failure f) => SliverToBoxAdapter(
                  child: Text(
                    f.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: SharedColors.secondaryColor, fontSize: 20),
                  ),
                ),
                (List<ProductData> products) => SliverPadding(
                  padding:
                      EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 15),
                  
                  sliver: SliverGrid.count(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 2
                        : 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    childAspectRatio: (20 / 38),
                    children: [
                      for (int i = 0;
                          i < (products.length > 10 ? 10 : products.length);
                          i++)
                          ProductCard(
                            productData: products[i],
                          ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}