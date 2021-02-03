import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/order.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/realtime_orders.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/services/pool.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Restaurant restaurant;
  String restaurant_id, table_id;
  bool init = true;
  double bill = 0.0;
  List<Order> items = [];

  Future getRestaurant() async{
    List aux = await DBServiceRestaurant.dbServiceRestaurant.getRestaurantsById([restaurant_id], GeolocationService.myPos.latitude, GeolocationService.myPos.longitude);
    restaurant = aux.first;
    RealTimeOrders().getOrder(restaurant_id, table_id).listen((event) {
      items = event;
      print("change!");
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    String code = ModalRoute.of(context).settings.arguments;
    if(init){
      restaurant_id = code.split("/").first;
      table_id = code.split("/").last;
      restaurant = Pool.getRestaurant(restaurant_id);
      DBServiceUser.userF.inOrder = true;
      if(restaurant == null)
        getRestaurant();
      init = false;
    }
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            Row(
              children: [
                Container(
                  width: 100.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),],),
                  child: Center(child: Text("Exit", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(12),),))),
                ),
                SizedBox(width: 40.w,),
                Text("Total cost: ", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(20),),)),
                SizedBox(width: 10.w,),
                Container(
                  width: 90.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 110, 117, 0.9),
                      borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  child: Align( alignment: Alignment.center, child: Text("${bill} ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
                ),
              ],
            ),
            Expanded(child: ListView(
              children: items.map((order) => Text(order.entry_id)).toList(),
            ))
          ],
        ),
      ),
    );
  }
}
