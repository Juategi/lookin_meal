import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/profile/ratings_tile.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';

class UserReservations extends StatefulWidget {
  @override
  _UserReservationsState createState() => _UserReservationsState();
}

class _UserReservationsState extends State<UserReservations> {

  void _timer() {
    if(DBServiceUser.userF.reservations == null) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        setState(() {
          print("Loading..");
        });
        _timer();
      });
    }
  }
  
  Future _getReservations() async{
    DBServiceUser.userF.reservations = await DBServiceReservation.dbServiceReservation.getReservationsUser(DBServiceUser.userF.uid, DateTime.now().toString().substring(0,10));
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    _getReservations();
    _timer();
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 42.h,
              width: 411.w,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 110, 117, 0.9),
              ),
              child:Text("Reservations", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
            ),
            SizedBox(height: 10.h,),
            DBServiceUser.userF.reservations == null? Loading() : Expanded(child: ListView(
              children: DBServiceUser.userF.reservations.map((reservation) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.w),
                child: Container(
                  width: 380.w,
                  height: 100.h,
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
                    padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.w),
                    child: Row(
                      children: [
                        Container(
                          height: 100.h,
                          width: 160.w,
                          child: Text(reservation.resturant_name, maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(22),),)),
                        ),
                        SizedBox(width: 10.w,),
                        Column( crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("People: " + reservation.people.toString(), maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                            Text(Functions.formatDate(reservation.reservationdate.substring(0,10)) + " - " + reservation.reservationtime, maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                            Container(
                              height: 34.h,
                              width: 160.w,
                              child: IconButton(icon: Icon(Icons.delete,  size: ScreenUtil().setSp(33), color: Color.fromRGBO(255, 110, 117, 0.7),), onPressed: ()async{
                                if(await Alerts.confirmation("Remove reservation, are you sure?", context)){
                                  DBServiceUser.userF.reservations.remove(reservation);
                                  DBServiceReservation.dbServiceReservation.deleteReservation(reservation.table_id, reservation.reservationdate.substring(0,10), reservation.reservationtime);
                                  setState(() {
                                  });
                                }
                              }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )).toList()
            ))
          ],
        ),
      ),
    );
  }
}
