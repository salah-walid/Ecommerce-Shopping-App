import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/notificationData.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final Function onUpdate;

  const NotificationCard({Key key, this.notification, this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await Navigator.of(context).pushNamed(RoutesManager.notification, arguments: notification);
        onUpdate();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: SharedColors.defaultColor,
              offset: Offset(0.0, 0.5), //(x,y)
              blurRadius: 10.0,
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                if(!notification.isRead)
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: SharedColors.defaultColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),

                SizedBox(
                  width: 10,
                ),

                Text(
                  notification.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    letterSpacing: 4,
                    fontFamily: 'Raleway',
                    fontSize: 17, 
                    color: Colors.brown.shade800, 
                    fontWeight: FontWeight.bold
                  )
                ),

              ],
            ),

            SizedBox(height: 10,),

            Text(
              notification.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade600,
                letterSpacing: 2,
                fontFamily: 'Raleway',
                fontSize: 15, 
                fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}