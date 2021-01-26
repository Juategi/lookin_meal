import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/common_data.dart';

class TableReservation extends StatefulWidget {
  @override
  _TableReservationState createState() => _TableReservationState();
}

class _TableReservationState extends State<TableReservation> {
  Restaurant restaurant;
  int pos = 0;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Column(
        children: [
          Container(
          height: 230,
          width: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(restaurant.images.elementAt(0)),
              fit: BoxFit.cover,
             ),
            ),
          ),
          Container(
            height: 42.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.9),
            ),
            child: Row( mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Text(restaurant.name, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          Container(
            width: 370.w,
            height: 55.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                children: [
                  GestureDetector(onTap: (){}, child: Icon(FontAwesomeIcons.calendarAlt, color: Colors.black87, size: ScreenUtil().setSp(28),)),
                  SizedBox(width: 25.w,),
                  Container(height: 10.h, width: 10.w, decoration: BoxDecoration(color: Color.fromRGBO(255, 110, 117, 0.6), shape: BoxShape.circle),),
                  SizedBox(width: 25.w,),
                  GestureDetector(onTap: (){}, child: Icon(Icons.people, color: Colors.black87, size: ScreenUtil().setSp(33),)),
                  SizedBox(width: 25.w,),
                  Container(height: 10.h, width: 10.w, decoration: BoxDecoration(color: Color.fromRGBO(255, 110, 117, 0.6), shape: BoxShape.circle),),
                  SizedBox(width: 25.w,),
                  GestureDetector(onTap: (){}, child: Icon(Icons.access_time_outlined, color: Colors.black87, size: ScreenUtil().setSp(33),)),
                  SizedBox(width: 25.w,),
                  Container(height: 10.h, width: 10.w, decoration: BoxDecoration(color: Color.fromRGBO(255, 110, 117, 0.6), shape: BoxShape.circle),),
                  SizedBox(width: 25.w,),
                  GestureDetector(onTap: (){}, child: Icon(Icons.check, color: Colors.black87, size: ScreenUtil().setSp(33),)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
