import 'package:ecom/UI/components/productCard.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:flutter/material.dart';

class MoreView extends StatelessWidget {

  final String title;
  final List<ProductData> products;
  final bool isRedeeming;

  const MoreView({Key key, this.title, this.products, this.isRedeeming= false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            
            backgroundColor: SharedColors.defaultColor,
            title: Text(
              "$title"
            ),
            centerTitle: true,
          ),

          SliverPadding(
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
                    forRedeeming: isRedeeming,
                  )
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}