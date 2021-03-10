import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/screens/restaurants/orders/find_restaurant.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class OwnerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h,),
          Text("Are you an owner?", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
          SizedBox(height: 80.h,),
          GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                //settings: RouteSettings(name: "/owner"),
                screen: RegisterRestaurantMenu(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.edit_location_rounded, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Register", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h,),
          GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                //settings: RouteSettings(name: "/owner"),
                screen: Owned(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  SvgPicture.asset("assets/propietario.svg", width: 37.w, height: 37.h,),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Your restaurants", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Owned extends StatefulWidget {
  @override
  _OwnedState createState() => _OwnedState();
}

class _OwnedState extends State<Owned> {

  Future loadOwned() async{
    DBServiceUser.userF.owned = await DBServiceRestaurant.dbServiceRestaurant.getOwned(DBServiceUser.userF.uid);
    setState(() {});
  }

  @override
  void initState() {
    loadOwned();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(DBServiceUser.userF.uid);
    return Scaffold(
      body: DBServiceUser.userF.owned == null? Loading() : Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        child: ListView(
          children: DBServiceUser.userF.owned.map((restaurant) =>
              GestureDetector(
                onTap: (){
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: "/restaurant", arguments: restaurant),
                    screen: ProfileRestaurant(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  ).then((value) => setState(() {}));
                },
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
              )
          ).toList(),
        ),
      ),
    );
  }
}

class RegisterRestaurantMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h,),
          Text("Register restaurant", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
          SizedBox(height: 80.h,),
          GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                //settings: RouteSettings(name: "/owner"),
                screen: FindRestaurant(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.find_in_page, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Does your restaurant already exist? Find it and take control", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(16),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h,),
          GestureDetector(
            onTap:(){

            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.create, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Create new", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
