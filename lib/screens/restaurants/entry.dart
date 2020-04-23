import 'package:flutter/material.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/loading.dart';
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
  double rate;
  bool hasRate;
  int pos;
  final DBService _dbService = DBService();

  @override
  void initState(){
    super.initState();
    for(int i = 0; i < user.ratings.length; i+=2){
      if(user.ratings.elementAt(i).toString() == entry.id){
          rate = user.ratings.elementAt(i+1).toDouble();
          hasRate = true;
          pos = i;
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
          Text(hasRate ? "" : "Valora el plato!"),
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
          SizedBox(height: 20,),
          RaisedButton(
            child: Text(tr.translate("rate")),
            onPressed: (){
              if(hasRate){
                //borrar y añadir si no ha cambiado tanto en BD como en local
                print(rate);
                print(entry.id);
                user.ratings.replaceRange(pos, pos, [rate]);
                _dbService.deleteRate(user.uid, entry.id);
                _dbService.addRate(user.uid, entry.id, rate);
              }
              else{
                user.ratings.add(num.parse(entry.id));
                user.ratings.add(rate);
                _dbService.addRate(user.uid, entry.id, rate);
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
