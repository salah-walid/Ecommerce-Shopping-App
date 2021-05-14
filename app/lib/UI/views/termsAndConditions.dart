import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/UI/viewmodels/termsAndConditionsViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TermsAndConfitions extends StatelessWidget {
  const TermsAndConfitions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<TermsAndConditionsViewModel>(
      onModelReady: (model) => model.init(),
      viewModel: TermsAndConditionsViewModel(),
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.shoppingCart),
                onPressed: () => Navigator.of(context).pushNamed(RoutesManager.shoppingCart),
              ),
            )
          ],
          backgroundColor: SharedColors.defaultColor,
          title: Text(
            "Terms & Conditions"
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: model.state == ViewState.Busy || model.terms == null
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: SharedColors.defaultColor,
                ),
              )
            : model.terms.fold(
                (f) => Center(
                  child: Text(
                    f.toString(), 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      color: SharedColors.secondaryColor, 
                      fontSize: 20
                    ),
                  ),
                ), 
                (r) => Text(
                  r,
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}