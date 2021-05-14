import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/orderViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/models/orderData.dart';
import 'package:ecom/core/models/orderState.dart';
import 'package:flutter/material.dart';

class OrderView extends StatelessWidget {
  final OrderState orderState;

  const OrderView({Key key, this.orderState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<OrderViewModel>(
      viewModel: OrderViewModel(),
      onModelReady: (model) => model.init(orderState),
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
                
                backgroundColor: SharedColors.defaultColor,
                title: Text(
                  "${orderState.name} orders"
                ),
                centerTitle: true,
              ),

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 20,
                    ),

                    if(model.orders.length == 0)
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text(
                            "No orders in this category",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    
                    else
                      for(OrderData order in model.orders)
                        ...[

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => model.onDetailShow(order),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    "#ORD${order.id.toString().padLeft(7,'0')}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      color: SharedColors.secondaryColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),
                              ),

                              if(orderState == OrderState.accepted && DateTime.now().difference(order.creationDate).inHours <= 2)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: FlatButton(
                                    onPressed: () => model.refund(order.id),
                                    color: SharedColors.defaultColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Text(
                                      "Cancel Order",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Raleway',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700
                                      ),
                                    )
                                  ),
                                ),
                            ],
                          ),

                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),

                              Text(
                                "State: ",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  letterSpacing: 2,
                                  fontFamily: 'Raleway',
                                  fontSize: 14, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                "${order.orderState.name}",
                                style: TextStyle(
                                  color: SharedColors.secondaryColor,
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              Spacer(),

                              Text(
                                "Total : DZ ${order.total.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  letterSpacing: 2,
                                  fontFamily: 'Raleway',
                                  fontSize: 15, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              SizedBox(
                                width: 25,
                              ),
                            ],
                          ),

                          if(order.courierNoteNumber.isNotEmpty)
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),

                                Text(
                                  "Courrier number : ",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    letterSpacing: 2,
                                    fontFamily: 'Raleway',
                                    fontSize: 14, 
                                    fontWeight: FontWeight.bold
                                  ),  
                                ),

                                Text(
                                  "${order.courierNoteNumber}",
                                  style: TextStyle(
                                    color: SharedColors.secondaryColor,
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),

                          if(order.orderState == OrderState.canceledByUser || order.orderState == OrderState.canceledByAdmin)
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),

                                Text(
                                  order.refundId.isEmpty ? "Pending Refund" : "Refund ID : ",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    letterSpacing: 2,
                                    fontFamily: 'Raleway',
                                    fontSize: 14, 
                                    fontWeight: FontWeight.bold
                                  ),  
                                ),

                                Text(
                                  "${order.refundId}",
                                  style: TextStyle(
                                    color: SharedColors.secondaryColor,
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),

                          Divider(
                            color: Colors.grey,
                            height: 40,
                            thickness: 0.5,
                            indent: 40,
                            endIndent: 40,
                          ),                      
                        ]
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}