import 'package:ecom/UI/components/productCard.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/searchViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchView extends StatelessWidget {

  final String search;
  final bool forRedeaming;

  const SearchView({Key key, this.search, this.forRedeaming=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SearchViewModel>(
      viewModel: SearchViewModel(),
      onModelReady: (model) => model.getProductsSearch(search),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(

          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: FaIcon(FontAwesomeIcons.shoppingCart),
                      onPressed: () => Navigator.of(context).pushNamed(RoutesManager.shoppingCart),
                    ),
                  )
                ],
                backgroundColor: SharedColors.defaultColor,
                title: Text(
                  "Search : $search"
                ),
                centerTitle: true,
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
                  (List<ProductData> products) {
                    if(products.length != 0)
                      return SliverPadding(
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
                                forRedeeming: forRedeaming,
                              )
                            
                          ],
                        ),
                      );
                    else
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.search,
                                size: 100,
                                color: Colors.grey.shade600,
                              ),
                              Text(
                                "Sorry, we didn't find any results matching this search",
                                textAlign: TextAlign.center, 
                                style: TextStyle(
                                  color: Colors.grey.shade600, 
                                  fontSize: 20
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  }
                )
            ],
          )
        )
      ),
    );
  }
}