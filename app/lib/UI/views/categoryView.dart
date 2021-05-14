import 'package:ecom/UI/components/SearchAppBar.dart';
import 'package:ecom/UI/components/productCard.dart';
import 'package:ecom/UI/components/subCategoryCard.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/categoryData.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {

  final CategoryData categoryData;
  final bool forRedeeming;

  const CategoryView({Key key, this.categoryData, this.forRedeeming = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<ProductData> newProducts = categoryData.products.where((element) => element.newProduct).toList();

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SearchAppBar(),

            //! sub categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  "${categoryData.title} Sub Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 250.0,
                child: GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 2,
                  children: [
                    for (int i = 0; i < categoryData.subCategories.length; i++)
                      Container(
                          width: 150.0,
                          child: SubCategoryCard(
                            subCategoryData : categoryData.subCategories[i],
                            forRedeeming : forRedeeming,
                          ))
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 20,
                indent: 50,
                endIndent: 50,
                color: Colors.grey,
                thickness: 0.4,
              ),
            )),

            //! category top sales
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      "${categoryData.title} Top Sales",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        forRedeeming ? RoutesManager.moreViewRedeem : RoutesManager.moreView, 
                        arguments: [
                          "More ${categoryData.title} Top Sales",
                          categoryData.topSales
                        ]
                      ),
                      color: SharedColors.defaultColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "More",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 230.0,
                padding: EdgeInsets.only(left: 8),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryData.topSales.length > 10 ? 10 : categoryData.topSales.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 160.0,
                      child: ProductCard(
                        productData: categoryData.topSales[index],
                        forRedeeming: forRedeeming,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 15,
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 20,
                indent: 50,
                endIndent: 50,
                color: Colors.grey,
                thickness: 0.4,
              ),
            )),

            //! category new products
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      "${categoryData.title} New Products",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        forRedeeming ? RoutesManager.moreViewRedeem : RoutesManager.moreView, 
                        arguments: [
                          "More ${categoryData.title} New Products",
                          newProducts
                        ]
                      ),
                      color: SharedColors.defaultColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "More",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 230.0,
                padding: EdgeInsets.only(left: 8),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: newProducts.length > 10 ? 10 : newProducts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 160.0,
                      child: ProductCard(
                        productData: newProducts[index],
                        forRedeeming: forRedeeming,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 15,
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 20,
                indent: 50,
                endIndent: 50,
                color: Colors.grey,
                thickness: 0.4,
              ),
            )),

            //! products
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      "${categoryData.title} Products",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        forRedeeming ? RoutesManager.moreViewRedeem : RoutesManager.moreView, 
                        arguments: [
                          "More ${categoryData.title} Products",
                          categoryData.products
                        ]
                      ),
                      color: SharedColors.defaultColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "More",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.only(top: 15, right: 5, left: 5),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                childAspectRatio: (1 / 1.4),
                children: [
                  for (int i = 0; i < (categoryData.products.length > 10 ? 10 : categoryData.products.length); i++)
                    ProductCard(
                      productData: categoryData.products[i],
                      forRedeeming: forRedeeming,
                    ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}