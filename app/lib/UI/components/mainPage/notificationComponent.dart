import 'package:ecom/UI/components/SearchAppBar.dart';
import 'package:ecom/UI/components/mainPage/startMenu.dart';
import 'package:ecom/UI/components/notificationsCard.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/notificationComponentViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/models/notificationData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationComponent extends StatelessWidget {
  const NotificationComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationComponentViewModel>(
      viewModel: NotificationComponentViewModel(),
      onModelReady: (model) => model.getNotifications(),
      builder: (context, model, _) {
        if(!model.isConnected) 
          return StartMenu();
        else
          return RefreshIndicator(
            onRefresh: model.getNotifications,
            color: SharedColors.defaultColor,
            child: CustomScrollView(
              slivers: [
                SearchAppBar(),

                if(model.notificationsAreLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: SharedColors.defaultColor,
                      ),
                    )
                  )
                else
                  if(model.notifications == null)
                    SliverToBoxAdapter(
                      child: Text(
                        model.errors, 
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          color: SharedColors.secondaryColor, 
                          fontSize: 20),
                        ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          for(NotificationData data in model.notifications)
                            ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: NotificationCard(notification: data, onUpdate: model.getNotifications,)
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),

                                  FlatButton(
                                    onPressed: () => model.deleteNotification(data),
                                    color: SharedColors.defaultColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      child: FaIcon(
                                        FontAwesomeIcons.trash,
                                        color: Colors.white,
                                      ),
                                    )
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                            ]
                        ]),
                      ),
                    ),

              ],
            ),
          );
      }
    );
  }
}