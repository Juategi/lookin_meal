import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'package:lookinmeal/models/reservation.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/loading.dart';

class ReservationsChecker extends StatefulWidget {
  @override
  _ReservationsCheckerState createState() => _ReservationsCheckerState();
}

class _ReservationsCheckerState extends State<ReservationsChecker> {
  Restaurant restaurant;
  DateTime dateSelected = DateTime.now();
  String dateString;
  bool loading = false;
  bool init = true;

  Future _getReservations() async{
    setState(() {
      loading = true;
    });
    if(restaurant.reservations == null)
      restaurant.reservations = {};
    dateString = dateSelected.toString().substring(0,10);
    restaurant.reservations[dateString] = await DBServiceReservation.dbServiceReservation.getReservationsDay(restaurant.restaurant_id, dateString);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    dateString = dateSelected.toString().substring(0,10);
    if(init){
      _getReservations();
      init = false;
    }
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: 32.h,),
            Center(child: Text("Check reservations", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(24),),))),
            SizedBox(height: 32.h,),
            CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 30)), onDateChanged: (date) async{
              dateSelected = date;
              await _getReservations();
            }, currentDate: dateSelected,),
            SizedBox(height: 5.h,),
            loading ? Loading() : IconButton(icon: Icon(Icons.refresh,  size: ScreenUtil().setSp(45), color: Color.fromRGBO(255, 110, 117, 0.7),), onPressed: (){
              _getReservations();
            }),
            SizedBox(height: 5.h,),
            Expanded(child: ListView(
              children: restaurant.reservations[dateString].map((reservation) => Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Container(
                  width: 395.w,
                  height: 50.h,
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
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        Container(width: 170.w, child: Text(reservation.username, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                        SizedBox(width: 10.w,),
                        Text("People: ${reservation.people}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                        SizedBox(width: 20.w,),
                        Text("Time: ${reservation.reservationtime}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ))
          ],
        ),
      ),
    );
  }
}
