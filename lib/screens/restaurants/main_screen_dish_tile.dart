import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/userDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/entry.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DishTile extends StatefulWidget {
  @override
  _DishTileState createState() => _DishTileState();
}

class _DishTileState extends State<DishTile> {
  MenuEntry entry;
  User user;
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    entry = Provider.of<MenuEntry>(context);
    restaurant = Provider.of<Restaurant>(context);
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return GestureDetector(
        onTap: () async{
          await showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
            return Provider<Restaurant>.value(value: restaurant, child: Provider<MenuEntry>.value(value: entry, child: EntryRating()));
          }).then((value){setState(() {});});
        },
        child: Container(
          height: 170.h,
          width: 220.w,
          child: Column(
            children: <Widget>[
              Container(
                width: 220.w,
                height: 100.h,
                decoration: BoxDecoration(
                    //color: Color.fromRGBO(255, 110, 117, 0.1),
                    image: DecorationImage(image: Image.network(entry.image == null || entry.image == "" ? StaticStrings.defaultEntry : entry.image, fit: BoxFit.cover).image)
                ),
                child: entry.price == 0.0 ? Container() : Column( mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                          child: Container(
                            width: 58.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 110, 117, 0.9),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Align( alignment: Alignment.center, child: Text("${entry.price} ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h,),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(width: 100.w, height: 32.h, child: Text("${entry.name}", maxLines: 2, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3,  fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),))),
                  SizedBox(width: 7.w,),
                  Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      //SmoothStarRating(rating: entry.rating, spacing: -3, isReadOnly: true, allowHalfRating: true, color: Color.fromRGBO(250, 201, 53, 1), borderColor: Color.fromRGBO(250, 201, 53, 1), size: ScreenUtil().setSp(10),),
                      StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: entry.rating, size: ScreenUtil().setSp(9),),
                      Text("${entry.numReviews} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(10),),)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h,),
              Container(width: 210.w, child: Text(restaurant.name, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14),),)))
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(1, 1), // changes position of shadow
              ),],
          ),
        )
    );
  }
}
