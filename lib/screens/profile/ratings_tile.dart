import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/entry.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';

class RatingTile extends StatefulWidget {
  @override
  _RatingTileState createState() => _RatingTileState();
}

class _RatingTileState extends State<RatingTile> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    Restaurant restaurant = Provider.of<Restaurant>(context);
    Rating rating = Provider.of<Rating>(context);
    MenuEntry entry;
    try {
      entry = restaurant.menu.firstWhere((entry) =>
      entry.id == rating.entry_id);
    }catch(e){
      print(e);
    }
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return entry != null? GestureDetector(
      onTap: () async{
        await showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
          return Provider.value(value: false, child: Provider<Restaurant>.value(value: restaurant, child: Provider<MenuEntry>.value(value: entry, child: EntryRating())));
        }).then((value){setState(() {});});
      },
      child: Container(
        width: 390.w,
        height: 136.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50.h,
                    width: 206.w,
                    child: Text(entry.name,  maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                  ),
                  Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(tr.translate("ratedwith"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(13),),)),
                      StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: entry.rating, size: ScreenUtil().setSp(13),),
                    ],
                  ),
                  Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${tr.translate("on")} ${Functions.formatDate(rating.date)}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(13),),)),
                    ],
                  ),
                  SizedBox(height: 7.h,),
                  Row( mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          height: 21.h,
                          width: 206.w,
                          child: Text(restaurant.name, textAlign: TextAlign.end, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(16),),))
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 136.h,
              width: 136.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), topRight: Radius.circular(30)),
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
                          width: 60.w,
                          height: 23.h,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 110, 117, 0.9),
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: Align( alignment: Alignment.center, child: Text("${entry.price} €", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(15),),))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ):Container();
  }
}
