import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/entry.dart';
import 'package:lookinmeal/services/database.dart';
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

  Future updateRecent() async{
    for(Restaurant r in user.recently){
      if(r.restaurant_id == restaurant.restaurant_id){
        return;
      }
    }
    if(user.recently.length == 5){
      user.recently.removeAt(0);
    }
    user.recently.add(restaurant);
    user.recent = user.recently;
    DBService.dbService.updateRecently();
  }

  @override
  Widget build(BuildContext context) {
    entry = Provider.of<MenuEntry>(context);
    restaurant = Provider.of<Restaurant>(context);
    user = DBService.userF;
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return GestureDetector(
      onTap: (){
        updateRecent();
        Navigator.pushNamed(context, "/restaurant",arguments: restaurant);
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
                    image: DecorationImage(image: Image.network(entry.image == null || entry.image == "" ? StaticStrings.defaultEntry : entry.image, fit: BoxFit.fitHeight).image)
                ),
              ),
              SizedBox(height: 10.h,),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(width: 100.w, child: Text("${entry.name}", maxLines: 2, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3,  fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),))),
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
              entry.price == 0.0 ? SizedBox(height: 22.h,) : SizedBox(height: 12.h,),
              Row( mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  entry.price == 0.0 ? Container(width: 55.w, height: 17.h,) : Container(
                    width: 55.w,
                    height: 17.h,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 110, 117, 0.9),
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    child: Text("${entry.price} €", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(11),),)),
                  ),
                  SizedBox(width: 5.w,),
                  Container(width: 145.w, child: Text(restaurant.name, maxLines: 1, textAlign: TextAlign.end, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14),),))),
                  SizedBox(width: 8.w,)
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(1, 1), // changes position of shadow
              ),]
          ),
        )
    );
  }
}
