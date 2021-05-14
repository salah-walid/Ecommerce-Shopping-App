import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/checkOutViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BaseView<CheckOutViewModel>(
      viewModel: CheckOutViewModel(),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              ListView(
                children: <Widget>[
                  CreditCardWidget(
                    cardNumber: model.cardNumber,
                    expiryDate: model.expiryDate,
                    cardHolderName: model.cardHolderName,
                    cvvCode: model.cvvCode,
                    showBackView: model.isCvvFocused,
                  ),
                  CreditCardForm(
                    onCreditCardModelChange: model.formChanged,
                  ),

                  SizedBox(height: 40,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: FlatButton(
                      onPressed: model.proceed,
                      color: SharedColors.defaultColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "PROCCEED",
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

              if(model.checkingOut)
                Center(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      backgroundColor: SharedColors.defaultColor,
                    ),
                  ),
                )
            ],
          )
        ),
      ),
    );
  }
}