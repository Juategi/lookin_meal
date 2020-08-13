import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/strings.dart';
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
  double rate, oldRate;
  bool hasRate;
  bool indicator = false;
  Rating actual;
  final DBService _dbService = DBService();
  final formatter = new DateFormat('yyyy-MM-dd');

  @override
  void initState(){
    super.initState();
    for(Rating r in user.ratings){
      if(r.entry_id == entry.id){
          rate = r.rating;
          oldRate = rate;
          hasRate = true;
          actual = r;
          return;
      }
    }
    rate = 0.0;
    hasRate = false;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    return Container(
      height: 500,
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(entry.image ?? StaticStrings.defaultEntry),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 15,),
          Text(entry.name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54, fontSize: 18,),),
          SizedBox(height: 5,),
          Text(entry.description ?? " ", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54, fontSize: 15,),),
          SizedBox(height: 20,),
          Text(hasRate ? actual.date : "Valora el plato!"),
          SizedBox(height: 10,),
          SmoothStarRating(
            allowHalfRating: true,
            rating: rate,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            size: 40,
            onRated: (v) {
              rate = v;
              setState(() {
              });
            },
          ),
          SizedBox(height: 20,),
          RaisedButton(
            child: indicator ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),) : Text(tr.translate("rate")),
            onPressed: ()async{
              indicator = true;
              setState(() {});
              if(hasRate){
                actual.rating = rate;
                actual.date = formatter.format(DateTime.now());
                await _dbService.deleteRate(user.uid, entry.id);
                _dbService.addRate(user.uid, entry.id, rate);
                double aux = (entry.rating*entry.numReviews + rate - oldRate)/(entry.numReviews);
                entry.rating = double.parse(aux.toStringAsFixed(2));
                Alerts.toast("Rating saved");
                Navigator.pop(context);
              }
              else{
                user.ratings.add(Rating(
                  entry_id: entry.id,
                  rating: rate,
                  date: formatter.format(DateTime.now())
                ));
                _dbService.addRate(user.uid, entry.id, rate);
                double aux = (entry.rating*entry.numReviews + rate)/(entry.numReviews+1);
                entry.rating = double.parse(aux.toStringAsFixed(2));
                entry.numReviews += 1;
                Alerts.toast("Rating saved");
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
