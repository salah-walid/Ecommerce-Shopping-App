import 'package:ecom/UI/components/mainPage/homeComponent.dart';
import 'package:ecom/UI/components/mainPage/notificationComponent.dart';
import 'package:ecom/UI/components/mainPage/profile.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/mainPageViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/UI/views/cartView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labelTextStyle = Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 13.0,fontFamily: 'Product Sans');

    return BaseView<MainPageViewModel>(
      viewModel: MainPageViewModel(),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
          bottomNavigationBar: Stack(
            clipBehavior: Clip.none,
            alignment: new FractionalOffset(.5, 1.0),
            children: [
              BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 6,
                currentIndex: model.currentBottomNavigationIndex,
                selectedLabelStyle: labelTextStyle,
                unselectedLabelStyle: labelTextStyle,
                selectedItemColor: SharedColors.defaultColor,
                onTap: model.bottomNavigationChanged,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Home"
                  ),
        //                  BottomNavigationBarItem(
        //                      icon: FaIcon(FontAwesomeIcons.shoppingBasket),
        //                      label: "Ved Store"),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        Icon(Icons.notifications),
                        if (model.unreadNotifications ?? false)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: SharedColors.defaultColor,
                                borderRadius:
                                  BorderRadius.all(Radius.circular(20)
                                )
                              ),
                            ),
                          )
                      ],
                    ),
                    label: "Notifications"),
                  BottomNavigationBarItem(
                      icon:Icon(Icons.shopping_basket),
                      // FaIcon(
                      //   FontAwesomeIcons.shoppingCart,
                      //   // color: Colors.white,
                      // ),
                      label: "Cart"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: model.isConnected ? model.userName : "Me"
                  ),
                ],
              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom: 20.0),
//                child: new FloatingActionButton(
//                  backgroundColor: SharedColors.defaultColor,
//                  onPressed: () => Navigator.of(context)
//                      .pushNamed(RoutesManager.shoppingCart),
//                  child: FaIcon(FontAwesomeIcons.shoppingCart,color: Colors.white,),
//                ),
//              ),
              ],
            ),
            body: PageView(
              controller: model.bottomNavigationPageController,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomeComponent(),
                NotificationComponent(),
                CartView(),
                ProfileComponent(),
              ]
            ),
          ),
      ),
    );
  }
}