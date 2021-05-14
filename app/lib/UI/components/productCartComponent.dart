import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/core/models/VariationsOptions.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductCart extends StatelessWidget {

  final ProductOrderData productOrderData;
  final Function onDelete;
  final Function(int) onChangeQuantity;
  final bool editable;

  const ProductCart({Key key, this.productOrderData, this.editable = true, this.onDelete, this.onChangeQuantity}) : super(key: key);

  void navigateToProductDetail(BuildContext context) => Navigator.pushNamed(context, RoutesManager.productDetail, arguments: productOrderData.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
      padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
      color: Colors.white,
      height: 220,
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
                  productOrderData.product.images[productOrderData.chosenSubProduct].image,
                  width: 80,
                  height: 170,
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
                          productOrderData.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            letterSpacing: 2,
                            fontFamily: 'Product Sans',
                            fontSize: 16, 
                            color: Colors.brown.shade800, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ),

                    Text(
                      "DZ ${productOrderData.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => navigateToProductDetail(context),
                  child: Text(
                    "${productOrderData.product.description}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      letterSpacing: 2,
                      fontFamily: 'Product Sans',
                      fontSize: 12, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Spacer(),

                Row(
                  children: [

                    if(productOrderData.isRedeemed)
                      Text(
                        "Redeemed",
                        style: TextStyle(
                          color: SharedColors.defaultColor,
                          fontSize: 14, 
                          fontWeight: FontWeight.bold
                        ),
                      ),

                    if(editable)
                      ...[
                        if(!productOrderData.isRedeemed)
                          ...[
                            SizedBox(width: 10),
                            Container(
                              width: 35,
                              height: 25,
                              child: OutlineButton(
                                padding: EdgeInsets.all(0),
                                borderSide: BorderSide(color: Colors.grey.shade600),
                                onPressed: () => onChangeQuantity(-1),
                                child: Icon(Icons.remove),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
                              ),
                            ),
                            SizedBox(width: 7),
                            Text(
                              "QTY: ",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                letterSpacing: 2,
                                fontFamily: 'Product Sans',
                                fontSize: 12, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "${productOrderData.quantity}",
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 14, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(width: 7),
                            Container(
                              width: 35,
                              height: 25,
                              child: OutlineButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () => onChangeQuantity(1),
                                child: Icon(Icons.add),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(12), topRight: Radius.circular(12))),
                                borderSide: BorderSide(color: Colors.grey.shade600),
                              ),
                            ),
                          ],

                        Spacer(),

                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.trashAlt,
                            color: Colors.red,
                          ), 
                          onPressed: onDelete
                        )
                      ]
                      
                  ],
                ),
                if(productOrderData.product.quantity >= productOrderData.quantity && editable)
                  Text(
                    "(Available)",
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),

                if(productOrderData.uom.unit == "UNIT")
                  Text(
                    "${productOrderData.quantity} ${productOrderData.uom.unit} x DZ ${productOrderData.unitPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  )
                else
                  Text(
                    "${productOrderData.quantity} ${productOrderData.uom.unit} (${productOrderData.uom.value} UNIT) x DZ ${productOrderData.unitPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),

                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                    ),

                    children: <TextSpan>[
                      for(VariationOptions variation in productOrderData.chosenVariations)
                        TextSpan(text: variation.content + ", "),
                    ]
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