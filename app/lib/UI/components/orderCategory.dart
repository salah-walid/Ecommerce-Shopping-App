import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/orderState.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderCategory extends StatelessWidget {
  final OrderState orderState;
  final IconData icon;
  final Function onUpdateProfile;

  const OrderCategory({Key key, this.orderState, this.icon, this.onUpdateProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 65,
          height: 65,
          child: MaterialButton(
            onPressed: () async{
              await Navigator.of(context).pushNamed(RoutesManager.orders, arguments: orderState);
              onUpdateProfile();
            },
            color: SharedColors.defaultColor,
            child: FaIcon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            shape: CircleBorder(),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            orderState.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}