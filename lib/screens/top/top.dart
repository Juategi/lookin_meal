import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/main_screen_dish_tile.dart';
import 'package:lookinmeal/screens/restaurants/restaurant_tile.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:provider/provider.dart';

class Top extends StatefulWidget {
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> {
  List<Restaurant> topRestaurant, sponsored;
  Map<MenuEntry,Restaurant> topEntry;
  Position last;

  Future _loadData() async{
    if(last != GeolocationService.myPos) {
      topRestaurant = await DBServiceRestaurant.dbServiceRestaurant.getTopRestaurants();
      topEntry = await DBServiceRestaurant.dbServiceRestaurant.getTopEntries();
      sponsored = await DBServiceRestaurant.dbServiceRestaurant.getSponsored(3);
      last = GeolocationService.myPos;
      List<Restaurant> aux = [];
      for(Restaurant r in topRestaurant){
        if(sponsored.contains(r)){
          aux.add(r);
        }
      }
      for(Restaurant r in aux){
        topRestaurant.remove(r);
      }
      print("top updated");
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    _loadData();
    return SafeArea(
      child: Scaffold(
        //backgroundColor: CommonData().getColor(),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: topEntry == null? Loading() : Column(
            children: <Widget>[
              SizedBox(height: 10.h,),
              Row( mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Top Restaurants', textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
              SizedBox(height: 10.h,),
              Container(
                height: 350.h,
                child: /*ListView(
                  scrollDirection: Axis.horizontal,
                  children: topRestaurant.map((r) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),),
                  )).toList(),
                ),*/
                GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1.3 / 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 2
                  ),
                  children: sponsored.map((r) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Provider<bool>.value(value: true, child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),)),
                  )).toList() + topRestaurant.map((r) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Provider<bool>.value(value: false, child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),)),
                  )).toList(),
                ),
              ),
              SizedBox(height: 50.h,),
              Row( mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Top dishes', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
              SizedBox(height: 10.h,),
              Container(
                height: 200.h,
                child:ListView(
                  scrollDirection: Axis.horizontal,
                  //children: user.favorites.first.menu.map((e) => Provider<MenuEntry>.value(value: e, child: DishTile(),)).toList(),
                  children: topEntry.entries.map((e) => MultiProvider(
                    providers: [
                      Provider<MenuEntry>(create: (c) => e.key,),
                      Provider<Restaurant>(create: (c) => e.value,)
                    ],
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      child: DishTile(),
                    ),
                  ) ).toList(),
                ),
                /*GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1 / 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1
                  ),
                  children: topEntry.entries.map((e) => MultiProvider(
                    providers: [
                      Provider<MenuEntry>(create: (c) => e.key,),
                      Provider<Restaurant>(create: (c) => e.value,)
                    ],
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      child: DishTile(),
                    ),
                  ) ).toList(),
                ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}
