import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
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
  bool init = true;
  _MenuState({this.restaurant});

  List<Widget> _initList(BuildContext context) {
    restaurant.menu.sort((f, s) => f.pos.compareTo(s.pos));
    List<Widget> lists = new List<Widget>();
    Map<String,List<Widget>> sections = {};
    for (String section in restaurant.sections) {
      sections[section] = [];
      for (MenuEntry entry in restaurant.menu) {
        if (section == entry.section) {
          sections[section].add(Provider<MenuEntry>.value(
              key: UniqueKey(),
              value: entry, child: MenuTile(daily: false,)));
        }
      }
      bool expanded = true;
      Widget sectionText = Padding(
          key: UniqueKey(),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: GestureDetector(
            onTap: (){
              setState(() {
                expanded = !expanded;
                print(expanded);
              });
            },
            child: Row( mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(section, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
                Spacer(),
                Icon(expanded  ? Icons.expand_less : Icons.expand_more, size: ScreenUtil().setSp(28),)
              ],
            ),
          ),
      );
      lists.add(
        sectionText
      );
      lists.addAll(sections[section]);
    }
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    if(restaurant.sections != null){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: _initList(context),
        )
      );
    }
    else return Container();
  }


}
