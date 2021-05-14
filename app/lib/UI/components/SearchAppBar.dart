import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchAppBar extends StatelessWidget {
  final bool forRedeeming;

  const SearchAppBar({Key key, this.forRedeeming=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      elevation: 0,
      /* leading: IconButton(
        icon: Icon(
          Icons.keyboard_arrow_left,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ), */
      /* actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.shoppingCart),
            onPressed: () => Navigator.of(context).pushNamed(RoutesManager.shoppingCart),
          ),
        ) 
      ],*/
      backgroundColor: SharedColors.defaultColor,
      title: Container(
        height: 45,
        child: Card(
          elevation: 5,
          color: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              onSubmitted: (value) => Navigator.of(context).pushNamed(forRedeeming ? RoutesManager.searchForRedeeming : RoutesManager.search, arguments: value),
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: FaIcon(FontAwesomeIcons.search),
                hintText: "Search"
              ),
          ),
          ),
        ),
      ),
      centerTitle: true,
    );
  }
}