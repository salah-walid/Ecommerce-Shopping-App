import 'package:ecom/UI/components/customTextField.dart';
import 'package:ecom/UI/components/productCartComponent.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/UI/viewmodels/cartViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CartView extends StatelessWidget {
  const CartView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CartViewModel>(
      viewModel: CartViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, _) => SafeArea(
          child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: SharedColors.defaultColor,
              title: Text("Shopping Cart"),
              centerTitle: true,
            ),
            if (model.orderData.orderList.length == 0)
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            else ...[
              SliverList(
                delegate: SliverChildListDelegate([
                for (int i = 0; i < model.orderData.orderList.length; i++)
                  ProductCart(
                    productOrderData: model.orderData.orderList[i],
                    onDelete: () => model
                        .onCartProductDelete(model.orderData.orderList[i]),
                    onChangeQuantity: (value) =>
                        model.onProductQuantityChanged(i, value),
                  )
              ])),
              
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Use existing adress",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Radio(
                          activeColor: SharedColors.defaultColor,
                          value: BillingAdressUsage.sameAdress,
                          groupValue: model.currentAdressType,
                          onChanged: model.radioChanged),
                      
                      Text(
                        "Use new adress",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Radio(
                        activeColor: SharedColors.defaultColor,
                        value: BillingAdressUsage.newAdress,
                        groupValue: model.currentAdressType,
                        onChanged: model.radioChanged
                      ),
                    ],
                  ),
                ),
              ),
              if (model.currentAdressType == BillingAdressUsage.newAdress)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Form(
                      key: model.formState,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpandablePanel(
                            header: Text("Billing address", style: TextStyle(fontFamily: 'Raleway', fontSize: 20,color: Colors.grey.shade700)),
                            collapsed: Text("(Click to expand)", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade500)),
                            expanded: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text("Billing address", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.orderData.billingAdress = value,
                                  onSubmited: model.billingAdressSubmited,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a billing address";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("City", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.orderData.billingCity = value,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a city";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("State", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.orderData.billingState = value,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a state";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("Zip / Postal Code", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                
                                CustomTextField(
                                  onSaved: (value) => model.orderData.billingZipCode = value,
                                  validator: (value){
                                    if(value.isEmpty || int.tryParse(value) == null || value.length != 5)
                                      return "Please provide a valid zip code";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("Country", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  enabled: false,
                                  initialValue: "Malaysia",
                                  onSaved: (value) => model.orderData.billingCountry = value,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a country";
                                    return null;
                                  }
                                ),

                                SizedBox(height: 30),                   
                                Text("Mobile Number", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                InternationalPhoneNumberInput(
                                  onInputChanged: (mn) {
                                    model.orderData.billingMobileNumber = mn.phoneNumber;
                                  },
                                  
                                  initialValue: PhoneNumber(phoneNumber: "", isoCode: "DZ"),
                                  formatInput: false,
                                  countries: ["DZ"],
                                  validator: (value){
                                    if(value.isEmpty || value.length != 9)
                                      return "Please provide a valid phone number";
                                    
                                    return null;
                                  },  
                                  //onSaved: (value) => model.orderData.mobileNumber = value,
                                ),
                              ],
                            ),
                            // ignore: deprecated_member_use
                            tapHeaderToExpand: true,
                          ),
                          SizedBox(height: 30),

                          ExpandablePanel(
                            header: Text("Delivery address", style: TextStyle(fontFamily: 'Raleway', fontSize: 20,color: Colors.grey.shade700)),
                            collapsed: Text("(Click to expand)", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade500)),
                            expanded: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text("Billing address", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.orderData.deliveryAdress = value,
                                  onSubmited: model.deliveryAdresseSubmited,
                                  controller: model.deliveryAdressC,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a delivery address";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("City", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.orderData.deliveryCity = value,
                                  controller: model.deliveryCityC,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a city";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("State", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.orderData.deliveryState = value,
                                  controller: model.deliveryStateC,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a state";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("Zip / Postal Code", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.orderData.deliveryZipCode = value,
                                  controller: model.deliveryZipCodeC,
                                  validator: (value){
                                    if(value.isEmpty || int.tryParse(value) == null || value.length != 5)
                                      return "Please provide a valid zip code";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("Country", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  enabled: false,
                                  initialValue: "Malaysia",
                                  controller: model.deliveryCountryC,
                                  onSaved: (value) => model.orderData.deliveryCountry = value,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a country";
                                    return null;
                                  }
                                ),

                                SizedBox(height: 30),                   
                                Text("Mobile Number", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                InternationalPhoneNumberInput(
                                  onInputChanged: (mn) {
                                    model.orderData.deliveryMobileNumber = mn.phoneNumber;
                                  },
                                  
                                  initialValue: PhoneNumber(phoneNumber: "", isoCode: "DZ"),
                                  formatInput: false,
                                  countries: ["DZ"],
                                  validator: (value){
                                    if(value.isEmpty || value.length != 9)
                                      return "Please provide a valid phone number";
                                    
                                    return null;
                                  },
                                  //onSaved: (value) => model.orderData.mobileNumber = value,
                                ),

                                SizedBox(height: 30),
                              ],
                            ),
                            // ignore: deprecated_member_use
                            tapHeaderToExpand: true,
                          ),

                          
                        ],
                      ),
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: model.promoCodeFieldController,
                          decoration: InputDecoration(
                            hintText: "Promo Code",
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: SharedColors.textColor),
                            ),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: SharedColors.textColor),
                            ),
                          ),
                          cursorColor: SharedColors.textColor,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 140,
                        height: 45,
                        child: FlatButton(
                            onPressed: model.onPromoCodeClicked,
                            color: SharedColors.defaultColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: model.state == ViewState.Busy
                                ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                          SharedColors.defaultColor,
                                    ),
                                  )
                                : Text(
                                    "Apply",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Raleway',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )),
                      )
                    ],
                  ),
                ),
              ),

              if(model.showSameDayDelivery)
                SliverToBoxAdapter(
                    child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        child: model.sameDeliveryLoading
                        ? CircularProgressIndicator(
                            backgroundColor: SharedColors.defaultColor,
                          )
                        : null
                      ),
                      Checkbox(
                        value: model.orderData.sameDayDelivery,
                        onChanged: model.sameDayDeliveryChanged,
                        activeColor: SharedColors.defaultColor,
                      ),
                      Text(
                        "Same Day Delivery",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      Text(
                        "DZ 30.00",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                )),

              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
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
                      if(model.calculatingTotal)
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            backgroundColor: SharedColors.defaultColor,
                          ),
                        )
                      else if(!model.totalCalculated)
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Couldn't calculate order total"
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 25),
                                child: FlatButton(
                                  onPressed: model.calculateSummary,
                                  color: SharedColors.defaultColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Retry",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Raleway',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )
                                ),
                              ),
                            ],
                          ),
                        )
                      else
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
                                      "DZ ${model.orderData.subTotal.toStringAsFixed(2)}"),
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
                                      "DZ ${model.orderData.shipping.toStringAsFixed(2)}"),
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
                                      "DZ ${model.orderData.estimatedTax.toStringAsFixed(2)}"),
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
                                      "DZ ${model.orderData.promo.toStringAsFixed(2)}"),
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
                                      "DZ ${model.orderData.total.toStringAsFixed(2)}"),
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
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: FlatButton(
                    onPressed: model.checkOut,
                    color: SharedColors.defaultColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "CHECK OUT",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )
                  ),
                ),
              )
            ]
          ],
        ),
      )),
    );
  }
}
