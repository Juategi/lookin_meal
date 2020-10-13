import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Search extends StatefulWidget {
  Position myPos;
  String locality;
  Search({this.myPos,this.locality});
  @override
  _SearchState createState() => _SearchState(myPos: myPos, locality: locality);
}

class _SearchState extends State<Search> {
  User user;
  List<bool> _selections = List.generate(2, (index) => false);
  Map<MenuEntry, Restaurant> map;
  bool isRestaurant = true;
  Position myPos;
  String locality;
  double rate = 0;
  double price = 0;
  String error = "";
  _SearchState({this.myPos,this.locality});

  Future<List<Restaurant>> _search(String query) async{
    List<Restaurant> list = await SearchService().query(myPos.latitude, myPos.longitude, locality, query);
    if(list.length == 0)
      error = "No results";
    else
      error = "";
    return list;
  }

  Future<List<MenuEntry>> _searchEntry(String query) async{
    map = await SearchService().queryEntry(myPos.latitude, myPos.longitude, locality, query);
    if(map.length == 0)
      error = "No results";
    else
      error = "";
    return map.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      //appBar: AppBar(backgroundColor: ThemeData().scaffoldBackgroundColor,),
      backgroundColor: CommonData.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.h,),
            Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isRestaurant = true;
                    });
                  },
                  child: Container(
                    width: 110.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                        color: isRestaurant? Color.fromRGBO(255, 110, 117, 0.9) : Color.fromRGBO(255, 110, 117, 0.3)  ,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Center(child: Text("RESTAURANTS", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isRestaurant = false;
                    });
                  },
                  child: Container(
                    width: 110.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                        color: !isRestaurant? Color.fromRGBO(255, 110, 117, 0.9) : Color.fromRGBO(255, 110, 117, 0.3)  ,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Center(child: Text("DISHES", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: 390.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16))
                    ),
                    child: TextField(
                      //controller: _searchQuery,
                      autofocus: false,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                      decoration: new InputDecoration.collapsed(
                          hintText: "   Restaurant or dish...",
                          hintStyle: new TextStyle(color: Colors.black45)
                      ),
                    ),
                  ),
                ),
              ],
            ),
           !isRestaurant? Column(
             children: <Widget>[
               Row( mainAxisAlignment: MainAxisAlignment.end,
                 children: <Widget>[
                   GestureDetector(
                       child: Text("+Add", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.grey, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),))
                   )
                 ],
               ),
               SizedBox(height: 20.h,),
               Row(mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Text("Filters", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black54, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                 ],
               ),
               SizedBox(height: 20.h,),
               Container(
                 width: 388.w,
                 height: 104.h,
                 decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.all(Radius.circular(12))
                 ),
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                   child: Column(
                     children: <Widget>[
                       Row(mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           Text("Stars", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black54, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                         ],
                       ),
                       SizedBox(height: 15.h,),
                       Row(mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           SmoothStarRating(
                             allowHalfRating: true,
                             rating: rate,
                             color: Color.fromRGBO(250, 201, 53, 1),
                             borderColor: Color.fromRGBO(250, 201, 53, 1),
                             filledIconData: Icons.star,
                             halfFilledIconData: Icons.star_half,
                             size: ScreenUtil().setSp(45),
                             onRated: (v) async{
                             },
                           ),
                         ],
                       )
                     ],
                   ),
                 ),
               ),
               SizedBox(height: 20.h,),
               Container(
                 width: 388.w,
                 height: 104.h,
                 decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.all(Radius.circular(12))
                 ),
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                   child: Column(
                     children: <Widget>[
                       Row(mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           Text("Price", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black54, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                         ],
                       ),
                       SizedBox(height: 15.h,),
                       Row(mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           Container(
                             width: 330.w,
                             child: Slider(
                               value: price,
                               divisions: 100,
                               max: 50,
                               min: 0,
                               activeColor: Color.fromRGBO(255, 110, 117, 0.9),
                               inactiveColor: Color.fromRGBO(255, 110, 117, 0.2),
                               label: price.toStringAsFixed(1) + "€",
                               onChanged: (val){
                                 setState(() {
                                   price = val;
                                 });
                               },
                             ),
                           )
                         ],
                       )
                     ],
                   ),
                 ),
               ),
             ],
           ) :
               Container()
          ],
        ),
      ),
    );
  }
}


