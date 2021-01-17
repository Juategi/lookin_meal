import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/menu_tile.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/translator.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:provider/provider.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class EntryRating extends StatefulWidget {
  @override
  _EntryRatingState createState() => _EntryRatingState();
}

class _EntryRatingState extends State<EntryRating> {
  MenuEntry entry;
  Restaurant restaurant;
  double rate, oldRate;
  bool hasRate;
  bool indicator = false;
  bool init = true;
  Rating actual;
  String comment = "";
  final DBService _dbService = DBService();
  final formatter = new DateFormat('yyyy-MM-dd');


  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    try {
      restaurant = Provider.of<Restaurant>(context);
    }catch(e){

    }
    entry = Provider.of<MenuEntry>(context);
    if(init){
      rate = 0.0;
      hasRate = false;
      for(Rating r in DBService.userF.ratings){
        if(r.entry_id == entry.id){
          rate = r.rating;
          oldRate = rate;
          comment = r.comment;
          hasRate = true;
          actual = r;
        }
      }
      init = false;
    }
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 40.h,),
            Container(
                height: 342.h,
                width: 342.w,
                decoration: entry.image == null || entry.image == "" ? null: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1),
                  image: entry.image == null || entry.image == ""? null: DecorationImage(
                    image: Image.network(
                        entry.image).image,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column( mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    restaurant != null ? Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap:(){
                            Navigator.pushNamed(context, "/restaurant",arguments: restaurant).then((value) => setState(() {}));
                          },
                          child: Container(
                              height: 45.h,
                              width: 45.w,
                              child: SvgPicture.asset("assets/menu.svg", color: Color.fromRGBO(255, 110, 117, 0.9), fit: BoxFit.contain,)
                          ),
                        ),
                      ],
                    ) : Container(),
                    SizedBox(height: 240.h,),
                    entry.price == 0.0 ? Container():Row( mainAxisAlignment: entry.image == null || entry.image == ""?  MainAxisAlignment.center : MainAxisAlignment.start,
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
                            child: Align( alignment: Alignment.center, child: Text("${entry.price} ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(22),),))),
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
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                      child: Column(
                        children: <Widget>[
                          Text("Alérgenos", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: ScreenUtil().setSp(22),),),
                          SizedBox(height: 10.h,),
                          Center(
                            child: Container(
                              height: 320.h,
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
            Container(
              //color: Color.fromRGBO(255, 110, 117, 0.1),
              height: 150.h,
              width: 342.w,
              child: TextField(
                keyboardType: TextInputType.text,
                maxLength: 250,
                maxLines: 8,
                decoration: textInputDeco,
                controller: TextEditingController()..text = comment..selection = TextSelection.fromPosition(TextPosition(offset: comment.length)) , onChanged: (v) {
                comment = v;
              },),
            ),
            SizedBox(height: 15.h,),
            Center(
              child: SmoothStarRating(
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
                    actual.comment = comment;
                    await _dbService.deleteRate(DBService.userF.uid, entry.id);
                    _dbService.addRate(DBService.userF.uid, entry.id, rate, comment);
                    double aux = (entry.rating*entry.numReviews + rate - oldRate)/(entry.numReviews);
                    //entry.rating = double.parse(aux.toStringAsFixed(2));
                    entry.rate = double.parse(aux.toStringAsFixed(2));
                    print("______________");
                    print(entry.rating);
                    Alerts.toast("Rating saved");
                    Navigator.pop(context);
                  }
                  else{
                    DBService.userF.ratings.add(Rating(
                        entry_id: entry.id,
                        rating: rate,
                        date: formatter.format(DateTime.now()),
                        comment: comment
                    ));
                    DBService.userF.history[entry.id] = restaurant;
                    _dbService.addRate(DBService.userF.uid, entry.id, rate, comment);
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
            ),
            SizedBox(height: 15.h,),
          ],
        ),
      ),
    );
  }
}
