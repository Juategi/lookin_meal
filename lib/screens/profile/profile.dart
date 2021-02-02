import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/order.dart';
import 'package:lookinmeal/models/reservation.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookinmeal/services/realtime_orders.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/shared/common_data.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  User user;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    user = Provider.of<User>(context);
    AppLocalizations tr = AppLocalizations.of(context);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.h,),
          Container(
            height: 110.h,
            width: 255.w,
            child: Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 67.h, width: 67.w,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(1, 1), // changes position of shadow
                        ),],
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(
                                user.picture)
                        )
                    )
                ),
                SizedBox(width: 50.w,),
                Column(
                  children: [
                    SizedBox(height: 20.h,),
                    Text("${user.username}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.9), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                    Text("${user.ratings.length} Ratings", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(1, 1), // changes position of shadow
              ),],
            ),
          ),
          SizedBox(height: 25.h,),
          Container(
            height: 520.h,
            width: 365.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(1, 1), // changes position of shadow
              ),],
            ),
            child: Column(children: [
              GestureDetector(
                onTap:(){

                },
                child: Container(
                  width: 365.w,
                  height: 60.h,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20.w,),
                      SvgPicture.asset("assets/editusers.svg", width: 37.w, height: 37.h,),
                      SizedBox(width: 30.w,),
                      Container(width: 250.w, child: Text("Edit user", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                      Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2,),
              GestureDetector(
                onTap:(){
                  Navigator.pushNamed(context, "/ratinghistory");
                },
                child: Container(
                  width: 365.w,
                  height: 60.h,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20.w,),
                      SvgPicture.asset("assets/ratings.svg", width: 37.w, height: 37.h,),
                      SizedBox(width: 30.w,),
                      Container(width: 250.w, child: Text("Rating history", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                      Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2,),
              GestureDetector(
                onTap:(){
                  Navigator.pushNamed(context, "/favs");
                },
                child: Container(
                  width: 365.w,
                  height: 60.h,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20.w,),
                      Container(width: 37.w, height: 37.h, child: Icon(Icons.favorite_outline_sharp, size: ScreenUtil().setSp(35),)),
                      SizedBox(width: 30.w,),
                      Container(width: 250.w, child: Text("Favorites", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                      Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2,),
              GestureDetector(
                onTap:(){
                  Navigator.pushNamed(context, "/userreservations");
                },
                child: Container(
                  width: 365.w,
                  height: 60.h,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20.w,),
                      Container(width: 37.w, height: 37.h, child: Icon(Icons.calendar_today_outlined, size: ScreenUtil().setSp(35),)),
                      SizedBox(width: 30.w,),
                      Container(width: 250.w, child: Text("Reservations", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                      Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2,),
              GestureDetector(
                onTap:(){

                },
                child: Container(
                  width: 365.w,
                  height: 60.h,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20.w,),
                      SvgPicture.asset("assets/propietario.svg", width: 37.w, height: 37.h,),
                      SizedBox(width: 30.w,),
                      Container(width: 250.w, child: Text("Are you a propietary?", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                      Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2,),
              GestureDetector(
                onTap:()async{
                  RealTimeOrders r = RealTimeOrders();
                  //print(await r.updateOrderData("833", "1", "18", "7sBBcSpcN3nUfiBfLxNI", 4, false));
                 List<Order> o = await r.getOrder("833", "1").first;

                },
                child: Container(
                  width: 365.w,
                  height: 60.h,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20.w,),
                      SvgPicture.asset("assets/points.svg", width: 37.w, height: 37.h,),
                      SizedBox(width: 30.w,),
                      Container(width: 250.w, child: Text("Points Program", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                      Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2,),
              GestureDetector(
                onTap:(){
                  _auth.signOut();
                },
                child: Container(
                  width: 365.w,
                  height: 60.h,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20.w,),
                      Container(width: 37.w, height: 37.h, child: Icon(Icons.logout, size: ScreenUtil().setSp(35),)),
                      SizedBox(width: 30.w,),
                      Container(width: 250.w, child: Text("Log out", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                      Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                    ],
                  ),
                ),
              ),
            ],),
          ),
        ],
      ),
    );
  }


}
