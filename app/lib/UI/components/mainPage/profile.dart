import 'package:ecom/UI/components/mainPage/startMenu.dart';
import 'package:ecom/UI/components/orderCategory.dart';
import 'package:ecom/UI/components/wishListComponent.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/profileViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/orderState.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileComponent extends StatelessWidget {
  const ProfileComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      viewModel: ProfileViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, _) {

        if(model.isConnected){
          if(model.userIsLoading || model.userRequest == null){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: SharedColors.defaultColor,
              ),
            );
          }
          return model.userRequest.fold(
            (failure) => Center(
              child: Text(
                "Error loading user information\n error : ${failure.toString()}",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
            (_) => CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: MySliverHeader(
                  expandedHeight: 340,
                  profilePic: model.user.userPic,
                  userName: model.user.username,
                  email: model.user.email,
                  points: model.user.points,
                  onUpdateProfileClicked: model.updateProfile,
                  onUpdateBillingAdressClicked: model.updateBillingAddress,
                  onUpdatePasswordClicked: model.updatePassword,
                  onUpdateDeliveryAdressClicked: model.updateDeliveryAddress,
                )),

                //! orders
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OrderCategory(
                          icon: FontAwesomeIcons.box,
                          orderState: OrderState.accepted,
                          onUpdateProfile: model.init,
                        ),
                        
                        OrderCategory(
                          icon: FontAwesomeIcons.solidClock,
                          orderState: OrderState.inProgress,
                          onUpdateProfile: model.init,
                        ),

                        OrderCategory(
                          icon: FontAwesomeIcons.shippingFast,
                          orderState: OrderState.shippeded,
                          onUpdateProfile: model.init,
                        ),

                        OrderCategory(
                          icon: FontAwesomeIcons.clipboardCheck,
                          orderState: OrderState.delivered,
                          onUpdateProfile: model.init,
                        ),

                        OrderCategory(
                          icon: FontAwesomeIcons.checkCircle,
                          orderState: OrderState.completed,
                          onUpdateProfile: model.init,
                        ),
                      ],
                    ),
                  ),
                ),

                

                //! Whish list
                if(model.wishList?.length != 0)
                  SliverList(
                      delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 25,
                      endIndent: 25,
                    ),
                    Text("Wish list",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.brown.shade800,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                    Column(
                      children: [
                        for (int i = 0; i < model.wishList.length; i++)
                          WishListComponent(
                            productData: model.wishList[i],
                            onRemoved: () =>
                                model.removeProductFromWhichList(model.wishList[i]),
                          )
                      ],
                    )
                  ])),

                //! Orders
                

                //! adresses
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 25,
                          endIndent: 25,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Billing Adress : ${model.user.billingAdress}",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Text(
                          "${model.user.billingCity}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Text(
                          "${model.user.billingState}, ${model.user.billingZipCode}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                      ),
                        SizedBox(
                          height: 20,
                        ),
                        
                        Text(
                          "${model.user.billingCountry}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Mobile Number : ${model.user.billingMobileNumber}",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Divider(
                          color: Colors.grey.shade600,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                          height: 25,
                        ),

                        //----------------------------------------------------------------

                        Text(
                          "Delivery Adress : ${model.user.deliveryAdress}",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Text(
                          "${model.user.deliveryCity}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        
                        Text(
                          "${model.user.deliveryState}, ${model.user.deliveryZipCode}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        
                        Text(
                          "${model.user.deliveryCountry}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Text(
                          "Mobile Number : ${model.user.deliveryMobileNumber}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              letterSpacing: 2,
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        
                        SizedBox(
                          height: 20,
                        ),
                        
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 25,
                          endIndent: 25,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(RoutesManager.termsAndConditions),
                          child: Text(
                            "Term & Conditions (Click to view)",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                letterSpacing: 2,
                                fontFamily: 'Raleway',
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: FlatButton(
                      onPressed: model.logOut,
                      color: SharedColors.defaultColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )
                    ),
                  ),
                )
              ],
            )
          );
        }else{
          return StartMenu();
        }

      }
      
    );
  }
}

class MySliverHeader extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String profilePic;
  final String userName;
  final String email;
  final int points;
  final Function onUpdateProfileClicked;
  final Function onUpdateBillingAdressClicked;
  final Function onUpdateDeliveryAdressClicked;
  final Function onUpdatePasswordClicked;

  MySliverHeader(
      {@required this.expandedHeight,
      this.profilePic,
      this.userName,
      this.email,
      this.points,
      this.onUpdateProfileClicked, 
      this.onUpdateBillingAdressClicked, 
      this.onUpdatePasswordClicked,
      this.onUpdateDeliveryAdressClicked});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: SharedColors.defaultColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 15,
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed(RoutesManager.redeemPointsView),
              iconSize: 28,
              icon: FaIcon(
                FontAwesomeIcons.gift,
              ),
            ),
          ),

          Positioned(
            top: 0,
            right: 15,
            child: PopupMenuButton<int>(
              onSelected: (value) {
                switch(value){
                  case 1:
                    onUpdateProfileClicked();
                    break;
                  case 2:
                    onUpdateBillingAdressClicked();
                    break;
                  case 3:
                    onUpdatePasswordClicked();
                    break;
                  case 4:
                    onUpdateDeliveryAdressClicked();
                    break;
                  default:
                    print("out of bound");
                }
              },
              icon: FaIcon(
                FontAwesomeIcons.cog
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("Update profile picture"),
                  value: 1,
                ),

                PopupMenuItem(
                  child: Text("Update billing adresses"),
                  value: 2,
                ),

                PopupMenuItem(
                  child: Text("Update delivery adresses"),
                  value: 4,
                ),

                PopupMenuItem(
                  child: Text("Update password"),
                  value: 3,
                ),
              ],
            )
          ),

          FittedBox(
            fit: BoxFit.fitHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),

                //! avatar image
                CircleAvatar(
                  backgroundImage: NetworkImage(profilePic ?? "${ApiService.endpoint}/static/user.png"),
                  minRadius: 70,
                  maxRadius: 130,
                  backgroundColor: Colors.white,
                ),
                SizedBox(
                  height: 25,
                ),

                //! username
                Text(userName,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        
                        fontSize: 48,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),

                //! email
                Text(email,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        
                        fontSize: 20,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 15,
                ),

                //! points
                Text("Points : $points",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        
                        fontSize: 20,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 160;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
