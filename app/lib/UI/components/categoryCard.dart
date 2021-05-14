import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/categoryData.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    this.categoryData, 
    this.forRedeeming = false
  }) : super(key: key);

  final CategoryData categoryData;
  final bool forRedeeming;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(forRedeeming ? RoutesManager.categoryRedeeming : RoutesManager.category, arguments: categoryData),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(5),
                child: Image.network(
                  categoryData.image, 
                  fit: BoxFit.fitHeight,
                )
                ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 10,
                    color: SharedColors.defaultColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Text(
                "${categoryData.title}\n".toUpperCase(),
                style: Theme.of(context).textTheme.button,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}