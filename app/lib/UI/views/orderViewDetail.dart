import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:ecom/UI/components/productCartComponent.dart';
import 'package:ecom/core/models/orderState.dart';

import 'package:ecom/core/models/orderData.dart';

class OrderViewDetail extends StatelessWidget {

  final OrderData orderData;

  const OrderViewDetail({Key key, this.orderData}) : super(key: key);

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
              "#ORD${orderData.id.toString().padLeft(7,'0')}"
            ),
            centerTitle: true,
          ),

          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 20,
                ),

                for(ProductOrderData productData in orderData.orderList)
                  ...[
                    ProductCart(
                      productOrderData: productData,
                      editable: false,
                    ),
                    if(orderData.orderState == OrderState.delivered && !productData.reviewed)
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton.icon(
                          onPressed: () => Navigator.of(context).pushNamed(RoutesManager.addReview, arguments: productData),
                          
                          icon: FaIcon(
                            FontAwesomeIcons.plus,
                            size: 22,
                          ),
                          label: Text(
                            "Add review",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                        ),
                      )
                  ],

                SizedBox(
                  height: 20,
                ),
                
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "COST SUMMARY",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 200,
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.top,
                          children: [
                            TableRow(children: [
                              Text("Subtotal"),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "DZ ${orderData.subTotal.toStringAsFixed(2)}"),
                              )
                            ]),
                            TableRow(children: [
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ]),
                            TableRow(children: [
                              Text("Shipping"),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "DZ ${orderData.shipping.toStringAsFixed(2)}"),
                              )
                            ]),
                            TableRow(children: [
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ]),
                            TableRow(children: [
                              Text("Estimated Tax"),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "DZ ${orderData.estimatedTax.toStringAsFixed(2)}"),
                              )
                            ]),
                            TableRow(children: [
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ]),
                            TableRow(children: [
                              Text("Promo"),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "DZ ${orderData.promo.toStringAsFixed(2)}"),
                              )
                            ]),
                            TableRow(children: [
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ]),
                            TableRow(children: [
                              Text("Total"),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "DZ ${orderData.total.toStringAsFixed(2)}"),
                              )
                            ]),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}