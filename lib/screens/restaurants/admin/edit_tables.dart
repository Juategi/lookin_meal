import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/table.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';

class EditTables extends StatefulWidget {
  @override
  _EditTablesState createState() => _EditTablesState();
}

class _EditTablesState extends State<EditTables> {
  Restaurant restaurant;

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    _updateTables();
    return false;
  }

  void _timer() {
    if(restaurant.tables == null) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        setState(() {
          print("Loading..");
        });
        _timer();
      });
    }
  }

  Future _updateTables() async{
    for(RestaurantTable table in restaurant.tables){
      if(table.table_id == null){
        table.table_id = await DBServiceReservation.dbServiceReservation.createTable(table);
      }
      else if(table.edited){
        await DBServiceReservation.dbServiceReservation.updateTable(table);
        table.edited = false;
      }
    }
    await DBServiceRestaurant.dbServiceRestaurant.updateRestaurantMealTime(restaurant.restaurant_id, restaurant.mealtime);
  }

  Future _getTables() async{
    restaurant.tables = await DBServiceReservation.dbServiceReservation.getTables(restaurant.restaurant_id);
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() async{
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    if(restaurant.tables == null){
      _getTables();
      _timer();
    }
    if(restaurant.mealtime == null)
      restaurant.mealtime = 1;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 32.h,),
              Center(child: Text("Reservations configuration", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(24),),))),
              SizedBox(height: 32.h,),
              Row( mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Reservation time aprox:   ", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                  DropdownButton(items: <num>[0.5, 1.0, 1.5, 2.0, 2.5, 3.0].map((n) => DropdownMenuItem(value: n, child:
                  Text(n.toString() + "h", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                  )).toList(), onChanged: (s){
                    setState(() {
                      restaurant.mealtime = s;
                    });
                  },  value: restaurant.mealtime,),
                ],
              ),
              SizedBox(height: 20.h,),
              restaurant.tables == null ? Loading() : Container(
                height: 400.h,
                child: Expanded(
                    child: ListView(
                      children: restaurant.tables.map((table) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Container(
                          width: 395.w,
                          height: 107.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),],),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Row( mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Minimum capacity:   ", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                                        DropdownButton(items: List<int>.generate(50, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child:
                                        Text(n.toString() + " people", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14),),)),
                                        )).toList(), onChanged: (s){
                                          setState(() {
                                            table.capmin = s;
                                            table.edited = true;
                                          });
                                        },  value: table.capmin,),
                                      ],
                                    ),
                                    Row( mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Maximum capacity:   ", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                                        DropdownButton(items: List<int>.generate(50, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child:
                                        Text(n.toString() + " people", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14),),)),
                                        )).toList(), onChanged: (s){
                                          setState(() {
                                            table.capmax = s;
                                            table.edited = true;
                                          });
                                        },  value: table.capmax,),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 8.w,),
                                Column(
                                  children: [
                                    SizedBox(height: 15.h,),
                                    Text("Cuantity", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                                    DropdownButton(items: <num>[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15].map((n) => DropdownMenuItem(value: n, child:
                                    Text(n.toString(), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14),),)),
                                    )).toList(), onChanged: (s){
                                      setState(() {
                                        table.amount = s;
                                        table.edited = true;
                                      });
                                    },  value: table.amount,),
                                  ],
                                ),
                                SizedBox(width: 0.w,),
                                IconButton(icon: Icon(Icons.delete, size: ScreenUtil().setSp(28),), onPressed: (){
                                  setState(() {
                                    restaurant.tables.remove(table);
                                    DBServiceReservation.dbServiceReservation.deleteTable(table.table_id);
                                  });
                                })
                              ],
                            ),
                          ),
                        ),
                      )).toList(),
                    )
                ),
              ),
              SizedBox(height: 10.h,),
              restaurant.tables == null || restaurant.tables.length > 20 ? Container() : GestureDetector(
                onTap: () async{
                  setState(() {
                    restaurant.tables.add(RestaurantTable(
                        capmax: 1,
                        capmin: 1,
                        amount: 1,
                        edited: false,
                        restaurant_id: restaurant.restaurant_id,
                    ));
                  });
                },
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    //borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(1, 1), // changes position of shadow
                    ),],
                  ),
                  child: Icon(Icons.add, size: ScreenUtil().setSp(65),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
