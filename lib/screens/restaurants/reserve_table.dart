import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'package:lookinmeal/models/notification.dart';
import 'package:lookinmeal/models/owner.dart';
import 'package:lookinmeal/models/reservation.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/table.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/push_notifications.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/loading.dart';

class TableReservation extends StatefulWidget {
  @override
  _TableReservationState createState() => _TableReservationState();
}

class _TableReservationState extends State<TableReservation> {
  Restaurant restaurant;
  int pos = 0;
  int people = 1;
  int minTimeDif = 10;
  int hour;
  DateTime dateSelected;
  Map<int, String> available;
  bool init = true;
  bool loading = false;
  bool noSchedule = true;

  Future getExcluded() async{
    restaurant.excludeddays = await DBServiceReservation.dbServiceReservation.getExcluded(restaurant.restaurant_id);
    setState(() {
    });
  }

  Future _calculateAvailable() async{
    List<Reservation> reservations;
    int weekday = dateSelected.weekday == 7? 0 : dateSelected.weekday;
    if(!restaurant.schedule[weekday.toString()].every((element) => element == "-1")){
      reservations = await DBServiceReservation.dbServiceReservation.getReservationsDay(restaurant.restaurant_id, dateSelected.toString().substring(0,10));
      List<String> schedule = restaurant.schedule[weekday.toString()];
      List<int> checkHours = [];
      int mealtime = (double.parse(restaurant.mealtime.toString().replaceAll("5", "3"))*100).toInt();
      int start1 = int.parse(schedule[0].replaceAll("[", ""));
      int limit1 = int.parse(schedule[1]) - mealtime;
      while(start1 <= limit1){
        checkHours.add(start1);
        if(start1.toString().substring(2) == "00"){
          start1 += 30;
        }
        else{
          start1 += 70;
        }
      }
      if(schedule[2] != "-1"){
        int start2 = int.parse(schedule[2]);
        int limit2 = int.parse(schedule[3].replaceAll("]", "")) - mealtime;
        while(start2 <= limit2){
          checkHours.add(start2);
          if(start2.toString().substring(2) == "00"){
            start2 += 30;
          }
          else{
            start2 += 70;
          }
        }
      }
      List<RestaurantTable> compatibleTables = restaurant.tables.where((table) => table.capmin <= people && table.capmax >= people).toList();
      List<Reservation> compatibleReservations = reservations.where((reservation) => compatibleTables.firstWhere((table) => reservation.table_id == table.table_id, orElse: () => null) != null).toList();
      available = {};
      for(int hour in checkHours){
        Map<String, int> counter = {};
        for(RestaurantTable table in compatibleTables){
          counter[table.table_id] = table.amount;
        }
        for(Reservation reservation in compatibleReservations){
          if(!(int.parse(reservation.reservationtime.replaceAll(":", "")) >= hour + mealtime || int.parse(reservation.reservationtime.replaceAll(":", "")) + mealtime <= hour)){
            print("descarted");
            print(hour);
            counter[reservation.table_id] --;
          }
        }
        int max = -1;
        String finalTable = "";
        for(String table_id in counter.keys){
          if(counter[table_id] > 0){
            int dif = compatibleTables.firstWhere((table) => table.table_id == table_id).capmax - people;
            if(dif > max){
              max = dif;
              finalTable = table_id;
            }
          }
        }
        if(finalTable != ""){
          String h = DateTime.now().hour.toString().length == 1? "0" + DateTime.now().hour.toString() : DateTime.now().hour.toString();
          String m = DateTime.now().minute.toString().length == 1? "0" + DateTime.now().minute.toString() : DateTime.now().minute.toString();
          if(int.parse(h+m) + minTimeDif < hour){
            available[hour] = finalTable;
          }
        }
      }
      for(int hour in available.keys){
        //print("available");
        //print(hour);
      }
    }
    else{
      available = {};
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    AppLocalizations tr = AppLocalizations.of(context);
    restaurant = ModalRoute.of(context).settings.arguments;
    getExcluded();
    if(restaurant.excludeddays == null)
      return Loading();
    if(init){
      for(int i = 0; i <= 6; i++){
        if(!restaurant.schedule[i.toString()].every((element) => element.replaceAll("[", "").replaceAll("]", "")  == "-1")){
          noSchedule = false;
        }
      }
      dateSelected = DateTime.now();
      bool flag = true;
      while(flag) {
        int weekday = dateSelected.weekday == 7 ? 0 : dateSelected.weekday;
        if (restaurant.schedule[weekday.toString()].every((element) =>
        element.replaceAll("[", "").replaceAll("]", "") == "-1")) {
          bool loop = true;
          int day = weekday;
          int check = 0;
          day = (weekday + 1) == 7 ? 0 : (weekday + 1);
          while (loop) {
            day = (day + 1) == 7 ? 0 : (day + 1);
            if (!restaurant.schedule[day.toString()].every((element) =>
            element.replaceAll("[", "").replaceAll("]", "") == "-1")) {
              dateSelected = dateSelected.add(Duration(
                  days: weekday < day ? day - weekday : 7 - (weekday - day)));
              loop = false;
            }
            check += day;
            if (check >= 21)
              loop = false;
          }
        }
        if(!restaurant.excludeddays.contains(dateSelected.toString().substring(0,10)))
          flag = false;
        else
          dateSelected = dateSelected.add(Duration(days: 1));
      }
      init = false;
    }
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
            height: 146.h,
            width: 400.w,
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
                    GestureDetector(onTap: (){
                      setState(() {
                        pos = 0;
                      });
                    }, child: Icon(FontAwesomeIcons.calendarAlt, color: pos == 0? Color.fromRGBO(255, 110, 117, 0.6) : Colors.black87, size: ScreenUtil().setSp(28),)),
                    SizedBox(width: 25.w,),
                    Container(height: 10.h, width: 10.w, decoration: BoxDecoration(color: Color.fromRGBO(255, 110, 117, 0.6), shape: BoxShape.circle),),
                    SizedBox(width: 25.w,),
                    GestureDetector(onTap: (){
                      setState(() {
                        pos = 1;
                      });
                    }, child: Icon(Icons.people, color:  pos == 1? Color.fromRGBO(255, 110, 117, 0.6) : Colors.black87, size: ScreenUtil().setSp(33),)),
                    SizedBox(width: 25.w,),
                    Container(height: 10.h, width: 10.w, decoration: BoxDecoration(color: Color.fromRGBO(255, 110, 117, 0.6), shape: BoxShape.circle),),
                    SizedBox(width: 25.w,),
                    GestureDetector(onTap: (){
                      _calculateAvailable();
                      setState(() {
                        pos = 2;
                      });
                    }, child: Icon(Icons.access_time_outlined, color:  pos == 2? Color.fromRGBO(255, 110, 117, 0.6) : Colors.black87, size: ScreenUtil().setSp(33),)),
                    SizedBox(width: 25.w,),
                    Container(height: 10.h, width: 10.w, decoration: BoxDecoration(color: Color.fromRGBO(255, 110, 117, 0.6), shape: BoxShape.circle),),
                    SizedBox(width: 25.w,),
                    GestureDetector(onTap: (){
                      setState(() {
                        pos = 3;
                      });
                    }, child: Icon(Icons.check, color:  pos == 3? Color.fromRGBO(255, 110, 117, 0.6) : Colors.black87, size: ScreenUtil().setSp(33),)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            Center(child: Text(
              pos == 0? tr.translate("day") :
              pos == 1? tr.translate("numberpeople") :
              pos == 2? tr.translate("hour") : tr.translate("confirm")
            , maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(24),),))),
            SizedBox(height: 10.h,),
            pos != 0 || noSchedule ? Container() : CalendarDatePicker(initialDate: dateSelected, firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 30)), onDateChanged: (date) async{
              dateSelected = date;
              setState(() {
                pos = 1;
              });
            }, currentDate: dateSelected,
            selectableDayPredicate: (day){
              int weekday = day.weekday == 7? 0 : day.weekday;
              if(restaurant.schedule[weekday.toString()].every((element) => element.replaceAll("[", "").replaceAll("]", "").replaceAll("[", "").replaceAll("]", "") == "-1")){
                return false;
              }
              if(restaurant.excludeddays.contains(day.toString().substring(0,10))) {
                return false;
              }
              return true;
            },
            ),
            pos != 1 ? Container() : DropdownButton(items: List<int>.generate(50, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child:
            Text(n.toString(), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
            )).toList(), onChanged: (s){
              setState(() {
                _calculateAvailable();
                people = s;
                pos = 2;
              });
            },  value: people,),
            /*pos != 2 ? Container() :GestureDetector(
              onTap:(){
                DBServiceReservation.dbServiceReservation.createReservation(Reservation(
                    username: DBServiceUser.userF.name,
                    user_id: DBServiceUser.userF.uid,
                    people: 3,
                    restaurant_id: 833.toString(),
                    reservationdate: "2021-01-27",
                    reservationtime: "12:00",
                    table_id: 4.toString()
                ));
              },
              child: Container(
                width: 365.w,
                height: 60.h,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20.w,),
                    SvgPicture.asset("assets/propietario.svg", width: 37.w, height: 37.h,),
                  ],
                ),
              ),
            ),*/
            pos != 2 ? Container() : available == null? Loading() : available.keys.length == 0? Center(child: Text(tr.translate("nohours"), maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.redAccent, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(21),),))) :  Expanded(
              child: GridView.count(crossAxisCount: 4, padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                children: (available.keys).map((hour) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 32.h),
                  child: GestureDetector(
                    onTap: (){
                      this.hour = hour;
                      setState(() {
                        pos = 3;
                      });
                    },
                    child: Container(
                      width: 60.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 110, 117, 0.6),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Center(child: Text(hour.toString().substring(0,2) + ":" + hour.toString().substring(2), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18),),)))
                    ),
                  ),
                )).toList(),
              ),
            ),
            SizedBox(height: 20.h,),
            pos != 3 ? Container() : Column(
              children: [
                Container(
                  width: 170.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 110, 117, 0.7),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 35.h,),
                      Text(Functions.formatDate(dateSelected.toString().substring(0,10)), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(22),),)),
                      SizedBox(height: 20.h,),
                      Text(hour.toString().substring(0,2) + ":" + hour.toString().substring(2), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(22),),)),
                      SizedBox(height: 20.h,),
                      Text(people.toString() + " ${tr.translate("people").toLowerCase()}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(22),),)),
                      SizedBox(height: 20.h,),
                    ],
                  ),
                ),
                SizedBox(height: 40.h,),
                loading? Loading() : Container(
                  width: 200.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    //border: Border.all(color: Colors.black45)
                  ),
                  child: IconButton(icon: Icon(FontAwesomeIcons.check, size: ScreenUtil().setSp(60), color: Colors.green,), onPressed: ()async{
                    setState(() {
                      loading = true;
                    });
                    await _calculateAvailable();
                    if(available.keys.contains(hour)){
                      await DBServiceReservation.dbServiceReservation.createReservation(Reservation(
                        table_id: available[hour],
                        reservationtime: hour.toString().substring(0,2) + ":" + hour.toString().substring(2),
                        reservationdate: dateSelected.toString().substring(0,10),
                        restaurant_id: restaurant.restaurant_id,
                        people: people,
                        user_id: DBServiceUser.userF.uid,
                        username: DBServiceUser.userF.name
                      ));
                      Alerts.toast(tr.translate("reserved"));
                      for(Owner owner in await DBServiceUser.dbServiceUser.getOwners(restaurant.restaurant_id)){
                        DBServiceUser.dbServiceUser.addNotification(PersonalNotification(
                            restaurant_name: restaurant.name,
                            restaurant_id: restaurant.restaurant_id,
                            user_id: owner.user_id,
                            type: "Reserv",
                            body: "${tr.translate("msg4")}: ${dateSelected.toString().substring(0,10)}"
                        ));
                        PushNotificationService.sendNotification(tr.translate("reservations"), "${tr.translate("ondate")}: ${dateSelected.toString().substring(0,10)}", restaurant.restaurant_id, "reservation", owner.token);
                      }
                      Navigator.pop(context);
                    }
                    else{
                      pos = 1;
                      Alerts.dialog(tr.translate("reservationerror"), context);
                    }
                    setState(() {
                      loading = false;
                    });
                  },),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
