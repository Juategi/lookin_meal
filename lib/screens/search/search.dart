import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/dish_query.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
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
  List<DishQuery> queries;
  DishQuery actual;
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
  void initState() {
    super.initState();
    queries = [];
    actual = DishQuery(allergens: []);
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
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.h,),
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
                    child: Padding(
                      padding:EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: queries.length < 3,
                              controller: TextEditingController()..text = actual.query..selection = TextSelection.fromPosition(TextPosition(offset: actual.query.length)),
                              onChanged: (val){
                                actual.query = val;
                                setState(() {
                                  error = "";
                                });
                              },

                              maxLines: 1,
                              maxLength: 20,
                              autofocus: false,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              decoration: InputDecoration(
                                  hintText: queries.length < 3? "   Restaurant or dish..." : "   Press search",
                                  hintStyle: TextStyle(color: Colors.black45),
                                  counterText: "",
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                          IconButton(icon: Icon(Icons.search), iconSize: ScreenUtil().setSp(30), onPressed: (){

                          },)
                        ],
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
                   Text(error, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.red, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                   SizedBox(width: 235.w,),
                   queries.length < 3 ?GestureDetector(
                     onTap: (){
                      if(actual.query != ""){
                        queries.add(actual);
                        setState(() {
                          actual = DishQuery(allergens: []);
                        });
                      }
                      else{
                        setState(() {
                          error = "Add a name";
                        });
                      }
                     },
                       child: Text("+ Add", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.9), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),))
                   ): Container()
                 ],
               ),
               SizedBox(height: 10.h,),
               Container(
                 height: 30.h,
                 child: ListView(
                   scrollDirection: Axis.horizontal,
                   children: queries.map((query) => Padding(
                     padding: EdgeInsets.symmetric(horizontal: 5.w),
                     child: Container(
                       height: 30.h,
                       decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.all(Radius.circular(12))
                       ),
                       child: Padding(
                         padding:  EdgeInsets.symmetric(horizontal: 5.w),
                         child: Row(
                           children: <Widget>[
                             Text(query.query, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black54, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                             Center(child: IconButton(icon: Icon(Icons.cancel), iconSize: ScreenUtil().setSp(18), color: Color.fromRGBO(255, 110, 117, 0.9), onPressed: (){
                               setState(() {
                                 queries.remove(query);
                               });
                             },))
                           ],
                         ),
                       ),
                     ),
                   )).toList(),
                 ),
               ),
               SizedBox(height: 10.h,),
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
                             rating: actual.rating,
                             color: Color.fromRGBO(250, 201, 53, 1),
                             borderColor: Color.fromRGBO(250, 201, 53, 1),
                             filledIconData: Icons.star,
                             halfFilledIconData: Icons.star_half,
                             size: ScreenUtil().setSp(45),
                           )
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
                           SizedBox(width: 240.w,),
                           Text("${actual.price.toStringAsFixed(1)}€", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                         ],
                       ),
                       SizedBox(height: 15.h,),
                       Row(mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           Container(
                             width: 330.w,
                             height: 50.h,
                             child: Slider(
                               value: actual.price,
                               divisions: 100,
                               max: 50,
                               min: 0,
                               activeColor: Color.fromRGBO(255, 110, 117, 0.9),
                               inactiveColor: Color.fromRGBO(255, 110, 117, 0.2),
                               label: actual.price.toStringAsFixed(1) + "€",
                               onChanged: (val){
                                 setState(() {
                                   actual.price = val;
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
               SizedBox(height: 20.h,),
               Container(
                 width: 388.w,
                 height: 201.h,
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
                           Text("Allergens", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black54, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                         ],
                       ),
                       SizedBox(height: 15.h,),
                       Container(
                         height: 120.h,
                         child: Wrap(
                           //crossAxisCount: 8,
                           spacing: 2,
                           runSpacing: 5,
                           crossAxisAlignment: WrapCrossAlignment.center,
                           children: CommonData.allergens.map((allergen) => Column(
                             children: <Widget>[
                               GestureDetector(
                                 child: Container(
                                     height: 47.h,
                                     width: 47.w,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: Image.asset("assets/allergens/${allergen}.png").image, colorFilter: actual.allergens.contains(allergen)? null : ColorFilter.linearToSrgbGamma()))
                                 ),
                                 onTap: (){
                                   setState(() {
                                     if(actual.allergens.contains(allergen))
                                       actual.allergens.remove(allergen);
                                     else
                                       actual.allergens.add(allergen);
                                   });
                                 },
                               ),
                               Text("${allergen[0].toUpperCase()}${allergen.substring(1)}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black54, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(8),),)),
                             ],
                           ),).toList(),
                         ),
                       ),
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


