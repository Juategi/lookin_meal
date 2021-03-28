import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'package:lookinmeal/models/notification.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/push_notifications.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/loading.dart';

class ReservationsChecker extends StatefulWidget {
  @override
  _ReservationsCheckerState createState() => _ReservationsCheckerState();
}

class _ReservationsCheckerState extends State<ReservationsChecker> {
  Restaurant restaurant;
  DateTime dateSelected;
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
    restaurant.excludeddays = await DBServiceReservation.dbServiceReservation.getExcluded(restaurant.restaurant_id);
    print(restaurant.excludeddays);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    dateSelected = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    if(init){
      int weekday = dateSelected.weekday == 7? 0 : dateSelected.weekday;
      if(restaurant.schedule[weekday.toString()].every((element) => element.replaceAll("[", "").replaceAll("]", "") == "-1")){
        bool loop = true;
        int day = weekday;
        int check = 0;
        day = (weekday+1) == 7? 0 : (weekday+1);
        while(loop){
          day = (day+1) == 7? 0 : (day+1);
          if(!restaurant.schedule[day.toString()].every((element) => element.replaceAll("[", "").replaceAll("]", "") == "-1")){
            dateSelected = dateSelected.add(Duration(days: weekday < day ? day-weekday : 7 - (weekday - day)));
            loop = false;
          }
          check += day;
          if(check >= 21)
            loop = false;
        }
      }
      _getReservations();
      init = false;
    }
    dateString = dateSelected.toString().substring(0,10);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 32.h,),
              Center(child: Text("Check reservations", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(24),),))),
              SizedBox(height: 32.h,),
              CalendarDatePicker(initialDate: dateSelected, firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 30)), onDateChanged: (date) async{
                dateSelected = date;
                await _getReservations();
                setState(() {
                });
              }, currentDate: dateSelected,
                selectableDayPredicate: (day){
                  int weekday = day.weekday == 7? 0 : day.weekday;
                  if(restaurant.schedule[weekday.toString()].every((element) => element.replaceAll("[", "").replaceAll("]", "").replaceAll("[", "").replaceAll("]", "") == "-1")){
                    return false;
                  }
                  return true;
                },),
              SizedBox(height: 5.h,),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(value: restaurant.excludeddays.contains(dateString.substring(0,10)), onChanged: (val){
                    String date = dateString.substring(0,10);
                    print(date);
                    if(val){
                      restaurant.excludeddays.add(date);
                      DBServiceReservation.dbServiceReservation.addExcluded(date, restaurant.restaurant_id);
                    }
                    else{
                      restaurant.excludeddays.remove(date);
                      DBServiceReservation.dbServiceReservation.deleteExcluded(date, restaurant.restaurant_id);
                    }
                    setState(() {
                    });
                  }),
                  Text("Disable more reservations this day", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(15),),)),
                ],
              ),
              SizedBox(height: 5.h,),
              loading ? Loading() : IconButton(icon: Icon(Icons.refresh,  size: ScreenUtil().setSp(45), color: Color.fromRGBO(255, 110, 117, 0.7),), onPressed: (){
                _getReservations();
              }),
              SizedBox(height: 5.h,),
              loading ? Container() : Expanded(child: ListView(
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
                          Container(width: 140.w, child: Text(reservation.username, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                          SizedBox(width: 10.w,),
                          Text("People: ${reservation.people}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                          SizedBox(width: 10.w,),
                          Text("Time: ${reservation.reservationtime}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                          Container(
                            height: 40.h,
                            width: 40.w,
                            child: IconButton(icon: Icon(Icons.delete,  size: ScreenUtil().setSp(25), color: Color.fromRGBO(255, 110, 117, 0.7),), onPressed: ()async{
                              if(await Alerts.confirmation("Remove reservation, are you sure?", context)){
                                DBServiceReservation.dbServiceReservation.deleteReservation(reservation.table_id, DateTime.parse(reservation.reservationdate).add(Duration(days: 1)).toString().substring(0,10), reservation.reservationtime);
                                restaurant.reservations[dateString].remove(reservation);
                                DBServiceUser.dbServiceUser.addNotification(PersonalNotification(
                                  restaurant_name: restaurant.name,
                                  restaurant_id: restaurant.restaurant_id,
                                  user_id: reservation.user_id,
                                  type: "Reserv",
                                  body: "Reservation cancelled from restaurant " + restaurant.name
                                ));
                                User user = await DBServiceUser.dbServiceUser.getUserData(reservation.user_id);
                                PushNotificationService.sendNotification("Reservation cancelled", "On restaurant: ${restaurant.name}", restaurant.restaurant_id, "ReservCancel", user.token);
                                setState(() {
                                });
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
