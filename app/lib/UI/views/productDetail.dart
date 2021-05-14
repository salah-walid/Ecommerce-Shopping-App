import 'package:ecom/UI/components/review.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/productDetailViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/VariationsOptions.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:ecom/core/models/reviewData.dart';
import 'package:ecom/core/models/uomData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetail extends StatefulWidget {
  final ProductData productData;
  final bool isRedeeming;
  ProductDetail({Key key, this.productData, this.isRedeeming = false})
      : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var _r;
    return BaseView<ProductDetailViewModel>(
      viewModel: ProductDetailViewModel(),
      onModelReady: (model) => model.init(widget.productData.id, widget.isRedeeming),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
          key: key,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: SharedColors.defaultColor,
            title: Text(
              "${widget.productData.title}'s Details",
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  color: Colors.grey.shade50,
                  fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
              controller: model.scrollcontroller,
              child: model.productAreLoading == true || model.product == null
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          CircularProgressIndicator(
                            backgroundColor: SharedColors.defaultColor,
                          ),
                        ],
                      ),
                    )
                  : model.product.fold(
                      (f) => Text(
                        f.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: SharedColors.secondaryColor, fontSize: 18),
                      ),
                      (r) {
                        _r = r;
                        model.setProduct(r);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,
                              color: Colors.white,
                              child: GestureDetector(
                                onDoubleTap: () => Navigator.pushNamed(
                                    context, RoutesManager.imageFullScreen,
                                    arguments: r.images[model.chosenIndex]),
                                child: Image.network(
                                  r.images[model.chosenIndex].image,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (int i = 0; i < r.images.length; i++) ...[
                                    GestureDetector(
                                      onTap: () => model.setChosenIndex(i),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1)),
                                        child: Image.network(
                                          r.images[i].image,
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10)
                                  ]
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      r.title,
                                      style: TextStyle(
                                        letterSpacing: 2,
                                        fontFamily: 'Product Sans',
                                        fontSize: 18,
                                        color: Colors.brown.shade800,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),

                                    if(r.quantity >= model.productOrder.quantity)
                                    Text(
                                      "  (Available)",
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 14, 
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  if (!widget.isRedeeming)
                                    Text(
                                      "DZ ${r.priceWithDiscount.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Product Sans',
                                          color: Colors.grey.shade700),
                                    )
                                  else
                                    Spacer(),

                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 10),
                                      Container(
                                        width: 35,
                                        height: 25,
                                        child: OutlineButton(
                                          padding: EdgeInsets.all(0),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade600),
                                          onPressed: () =>
                                              model.addQuantity(-1),
                                          child: Icon(Icons.remove),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  bottomLeft:
                                                      Radius.circular(30))),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                          model.productOrder.quantity
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.brown.shade800,
                                              fontFamily: 'Product Sans',
                                              fontSize: 24)),
                                      SizedBox(width: 7),
                                      Container(
                                        width: 35,
                                        height: 25,
                                        child: OutlineButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () => model.addQuantity(1),
                                          child: Icon(Icons.add),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(30),
                                                  topRight:
                                                      Radius.circular(30))),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Description : ",
                                        style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            color: Colors.brown.shade800,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text("${r.description}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            color: Colors.grey.shade700,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              shrinkWrap: true,
                              childAspectRatio: (16/4),
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                for(int i=0; i < r.variations.length; i++)
                                  ClipRect(
                                    clipBehavior: Clip.antiAlias,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          "${r.variations[i].title} : ",
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            color: Colors.brown.shade800,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        Expanded(
                                          child: DropdownButton<VariationOptions>(
                                            value: model.productOrder.chosenVariations[i],
                                            isExpanded: true,
                                            items: [
                                              for(VariationOptions v in r.variations[i].options)
                                                DropdownMenuItem(
                                                  child: Text(
                                                    "${v.content}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Product Sans',
                                                      color: Colors.brown.shade900,
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  value: v,
                                                )
                                            ],
                                            onChanged: (value) => model.variationChanged(value, i),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),

                            SizedBox(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "UOM",
                                  style: TextStyle(
                                    fontFamily: 'Product Sans',
                                    color: Colors.brown.shade900,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),

                                SizedBox(width: 40,),

                                DropdownButton<UomData>(
                                  value: model.productOrder.uom,
                                  items: [
                                    for(UomData uom in r.uoms)
                                      DropdownMenuItem(
                                        child: uom.unit != "UNIT"
                                          ? Text(
                                              "${uom.unit} (${uom.value} UNIT)",
                                              style: TextStyle(
                                                fontFamily: 'Product Sans',
                                                color: Colors.brown.shade900,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold
                                              ),
                                            )
                                          : Text(
                                              "${uom.value} ${uom.unit}",
                                              style: TextStyle(
                                                fontFamily: 'Product Sans',
                                                color: Colors.brown.shade900,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                        value: uom,
                                      )
                                  ],
                                  onChanged: model.uomChanged,
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            if(!widget.isRedeeming)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Total:",
                                        style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            color: SharedColors.defaultColor,
                                            fontSize: 24)),
                                    Text("DZ ${model.total.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            color: Colors.brown.shade800,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 25),
                            //   child:

                            // ),
                            // SizedBox(height: 40),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // SizedBox(
                                    //   height: 25,
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        model.toggleReview(key);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Product Reviews",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "(${r.reviewsCount})",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        Colors.grey.shade800),
                                              ),
                                            ],
                                          ),
                                          if(r.reviewsCount > 0)
                                            Text(
                                              "View All",
                                              style: TextStyle(color: Colors.red),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    // Divider(
                                    //   color: Colors.grey,
                                    //   thickness: 2,
                                    //   height: 50,
                                    // ),
                                    if (model.reviewsOpen)
                                      for (ReviewData review in r.reviewList) ...[
                                        ReviewCard(
                                          reviewData: review,
                                        ),
                                        // SizedBox(height:40),
                                      ],

                                    if (model.reviewsOpen)
                                      SizedBox(
                                        height: 100,
                                      ),

                                    // Divider(
                                    //   color: Colors.grey,
                                    //   thickness: 1,
                                    //   indent: 30,
                                    //   endIndent: 30,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    )),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!widget.isRedeeming) ...[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(
                      //         Radius.circular(6)),
                      //     color: Colors.red),
                      // width: 35,
                      // height: 45,
                      // child: Center(
                      child: FlatButton.icon(
                        //  iconSize: 40,
                        label: Text("Add to Wishlist"),
                        icon: Image.asset(
                          "assets/images/shoppingbag.png",
                          height: 40,
                          width: 40,
                        ),
                        onPressed: () => model.addItemToWishList(_r),
                      ),
                      // ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    // decoration: BoxDecoration(
                    // borderRadius: BorderRadius.all(
                    // Radius.circular(6)),
                    // color: Colors.red),
                    // width: 45,
                    // height: 45,
                    // child: Center(
                    child: FlatButton.icon(
                      label: Text("Add to cart"),
                      icon: widget.isRedeeming
                          ? FaIcon(
                              FontAwesomeIcons.gift,
                              color: Colors.white,
                              size: 22,
                            )
                          : Image.asset(
                              "assets/images/shoppingcart.png",
                              height: 40,
                              width: 40,
                            ),
                      onPressed: () => model.addToCart(),
                    ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}