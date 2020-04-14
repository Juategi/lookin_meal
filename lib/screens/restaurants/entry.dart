import 'package:flutter/material.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class EntryRating extends StatefulWidget {
  MenuEntry entry;
  User user;
  EntryRating(this.entry, this.user);
  @override
  _EntryRatingState createState() => _EntryRatingState(entry, user);
}

class _EntryRatingState extends State<EntryRating> {
  _EntryRatingState(this.entry, this.user);
  User user;
  MenuEntry entry;
  double rate = 0.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(entry.image ?? "https://sevilla.abc.es/gurme/wp-content/uploads/sites/24/2012/01/comida-rapida-casera.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text(entry.name),
          SizedBox(height: 20,),
          SmoothStarRating(
            allowHalfRating: true,
            rating: rate,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            size: 50,
            onRatingChanged: (v) {
              rate = v;
              setState(() {
              });
            },
          ),
        ],
      ),
    );
  }
}
