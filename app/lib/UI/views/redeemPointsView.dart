import 'package:ecom/UI/components/SearchAppBar.dart';
import 'package:ecom/UI/components/productCard.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/redeemPointViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:flutter/material.dart';

class RedeemPointsView extends StatelessWidget {
  const RedeemPointsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<RedeemPointsViewModel>(
      viewModel: RedeemPointsViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            color: SharedColors.defaultColor,
            onRefresh: model.init,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SearchAppBar(forRedeeming: true,),


                //! products
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      children: [
                        Text(
                          "Redeem Products",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        /* if(!model.productsAreLoading && model.products != null && model.products.isRight())
                          FlatButton(
                            onPressed: () => Navigator.of(context).pushNamed(
                              RoutesManager.moreViewRedeem, 
                              arguments: [
                                "More Products",
                                model.products.getOrElse(null)
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
                          ), */
                      ],
                    ),
                  ),
                ),

                if(model.productsAreLoading || model.products == null)
                  SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: SharedColors.defaultColor,
                      ),
                    )
                  )
                else
                  model.products?.fold(
                    (Failure f) => SliverToBoxAdapter(
                      child: Text(
                        f.toString(), 
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          color: SharedColors.secondaryColor, 
                          fontSize: 20),
                        ),
                    ),
                    (List<ProductData> products) => SliverPadding(
                      padding: EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 15),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 15,
                        childAspectRatio: (1 / 1.4),
                        children: [
                          
                          for(int i=0; i < products.length; i++)
                            ProductCard(
                              productData: products[i],
                              forRedeeming: true,
                            )
                          
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
