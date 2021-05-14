import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/notificationViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/models/notificationData.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  final NotificationData notificationData;

  const NotificationView({Key key, this.notificationData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationViewModel>(
      viewModel: NotificationViewModel(),
      onModelReady: (model) => model.init(notificationData.id),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                
                backgroundColor: SharedColors.defaultColor,
                title: Text(
                  "Notification : ${notificationData.title}"
                ),
                centerTitle: true,
              ),

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      notificationData.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 2,
                        fontFamily: 'Raleway',
                        fontSize: 17, 
                        color: Colors.grey.shade800, 
                        fontWeight: FontWeight.bold
                      )
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      notificationData.content,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        letterSpacing: 2,
                        fontSize: 15, 
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}