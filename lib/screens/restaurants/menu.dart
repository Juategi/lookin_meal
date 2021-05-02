import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/menu_tile.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  double rate = 0.0;
  Restaurant restaurant;
  Map<String,bool> expanded = {};
  bool init = true;
  bool order;
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

    restaurant = Provider.of<Restaurant>(context);
    order = Provider.of<bool>(context);
    if(init){
      for(String section in restaurant.sections){
        expanded[section] = false;
      }
      init = false;
    }
    if(restaurant.sections != null){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children:
            restaurant.sections.map((section) =>
                Column(
                  children: [
                    Padding(
                      key: UniqueKey(),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            expanded[section] = !expanded[section];
                          });
                        },
                        child: Row( mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(Functions.limitString(section, 26), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
                            Spacer(),
                            Icon(expanded[section]  ? Icons.expand_less : Icons.expand_more, size: ScreenUtil().setSp(28),)
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: expanded[section]  ?
                        restaurant.menu.map((entry){
                          if(section == entry.section && entry.hide)
                            return Provider.value(
                              value: order,
                              key: UniqueKey(),
                              child: Provider<Restaurant>.value(
                                key: UniqueKey(),
                                value: restaurant,
                                child: Provider<MenuEntry>.value(
                                    key: UniqueKey(),
                                    value: entry, child: MenuTile(daily: false,)),
                              ),
                            );
                          else
                            return Container();
                        }
                        ).toList() : [Container()]
                    )
                  ]
                )
            ).toList()
          ,
        )
        /*child: ExpansionPanelList(
            animationDuration: Duration(milliseconds: 300),
            elevation: 1,
            expansionCallback: (i, isOpen){
              setState(() {
                expanded[restaurant.sections[i]] = !expanded[restaurant.sections[i]];
              });
            },
          children: restaurant.sections.map((section) =>
            ExpansionPanel(canTapOnHeader: true,
              isExpanded: expanded[section],
              headerBuilder: (context, isOpen){
                return  Row( mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(Functions.limitString(section, 26), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
                  ],
                );
              },
              body: Column(
                  children: restaurant.menu.map((entry){
                    if(section == entry.section && entry.hide)
                      return Provider.value(
                        value: order,
                        key: UniqueKey(),
                        child: Provider<Restaurant>.value(
                          key: UniqueKey(),
                          value: restaurant,
                          child: Provider<MenuEntry>.value(
                              key: UniqueKey(),
                              value: entry, child: MenuTile(daily: false,)),
                        ),
                      );
                    else
                      return Container();
                  }
                  ).toList()
              )
            )
          ).toList(),
        )*/
      );
    }
    else return Container();
  }


}
