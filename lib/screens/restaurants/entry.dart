import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/menu_tile.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/translator.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class EntryRating extends StatefulWidget {
  MenuEntry entry;
  EntryRating(this.entry);
  @override
  _EntryRatingState createState() => _EntryRatingState(entry);
}

class _EntryRatingState extends State<EntryRating> {
  _EntryRatingState(this.entry);
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
    user = DBService.userF;
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
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: <Widget>[
          SizedBox(height: 40.h,),
          entry.image == null || entry.image == ""? Container(height: 300.h,) : Container(
              height: 342.h,
              width: 342.w,
              decoration: entry.image == null || entry.image == "" ? null: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 1),
                image: DecorationImage(
                  image: Image.network(
                      entry.image).image,
                  fit: BoxFit.cover,
                ),
              ),
              child: entry.price == 0.0 ? Container() : Column( mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                        child: Container(
                          width: 100.w,
                          height: 33.h,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 110, 117, 0.9),
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: Align( alignment: Alignment.center, child: Text("${entry.price} €", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(22),),))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ),
          SizedBox(height: 10.h,),
          Container(width: 360.w,child: Text("${entry.name}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.7), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
          SizedBox(height: 10.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text("${entry.description}", maxLines: 6, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
          ),
          SizedBox(height: 10.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: GestureDetector(
              child: Container(
                height: 100.h,
                child: Wrap(
                  //crossAxisCount: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: entry.allergens.map((allergen) => Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: Image.asset("assets/allergens/${allergen}.png").image))
                  ),).toList(),
                ),
              ),
              onTap: (){
                showModalBottomSheet(context: context,  builder: (BuildContext bc){
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
                    child: Column(
                      children: <Widget>[
                        Text("Alérgenos", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: ScreenUtil().setSp(22),),),
                        SizedBox(height: 10.h,),
                        Center(
                          child: Container(
                            height: 200.h,
                            //width: 300.w,
                            child: Wrap(
                              direction: Axis.vertical,
                              children: CommonData.allergens.map((allergen) => Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Container(
                                        height: 40.h,
                                        width: 40.w,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: Image.asset("assets/allergens/$allergen.png").image))
                                    ),
                                  ),
                                  SizedBox(width: 10.w,),
                                  Text("${allergen[0].toUpperCase()}${allergen.substring(1)}", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(13),),),
                                ],
                              )).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
              },
            ),
          ),
          SizedBox(height: 10.h,),
          SmoothStarRating(
            allowHalfRating: true,
            rating: rate,
            color: Color.fromRGBO(250, 201, 53, 1),
            borderColor: Color.fromRGBO(250, 201, 53, 1),
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            size: ScreenUtil().setSp(45),
            onRated: (v) async{
              rate = v;
              indicator = true;
              setState(() {});
              if(hasRate){
                actual.rating = rate;
                actual.date = formatter.format(DateTime.now());
                await _dbService.deleteRate(user.uid, entry.id);
                _dbService.addRate(user.uid, entry.id, rate);
                double aux = (entry.rating*entry.numReviews + rate - oldRate)/(entry.numReviews);
                //entry.rating = double.parse(aux.toStringAsFixed(2));
                entry.rate = double.parse(aux.toStringAsFixed(2));
                print("______________");
                print(entry.rating);
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
                //entry.rating = double.parse(aux.toStringAsFixed(2));
                //entry.numReviews += 1;
                entry.rate = double.parse(aux.toStringAsFixed(2));
                entry.reviews = entry.numReviews + 1;
                Alerts.toast("Rating saved");
                Navigator.pop(context);
              }
            },
          ),

        ],
      ),
    );
  }
}
