import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/entry.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class TopDishesTile extends StatefulWidget {
  @override
  _TopDishesTileState createState() => _TopDishesTileState();
}

class _TopDishesTileState extends State<TopDishesTile> with TickerProviderStateMixin {
  MenuEntry entry;
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    entry = Provider.of<MenuEntry>(context);
    restaurant = Provider.of<Restaurant>(context);
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Card(
          elevation: 0 ,
          child: Container(
            width: 116.w,
            height: 116.h,
            //color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 120.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      //color: Color.fromRGBO(255, 110, 117, 0.1),
                      image: DecorationImage(image: Image.network(entry.image == null || entry.image == "" ? StaticStrings.defaultEntry : entry.image, fit: BoxFit.fitHeight).image)
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(width: 55.w, child: Text("${entry.name}", maxLines: 2, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3,  fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(9),),))),
                      Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          //SmoothStarRating(rating: entry.rating, spacing: -3, isReadOnly: true, allowHalfRating: true, color: Color.fromRGBO(250, 201, 53, 1), borderColor: Color.fromRGBO(250, 201, 53, 1), size: ScreenUtil().setSp(10),),
                          StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: entry.rating, size: ScreenUtil().setSp(7),),
                          Text("${entry.numReviews} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(8),),)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h,),
                  entry.price == 0.0 ? Container(width: 70.w,) : Container(
                    width: 50.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 110, 117, 0.9),
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    child: Text("${entry.price} ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(10),),)),
                  )
                ],
              ),
            )
          ),
        ),
      ),
      onTap: () async{
        await showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
          return Provider<Restaurant>.value(
              value: restaurant, child: Provider<MenuEntry>.value(value: entry, child: EntryRating()));
        }).then((value){setState(() {});});
      },
    );
  }
}
