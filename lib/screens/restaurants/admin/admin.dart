import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/admin/edit_codes.dart';
import 'package:lookinmeal/screens/restaurants/admin/edit_daily.dart';
import 'package:lookinmeal/screens/restaurants/admin/edit_menu.dart';
import 'package:lookinmeal/screens/restaurants/admin/edit_restaurant.dart';
import 'package:lookinmeal/screens/restaurants/admin/edit_tables.dart';
import 'package:lookinmeal/screens/restaurants/admin/manage_admins.dart';
import 'package:lookinmeal/screens/restaurants/admin/payments.dart';
import 'package:lookinmeal/screens/restaurants/admin/premium.dart';
import 'package:lookinmeal/screens/restaurants/admin/sponsor.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'edit_images.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
          child: ListView(
            children: [
              Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Administration", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(28),),)),
                ],
              ),
              SizedBox(height: 70.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.settings, size: ScreenUtil().setSp(32),),
                    SizedBox(width: 30.w,),
                    Text("Edit restaurant information", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap: ()async{
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: "/editrestaurant", arguments: restaurant),
                    screen: EditRestaurant(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                  //Navigator.pushNamed(context, "/editrestaurant",arguments: restaurant);
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Container(
                        height: 35.h,
                        width: 35.w,
                        child: SvgPicture.asset("assets/menu.svg")
                    ),
                    SizedBox(width: 30.w,),
                    Text("Edit menu", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap: ()async{
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: "/editmenu", arguments: restaurant),
                    screen: EditMenu(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                  //Navigator.pushNamed(context, "/editmenu",arguments: restaurant);
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Container(
                        height: 35.h,
                        width: 35.w,
                        child: SvgPicture.asset("assets/menu.svg", )
                    ),
                    SizedBox(width: 30.w,),
                    Text("Edit daily menu", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap: ()async{
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: "/editdaily", arguments: restaurant),
                    screen: EditDaily(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                  //Navigator.pushNamed(context, "/editdaily",arguments: restaurant);
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.image_outlined, size: ScreenUtil().setSp(32),),
                    SizedBox(width: 30.w,),
                    Text("Edit gallery", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap:()async{
                  showModalBottomSheet(context: context, isScrollControlled: true,  builder: (BuildContext bc){
                    return EditImages(restaurant: restaurant,);
                  }).then((value){setState(() {});});
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.calendarAlt, size: ScreenUtil().setSp(32),),
                    SizedBox(width: 30.w,),
                    Text("Edit tables and reservation", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap:()async{
                  if(restaurant.premiumtime == null)
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings( arguments: restaurant),
                      screen: Premium(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    );
                  else if(restaurant.premium || (!restaurant.premium && restaurant.premiumtime != null && Functions.compareDates(restaurant.premiumtime, DateTime.now().toString().substring(0,10)) <= 0)) {
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: "/edittables", arguments: restaurant),
                        screen: EditTables(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      );
                  }
                  else
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings( arguments: restaurant),
                      screen: Premium(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    );
                  //Navigator.pushNamed(context, "/edittables",arguments: restaurant);
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.qrcode, size: ScreenUtil().setSp(32),),
                    SizedBox(width: 30.w,),
                    Text("Edit order codes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap:()async{
                  if(restaurant.premiumtime == null)
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings( arguments: restaurant),
                      screen: Premium(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    );
                  else if(restaurant.premium || (!restaurant.premium && restaurant.premiumtime != null && Functions.compareDates(restaurant.premiumtime, DateTime.now().toString().substring(0,10)) <= 0)) {
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: "/editcodes", arguments: restaurant),
                        screen: EditCodes(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      );
                  }
                  else
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings( arguments: restaurant),
                      screen: Premium(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    );
                  //Navigator.pushNamed(context, "/editcodes",arguments: restaurant);
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.people, size: ScreenUtil().setSp(32),),
                    SizedBox(width: 30.w,),
                    Text("Manage admins", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap:()async{
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings( arguments: restaurant),
                    screen: ManageAdmins(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.verified_outlined, size: ScreenUtil().setSp(32),),
                    SizedBox(width: 30.w,),
                    Text("Premium", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap:()async{
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings( arguments: restaurant),
                    screen: Premium(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, size: ScreenUtil().setSp(32),),
                    SizedBox(width: 30.w,),
                    Text("Sponsor", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap:()async{
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings( arguments: restaurant),
                    screen: Sponsor(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.payment, size: ScreenUtil().setSp(32),),
                    SizedBox(width: 30.w,),
                    Text("Payments", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap:()async{
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings( arguments: restaurant),
                    screen: PaymentList(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                },
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.live_help_rounded, size: ScreenUtil().setSp(32),),
                    SizedBox(width: 30.w,),
                    Text("Download Manual", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)),
                  ],
                ),
                onTap:()async{
                  Alerts.toast("Descargando manual...");
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}

