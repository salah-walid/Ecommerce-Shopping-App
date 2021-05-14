import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/addReviewViewModel.dart';
import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AddReview extends StatelessWidget {
  final ProductOrderData productData;

  const AddReview({Key key, this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AddReviewViewModel>(
      viewModel: AddReviewViewModel(),
      onModelReady: (model) => model.init(productData),
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.grey.shade800,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: SharedColors.defaultColor,
          title: Text(
            "Post review",
            style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade50),
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: model.formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  SizedBox(height: 8,),

                  Text(
                    "Review on : ${productData.product.title}",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'Raleway', fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 30,),

                  Align(
                    alignment: Alignment.center,
                    child: SmoothStarRating(
                      allowHalfRating: false,
                      rating: model.reviewData.stars.toDouble(),
                      onRated: model.updateRating,
                      starCount: 5,
                      size: 45,
                      isReadOnly: false,
                      color: Colors.yellowAccent.shade700,
                      borderColor: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 40,),

                  

                  Text("Description", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: SharedColors.textColor),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: SharedColors.textColor),
                      ),
                    ),
                    cursorColor: SharedColors.textColor,
                    minLines: 8,
                    maxLines: null,
                    onSaved: (value) => model.reviewData.content = value,
                    validator: (value){
                      if(value.isEmpty)
                        return "Please provide a description";
                      return null;
                    }
                  ),
                  SizedBox(height: 30),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(55, 15, 55, 15),
                      onPressed: model.submit,
                      child: model.state == ViewState.Idle
                        ? Text(
                            "Submit",
                            style: TextStyle(fontFamily: 'Raleway',color: Colors.white),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              backgroundColor: SharedColors.defaultColor,
                            ),
                          ),
                      color: SharedColors.defaultColor,
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}