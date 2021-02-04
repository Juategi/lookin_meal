import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/order.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/realtime_orders.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/widgets.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Restaurant restaurant;
  String restaurant_id, table_id;
  bool init = true;
  List<Order> items = [];
  final RealTimeOrders controller = RealTimeOrders();

  Future getRestaurant() async{
    List aux = await DBServiceRestaurant.dbServiceRestaurant.getRestaurantsById([restaurant_id], GeolocationService.myPos.latitude, GeolocationService.myPos.longitude);
    restaurant = aux.first;
    setState(() {});
  }

  List<Widget> _loadOrder(){
    List<Widget> widgets = [];
      widgets.add(Container(
          height: 42.h,
          width: 411.w,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 110, 117, 0.9),
          ),
        child: Align( alignment: AlignmentDirectional.topCenter, child: Text("Sent", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
        )
      );
      widgets.add(Row( mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Amount", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18),),)),
        ],
      )
    );
    widgets.addAll(items.where((order) => order.send).map((order) {
      MenuEntry entry = restaurant.menu.firstWhere((element) => element.id == order.entry_id);
      return Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Card(
              elevation: 0.5,
              child: Container(
                width: 283.w,
                height: 65.h,
                child: Row(
                  children: <Widget>[
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Container(width: 185.w,
                              child: Text(entry.name, maxLines: 1,
                                  style: GoogleFonts.niramit(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                      letterSpacing: .3,
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(16),),))),
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 8.w,),
                            //SmoothStarRating(rating: entry.rating, spacing: -3, isReadOnly: true, allowHalfRating: true, color: Color.fromRGBO(250, 201, 53, 1), borderColor: Color.fromRGBO(250, 201, 53, 1), size: ScreenUtil().setSp(21),),
                            StarRating(color: Color.fromRGBO(250, 201, 53, 1),
                              rating: entry.rating,
                              size: ScreenUtil().setSp(12),),
                            SizedBox(width: 5.w,),
                            Text("${entry.numReviews} votes", maxLines: 1,
                                style: GoogleFonts.niramit(textStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.normal,
                                  fontSize: ScreenUtil().setSp(14),),)),
                            SizedBox(width: 13.w,),
                            entry.price == 0.0 ? Container(
                              width: 60.w, height: 22.h,) : Container(
                              width: 60.w,
                              height: 22.h,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 110, 117, 0.9),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))
                              ),
                              child: Text(
                                  "${entry.price} ${restaurant.currency}",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.niramit(
                                    textStyle: TextStyle(color: Colors.white,
                                      letterSpacing: .3,
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(16),),)),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 9.w,),
                    entry.image == null || entry.image == ""
                        ? Container(
                      height: 65.h,
                      width: 68.w,
                      //color: Colors.blue,
                    )
                        : Container(
                        height: 65.h,
                        width: 68.w,
                        decoration: entry.image == null || entry.image == ""
                            ? null
                            : BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 1)
                        ),
                        child: Image.network(entry.image, fit: BoxFit.cover,)
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 25.w,),
          Container(
            width: 30.w,
            child: Center(child: Text(order.amount.toString(), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
          ),
        ],
      );
    }
    ));
    widgets.add(Container(
      height: 42.h,
      width: 411.w,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 110, 117, 0.9),
      ),
      child: Align( alignment: AlignmentDirectional.topCenter, child: Text("Not sent", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
    )
    );
    widgets.add(Row( mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Amount", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18),),)),
      ],
    )
    );
    widgets.addAll(items.where((order) => !order.send).map((order) {
      MenuEntry entry = restaurant.menu.firstWhere((element) => element.id == order.entry_id);
      return Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Card(
              elevation: 0.5,
              child: Container(
                width: 283.w,
                height: 65.h,
                child: Row(
                  children: <Widget>[
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Container(width: 185.w,
                              child: Text(entry.name, maxLines: 1,
                                  style: GoogleFonts.niramit(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                      letterSpacing: .3,
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(16),),))),
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 8.w,),
                            //SmoothStarRating(rating: entry.rating, spacing: -3, isReadOnly: true, allowHalfRating: true, color: Color.fromRGBO(250, 201, 53, 1), borderColor: Color.fromRGBO(250, 201, 53, 1), size: ScreenUtil().setSp(21),),
                            StarRating(color: Color.fromRGBO(250, 201, 53, 1),
                              rating: entry.rating,
                              size: ScreenUtil().setSp(12),),
                            SizedBox(width: 5.w,),
                            Text("${entry.numReviews} votes", maxLines: 1,
                                style: GoogleFonts.niramit(textStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.normal,
                                  fontSize: ScreenUtil().setSp(14),),)),
                            SizedBox(width: 13.w,),
                            entry.price == 0.0 ? Container(
                              width: 60.w, height: 22.h,) : Container(
                              width: 60.w,
                              height: 22.h,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 110, 117, 0.9),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))
                              ),
                              child: Text(
                                  "${entry.price} ${restaurant.currency}",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.niramit(
                                    textStyle: TextStyle(color: Colors.white,
                                      letterSpacing: .3,
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(16),),)),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 9.w,),
                    entry.image == null || entry.image == ""
                        ? Container(
                      height: 65.h,
                      width: 68.w,
                      //color: Colors.blue,
                    )
                        : Container(
                        height: 65.h,
                        width: 68.w,
                        decoration: entry.image == null || entry.image == ""
                            ? null
                            : BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 1)
                        ),
                        child: Image.network(entry.image, fit: BoxFit.cover,)
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w,),
          DropdownButton(items: List<int>.generate(30, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child:
          Text(n.toString(), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(22),),)),
          )).toList(), onChanged: (s){
            setState(() {
              order.amount = s;
              controller.updateOrderData(restaurant_id, table_id, order);
            });
          }, value: order.amount,),
        ],
      );
    }
    ));
    return widgets;
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
    return StreamBuilder<List<Order>>(
      stream: controller.getOrder(restaurant_id, table_id),
      builder: (context, snapshot){
        items = snapshot.data;
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
                      child: Align( alignment: Alignment.center, child: Text("0 ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
                    ),
                  ],
                ),
                Expanded(child: ListView(
                  children: _loadOrder()
                ))
              ],
            ),
          ),
        );
      }
    );
  }
}
