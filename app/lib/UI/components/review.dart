import 'package:ecom/core/models/reviewData.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewCard extends StatelessWidget {
  final ReviewData reviewData;

  const ReviewCard({Key key, this.reviewData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text(
                reviewData.user.username.toUpperCase(),
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey.shade800
                ),
              ),

              CircleAvatar(
                backgroundImage: NetworkImage(
                  reviewData.user.userPic,
                  
                ),
              )
            ],
          ),

          

          SizedBox(height: 5,),

          SmoothStarRating(
            allowHalfRating: false,
            rating: reviewData.stars.toDouble(),
            starCount: 5,
            size: 22,
            isReadOnly: true,
            color: Colors.yellowAccent.shade700,
            borderColor: Colors.grey,
          ),

          SizedBox(height: 15,),

          Text(
            reviewData.content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800
            ),
          ),

        ],
      ),
    );
  }
}