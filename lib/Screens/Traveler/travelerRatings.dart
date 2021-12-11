import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class GetTravelerRatings extends StatelessWidget {
  
final String? reviewerName;
final num? rating;
final String? comment;

GetTravelerRatings({
  this.reviewerName,
  this.rating,
  this.comment
});

factory GetTravelerRatings.fromDocument(DocumentSnapshot doc){
  return GetTravelerRatings(
  reviewerName: doc.data().toString().contains('reviewerName') ? doc.get('reviewerName') : 0.0,  
  rating: doc.data().toString().contains('rating') ? doc.get('rating') : 0.0,
  comment: doc.data().toString().contains('comment') ? doc.get('comment') : 0.0,
   );
}

ratingHeader(){
  return Text(
    reviewerName!,
  );
}

ratingBody(){
  return SmoothStarRating(
          allowHalfRating: true,
          starCount: 5,
          rating: rating!.toDouble(),
          size: 30.0,
          isReadOnly:true,
          color: Colors.yellow[900],
          borderColor: Colors.yellow[900],
          spacing:0.0
    );
}

ratingFooter(){
  return Text(
    comment!
  );
}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[350]!,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ratingHeader(),
            Divider(
              height: 33,
              thickness: 5,
            ),
            ratingBody(),
            Divider(
              height: 33,
              thickness: 5,
            ),
            ratingFooter()
          ],
        ),
      ),
    );
  }
}