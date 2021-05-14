import 'package:ecom/core/models/productData.dart';
import 'package:flutter/material.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WishListComponent extends StatelessWidget {

  final ProductData productData;
  final Function() onRemoved;

  const WishListComponent({Key key, this.productData, this.onRemoved}) : super(key: key);

  void navigateToProductDetail(BuildContext context) => Navigator.pushNamed(context, RoutesManager.productDetail, arguments: productData);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => navigateToProductDetail(context),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                elevation: 4,
                child: Image.network(
                  productData.images[0].image,
                  width: 80,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),

          SizedBox(width: 10,),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => navigateToProductDetail(context),
                        child: Text(
                          productData.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            letterSpacing: 2,
                            fontFamily: 'Raleway',
                            fontSize: 17, 
                            color: Colors.brown.shade800, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ),

                    Text(
                      "DZ ${productData.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => navigateToProductDetail(context),
                  child: Text(
                    "${productData.description}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      letterSpacing: 2,
                      fontFamily: 'Raleway',
                      fontSize: 15, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Spacer(),

                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.trashAlt,
                      color: Colors.red,
                    ), 
                    onPressed: onRemoved
                  ),
                ),

                SizedBox(height: 6,)
              ],
            )
          )
        ],
      ),
    );
  }
}