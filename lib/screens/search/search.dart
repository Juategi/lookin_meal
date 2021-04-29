import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/dish_query.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/screens/search/searchTiles.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Map<MenuEntry, Restaurant> map;
  AppLocalizations tr;
  bool isRestaurant = true;
  bool isSearching = false;
  bool searching = false;
  bool searchingMore = false;
  String searchType = 'Sort by relevance';
  String locality;
  List<DishQuery> queries;
  List<String> types = [];
  DishQuery actual;
  String error = "";
  String query = "";
  double maxDistance = 5.0;
  int offset = 0;
  List<Restaurant> result, sponsored;
  Map<Restaurant, List<String>> resultEntry;

  Future _search() async{
    if(isRestaurant) {
      result = await SearchService().query(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude, maxDistance, offset, types, query, searchType);
      sponsored = await DBServiceRestaurant.dbServiceRestaurant.getSponsored(1);
    }
    else{
      if(actual.query != ""){
        queries.add(actual);
      }
      resultEntry = await SearchService().queryEntry(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude, searchType, queries);
    }
  }

  Future _searchMore() async{
    offset += 10;
    result += await SearchService().query(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude, maxDistance, offset, types, query, searchType);
  }

  Widget _buildList(){
    if(isRestaurant) {
      List<Widget> buildList = sponsored.map((restaurant) =>
          Container(
            child: Provider.value(value: true,
              child: Provider.value(value: restaurant, child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h),
                child: SearchRestaurantTile(),
              )),
            ),
          )
      ).toList() + result.map((restaurant) =>
          Container(
            child: Provider.value(value: false,
              child: Provider.value(value: restaurant, child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h),
                child: SearchRestaurantTile(),
              )),
            ),
          )
      ).toList();
      if(offset < 20)
        buildList.add(searchingMore? Container(child: CircularLoading()) : Container(
          child: GestureDetector(
            onTap: ()async{
              setState(() {
                searchingMore = true;
              });
              await _searchMore();
              setState(() {
                searchingMore = false;
              });
            },
            child: Container(
              height: 50.h,
              width: 50.w,
              color: Color.fromRGBO(255, 110, 117, 0.9),
              child: Center(child: Text(tr.translate("showmore"), maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white,
                    letterSpacing: .3,
                    fontWeight: FontWeight.normal,
                    fontSize: ScreenUtil().setSp(22),),))),

            ),
          ),
        ));
      return ListView(children: buildList);
    }
    else {
      return ListView(
        children: resultEntry.keys.map((restaurant) => Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h),
          child: Container(
            height: (186*queries.length).h,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.7),
            ),
            child: Column(
              children: [
                GestureDetector(
                      onTap:(){
                        print(restaurant.types);
                        pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: "/restaurant", arguments: restaurant),
                          screen: ProfileRestaurant(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.slideUp,
                        ).then((value) => setState(() {}));
                        //Navigator.pushNamed(context, "/restaurant",arguments: restaurant).then((value) => setState(() {}));
                      },
                    child: Text(restaurant.name, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))
                ),
                Column(children: restaurant.menu.where((entry) => resultEntry[restaurant].contains(entry.id)).map((entry) =>
                    Provider.value(value: restaurant, child: Provider.value(value: entry,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                        child: SearchEntryTile(),
                      ),
                    ))
                ).toList()),
              ],
            ),
          ),
        )).toList(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    queries = [];
    actual = DishQuery(allergens: []);
  }

  @override
  Widget build(BuildContext context) {
    tr = AppLocalizations.of(context);
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CommonData.backgroundColor,
          elevation: 0,
          toolbarHeight: 107.h,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 15.h, right: 10.w, left: 10.w),
            child: Column(
              children: [
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
                                child: !isRestaurant? TextField(
                                  enabled: queries.length < 3,
                                  controller: TextEditingController()..text = actual.query..selection = TextSelection.fromPosition(TextPosition(offset: actual.query.length)),
                                  onChanged: (val){
                                    actual.query = val.trim();
                                    setState(() {
                                      error = "";
                                    });
                                  },
                                  onTap: (){
                                    if(isSearching){
                                      setState(() {
                                        isSearching = false;
                                        offset = 0;
                                      });
                                    }
                                  },
                                  maxLines: 1,
                                  maxLength: 20,
                                  autofocus: false,
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: queries.length < 3? tr.translate("resordish") : tr.translate("presssearch"),
                                      hintStyle: TextStyle(color: Colors.black45),
                                      counterText: "",
                                      border: InputBorder.none
                                  ),
                                ):
                                TextField(
                                  controller: TextEditingController()..text = query..selection = TextSelection.fromPosition(TextPosition(offset: query.length)),
                                  onChanged: (val){
                                    query = val;
                                    setState(() {
                                      error = "";
                                    });
                                  },
                                  onTap: (){
                                    if(isSearching){
                                      setState(() {
                                        isSearching = false;
                                        offset = 0;
                                      });
                                    }
                                  },
                                  maxLines: 1,
                                  maxLength: 35,
                                  autofocus: false,
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: tr.translate("presssearch"),
                                      hintStyle: TextStyle(color: Colors.black45),
                                      counterText: "",
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              IconButton(icon: Icon(Icons.search), iconSize: ScreenUtil().setSp(30), onPressed: ()async{
                                //EN BUSQUEDA UNICA NO GUARDAR EL DISHQUERY
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                setState(() {
                                  isSearching = true;
                                  searching = true;
                                });
                                await _search();
                                setState(() {
                                  searching = false;
                                });
                              },)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h,),
                Row( mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 250.w,
                      height: 27.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: searchType,
                            style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 65, 112, 0.6), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),)),
                            items: isRestaurant?  <String>[ tr.translate("sortrelevance"), tr.translate("sortdistance")].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 65, 112, 0.6), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                              );
                            }).toList() : <String>[tr.translate("sortrelevance"), tr.translate("sortprice"), tr.translate("sortdistance")].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 65, 112, 0.6), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                              );
                            }).toList(),
                            onChanged: (val) async{
                              if(isSearching){
                                setState(() {
                                  searchType = val;
                                  isSearching = true;
                                  searching = true;
                                });
                                await _search();
                                setState(() {
                                  searching = false;
                                });
                              }
                              else{
                                setState(() {
                                  searchType = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        //backgroundColor: CommonData.backgroundColor,
        body: searching? CircularLoading()  : Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: isSearching? _buildList() :  SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.h,),
                !isRestaurant? Row( mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(width: 235.w,),
                    queries.length < 3 ?GestureDetector(
                        onTap: (){
                          if(actual.query != ""){
                            queries.add(actual);
                            setState(() {
                              actual = DishQuery(allergens: [], rating: 0);
                            });
                          }
                          else{
                            setState(() {
                              error = tr.translate("addname");
                            });
                          }
                        },
                        child: Text(tr.translate("+add"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.9), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),))
                    ): Container()
                  ],
                ) : Container(height: 20.h,),
                SizedBox(height: 10.h,),
                Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isRestaurant = true;
                          searchType = tr.translate("sortrelevance");
                        });
                      },
                      child: Container(
                        width: 110.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                            color: isRestaurant? Color.fromRGBO(255, 110, 117, 0.9) : Color.fromRGBO(255, 110, 117, 0.3)  ,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        child: Center(child: Text(tr.translate("restaurants").toUpperCase(), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isRestaurant = false;
                          searchType = tr.translate("sortrelevance");
                        });
                      },
                      child: Container(
                        width: 110.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                            color: !isRestaurant? Color.fromRGBO(255, 110, 117, 0.9) : Color.fromRGBO(255, 110, 117, 0.3)  ,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        child: Center(child: Text(tr.translate("dishes").toUpperCase(), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                      ),
                    ),
                  ],
                ),
               !isRestaurant? Column(
                 children: <Widget>[
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
                       Text(tr.translate("filters"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
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
                               Text(tr.translate("stars"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                             ],
                           ),
                           SizedBox(height: 15.h,),
                           Row(mainAxisAlignment: MainAxisAlignment.start,
                             children: <Widget>[
                               /*SmoothStarRating(
                                 allowHalfRating: true,
                                 rating: actual.rating,
                                 color: Color.fromRGBO(250, 201, 53, 1),
                                 borderColor: Color.fromRGBO(250, 201, 53, 1),
                                 filledIconData: Icons.star,
                                 halfFilledIconData: Icons.star_half,
                                 size: ScreenUtil().setSp(45),
                                 onRated: (rate){
                                   setState(() {
                                     actual.rating = rate;
                                   });
                                 },
                               )*/
                               RatingBar.builder(
                               initialRating: actual.rating,
                               minRating: 1,
                               direction: Axis.horizontal,
                               allowHalfRating: true,
                               itemCount: 5,
                               itemSize: ScreenUtil().setSp(45),
                               itemPadding: EdgeInsets.symmetric(horizontal: 2.0.w),
                               itemBuilder: (context, _) => Icon(
                                 Icons.star,
                                 color: Color.fromRGBO(250, 201, 53, 1),
                                 size: ScreenUtil().setSp(45),
                               ),
                               onRatingUpdate: (rate){
                                 setState(() {
                                   actual.rating = rate;
                                 });
                               },
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
                               Text(tr.translate("price"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
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
                     height: 243.h,
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
                               Text(tr.translate("allergens"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                             ],
                           ),
                           SizedBox(height: 15.h,),
                           Container(
                             height: 190.h,
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
               Column(
                 children: [
                   SizedBox(height: 51.h,),
                   Row(mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       Text(tr.translate("filters"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
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
                               Text(tr.translate("maxdistance"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                               SizedBox(width: 100.w,),
                               Text("${maxDistance.toStringAsFixed(1)} km", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                             ],
                           ),
                           SizedBox(height: 15.h,),
                           Row(mainAxisAlignment: MainAxisAlignment.start,
                             children: <Widget>[
                               Container(
                                 width: 330.w,
                                 height: 50.h,
                                 child: Slider(
                                   value: maxDistance,
                                   divisions: 20,
                                   max: 10,
                                   min: 0,
                                   activeColor: Color.fromRGBO(255, 110, 117, 0.9),
                                   inactiveColor: Color.fromRGBO(255, 110, 117, 0.2),
                                   label: maxDistance.toStringAsFixed(1),
                                   onChanged: (val){
                                     setState(() {
                                       maxDistance = val;
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
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.all(Radius.circular(12))
                     ),
                     child: Padding(
                       padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                       child: Column(
                         children: [
                           Row(mainAxisAlignment: MainAxisAlignment.start,
                             children: <Widget>[
                               Text(tr.translate("types"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                               SizedBox(width: 240.w,),
                               GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     types.clear();
                                   });
                                 },
                                 //child: Icon(Icons.cancel_outlined, size: ScreenUtil().setSp(24), color: Colors.black,),
                                 child: Text(tr.translate("clear"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.9), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                               )
                             ],
                           ),
                           SizedBox(height: 40.h,),
                           Container(
                             height: 250.h,
                             child: GridView.count(
                               crossAxisCount: 3,
                               crossAxisSpacing: 3,
                               mainAxisSpacing: 0.5,
                               scrollDirection: Axis.vertical,
                               children: CommonData.typesList.map((type) =>
                                   GestureDetector(
                                     onTap: (){
                                       setState(() {
                                         if(types.contains(type))
                                           types.remove(type);
                                         else
                                          types.add(type);
                                       });
                                     },
                                     child: Text(type, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: types.contains(type)? Color.fromRGBO(255, 110, 117, 0.9) : Colors.black38, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                                   )
                               ).toList(),
                             ),
                           )
                         ],
                       ),
                     ),
                   )
                 ],
               )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


