import 'package:expandable/expandable.dart';
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
  Column _column;
  bool init = true;
  _MenuState({this.restaurant});

  void _initList(BuildContext context) {
    restaurant.menu.sort((f, s) => f.pos.compareTo(s.pos));
    List<Widget> lists = new List<Widget>();
    Map<String,List<Widget>> sections = {};
    for (String section in restaurant.sections) {
      sections[section] = [];
      for (MenuEntry entry in restaurant.menu) {
        if (section == entry.section) {
          sections[section].add(Provider<MenuEntry>.value(
              value: entry, child: MenuTile(daily: false,)));
        }
      }
      Widget sextionText = ExpandableButton(
        child: Text(section, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))
      );
      lists.add(
        ExpandableNotifier(
            child: Column(
                children: [
                  Expandable(
                    collapsed: ExpandableButton(
                      child: sextionText
                    ),
                    expanded: Column(
                        children: [sextionText]+sections[section]
                    ),
                  ),
                ]
          )
        )
      );
      //entries.add(SizedBox(height: 5,));
      _column = Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: lists
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    if(init){
      _initList(context);
      init = false;
    }
    if(restaurant.sections != null){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: _column
      );
    }
    else return Container();
  }


}


/*
ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i){
                return ExpansionTile(
                  title: Text(section, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
                  children: entries[section],
                  onExpansionChanged: (changed){
                    setState(() {
                      extended = changed;
                    });
                    print(extended);
                  },
                );
              },
            ),
 */