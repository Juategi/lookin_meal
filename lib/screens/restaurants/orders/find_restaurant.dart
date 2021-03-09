import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class FindRestaurant extends StatefulWidget {
  @override
  _FindRestaurantState createState() => _FindRestaurantState();
}

class _FindRestaurantState extends State<FindRestaurant> {
  bool isSearching = false;
  String error = "";
  String query = "";
  List<Restaurant> results;

  Future _search() async{
    results = await SearchService().query(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude, 100000, 0, [], query, "Sort by relevance");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CommonData.backgroundColor,
          elevation: 0,
          toolbarHeight: 80.h,
          leading: Container(),
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 15.h, right: 10.w, left: 10.w),
            child: Row(
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
                                  hintText:"   Press search",
                                  hintStyle: TextStyle(color: Colors.black45),
                                  counterText: "",
                                  border: InputBorder.none
                              ),
                            )
                          ),
                          IconButton(icon: Icon(Icons.search), iconSize: ScreenUtil().setSp(30), onPressed: ()async{
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            setState(() {
                              isSearching = true;
                            });
                            await _search();
                            setState(() {
                              isSearching = false;
                            });
                          },)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: results == null? Container() : isSearching? Loading() : ListView(
          children: results.map((restaurant) =>
              GestureDetector(
                onTap: (){
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(arguments: restaurant),
                    screen: ConfirmationMenu(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  child: Container(
                    width: 390.w,
                    height: 220.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(1, 1), // changes position of shadow
                      ),],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 130.h,
                          width: 390.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: Image.network(
                                  restaurant.images.first).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h,),
                        Row( crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 5.w,),
                            Container(width: 214.w, child: Text(restaurant.name,  maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                            //SizedBox(width: 1.w,),
                            Column(
                              children: <Widget>[
                                SizedBox(height: 4.h,),
                                StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: Functions.getRating(restaurant), size: ScreenUtil().setSp(16),),
                              ],
                            ),
                            SizedBox(width: 10.w,),
                            Column(
                              children: <Widget>[
                                SizedBox(height: 2.h,),
                                Text("${Functions.getVotes(restaurant)} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 5.w,),
                            restaurant.types.length == 0 ? Container() : Container(
                                height: 15.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: Image.asset("assets/food/${CommonData.typesImage[restaurant.types[0]]}.png").image))
                            ),
                            SizedBox(width: 5.w,),
                            restaurant.types.length == 0? Container(width: 214.w) : Container(width: 214.w, child: Text(restaurant.types.length > 1 ? "${restaurant.types[0]}, ${restaurant.types[1]}" : "${restaurant.types[0]}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                            SizedBox(width: 55.w,),
                            Container(
                              child: SvgPicture.asset("assets/markerMini.svg", height: 25.h, width: 25.w,),
                            ),
                            //Icon(Icons.location_on, color: Colors.black, size: ScreenUtil().setSp(16),),
                            Text("${restaurant.distance.toString()} km", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ).toList(),
        ),
      ),
    );
  }
}

class ConfirmationMenu extends StatefulWidget {
  @override
  _ConfirmationMenuState createState() => _ConfirmationMenuState();
}

class _ConfirmationMenuState extends State<ConfirmationMenu> {
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h,),
          Text("Select confirmation method", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
          SizedBox(height: 80.h,),
          restaurant.email == null || restaurant.email == "" ? Container() : GestureDetector(
            onTap:(){

            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.email, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Confirmation by email", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                ],
              ),
            ),
          ),
          restaurant.email == null || restaurant.email == "" ? Container() : Container(width: 330.w, child: Text(restaurant.email, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
          restaurant.email == null || restaurant.email == "" ? Container() : SizedBox(height: 50.h,),
          restaurant.phone == null || restaurant.phone == "" ? Container() : GestureDetector(
            onTap:(){

            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.message_outlined, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Confirmation by SMS", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                ],
              ),
            ),
          ),
          restaurant.phone == null || restaurant.phone == "" ? Container() : Container(width: 330.w, child: Text(restaurant.phone, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
          restaurant.phone == null || restaurant.phone == "" ? Container() : SizedBox(height: 50.h,),
          GestureDetector(
            onTap:(){

            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.warning_sharp, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("There is no email or phone available or it is outdated", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}