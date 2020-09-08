import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/menu_tile.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:provider/provider.dart';

class DailyMenu extends StatefulWidget {
  Restaurant restaurant;
  String currency;
  DailyMenu({this.restaurant, this.currency});

  @override
  _DailyMenuState createState() => _DailyMenuState(restaurant: restaurant);
}

class _DailyMenuState extends State<DailyMenu> {
  double rate = 0.0;
  Restaurant restaurant;
  _DailyMenuState({this.restaurant});

  List<Widget> _initList(BuildContext context){
    List<Widget> entries = new List<Widget>();
    entries.add(
      Text(restaurant.dailymenu[0], maxLines: 4, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
    );
    entries.add(
      Row( mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              width: 104.w,
              height: 37.h,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 110, 117, 0.9),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text("${restaurant.dailymenu[1]} €", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(22),),))
          ),
        ],
      ),
    );
    for(int i = 2; i < restaurant.dailymenu.length; i++){
      if(!_isNumeric(restaurant.dailymenu[i])){
        entries.add(
            Text(restaurant.dailymenu[i], maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))
        );
      }
      else{
        MenuEntry entry = restaurant.menu.firstWhere((entry) => entry.id == restaurant.dailymenu[i], orElse: () => null);
        if(entry != null)
          entries.add(Provider<MenuEntry>.value(value: entry, child: MenuTile(daily: true,)));
      }
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    if(restaurant.sections != null){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: _initList(context)
        ),
      );
    }
    else return Container();
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

}