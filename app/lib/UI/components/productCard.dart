import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/productCardViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.productData, 
    this.forRedeeming = false
  }) : super(key: key);

  final ProductData productData;
  final bool forRedeeming;

  void navigateToProductDetail(BuildContext context) => Navigator.pushNamed(context, forRedeeming ? RoutesManager.productDetailRedeem : RoutesManager.productDetail, arguments: productData);

  @override
  Widget build(BuildContext context) {
    return BaseView<ProductCardViewModel>(
      viewModel: ProductCardViewModel(),
      builder:(context, model, _) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 15,
              color: SharedColors.defaultColor.withOpacity(0.35),
            ),
          ],
        ),
        //padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () => navigateToProductDetail(context),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Image.network(
                        productData.images[0].image, 
                        fit: BoxFit.fill,
                      )
                    ),

                    if(forRedeeming)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          color: SharedColors.defaultColor,
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                          child: Text(
                            "(${productData.redeemPoints}) Points",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    
                    if(productData.newProduct && !forRedeeming)
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            color: Colors.red,
                            padding: EdgeInsets.all(3),
                            child: Text(
                              "New",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white
                              ),
                            ),
                          )
                        ),
                    
                    if(productData.discount != 0 && !forRedeeming)
                      Positioned(
                        top: 0,
                        right: 6,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(4, 3, 4, 10),
                          width: 55,
                          color: Colors.yellow.shade800,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${productData.discount}%", style: TextStyle(fontSize: 16, color: Colors.red.shade900),),
                              SizedBox(height: 3),
                              Text("OFF", style: TextStyle(fontSize: 14, color: Colors.white),)
                            ],
                          ),
                        )
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  GestureDetector(
                    onTap: () => navigateToProductDetail(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          "${productData.title}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              productData.discount != 0 ? 'DZ${productData.priceWithDiscount.toStringAsFixed(2)}' : 'DZ${productData.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                color: SharedColors.secondaryColor
                              )
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            if(productData.discount != 0)
                              Expanded(
                                child: Text(
                                  'DZ${productData.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    decoration: TextDecoration.lineThrough
                                  )
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SmoothStarRating(
                              allowHalfRating: false,
                              rating: productData.stars.toDouble(),
                              starCount: 5,
                              size: 17,
                              isReadOnly: true,
                              color: Colors.yellowAccent.shade700,
                              borderColor: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "(${productData.reviewsCount})",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if(!forRedeeming)
                        ...[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: Colors.red
                              ),
                              width: 45,
                              height: 45,
                              child: Center(
                                child: IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.solidHeart,
                                    color: Colors.white,
                                    size: 22,
                                  ), 
                                  onPressed: () => model.addToWishList(productData),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),
                        ],

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.blue
                          ),
                          width: 45,
                          height: 45,
                          child: Center(
                            child: IconButton(
                              icon: FaIcon(
                                forRedeeming ? FontAwesomeIcons.gift : FontAwesomeIcons.shoppingCart,
                                color: Colors.white,
                                size: 22,
                              ), 
                              onPressed: () => model.addToCart(productData, forRedeeming),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}