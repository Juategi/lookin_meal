import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/menu_tile.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  Restaurant restaurant;
  String currency;
  Menu({this.restaurant, this.currency});

  @override
  _MenuState createState() => _MenuState(restaurant: restaurant);
}

class _MenuState extends State<Menu> {
  double rate = 0.0;
  Restaurant restaurant;
  _MenuState({this.restaurant});

  List<Widget> _initList(BuildContext context){
    restaurant.menu.sort((f,s)=> f.pos.compareTo(s.pos));
    List<Widget> entries = new List<Widget>();
    for(String section in restaurant.sections){
      entries.add(
          Text(section, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))
      );
      for(MenuEntry entry in restaurant.menu){
        if(section == entry.section){
          entries.add(Provider<MenuEntry>.value(value: entry, child: MenuTile(daily: false,)));
        }
      }
      entries.add(SizedBox(height: 5,));
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
}
