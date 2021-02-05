import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/order.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/realtime_orders.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';


class ManageOrders extends StatefulWidget {
  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  Restaurant restaurant;
  final RealTimeOrders controller = RealTimeOrders();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Column(
        children: [
          Text("Orders online", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
          SizedBox(height: 10.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              height: 730.h,
              child: ListView(
                  children: restaurant.codes.map((code) =>
                      StreamBuilder<bool>(
                      stream: controller.checkClose(restaurant.restaurant_id, code.code_id),
                      builder: (context, snapshot){
                        if(snapshot.data == null)
                          return Loading();
                        if(!snapshot.data){
                          return StreamBuilder<List<Order>>(
                              stream: controller.getOrder(restaurant.restaurant_id, code.code_id),
                              builder: (context, snapshot){
                                if(snapshot.data == null)
                                  return Loading();
                                List<Order> items = snapshot.data;
                                double bill = 0.0;
                                items.where((element) => element.send).forEach((order) {
                                  MenuEntry entry = restaurant.menu.firstWhere((entry) => entry.id == order.entry_id);
                                  bill += entry.price*order.amount;
                                });
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, "/detailorder", arguments: [restaurant, code.code_id]);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.h),
                                    child: Container(
                                      width: 400.w,
                                      height: 80.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        boxShadow: [BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0, 3),
                                        ),],),
                                      child: Row(
                                        children: [
                                          Container(width: 190.w, child: Text("Table: ${code.code_id}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                                          Container(width: 180.w, child: Text("Total: $bill  ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                        return Container();
                      })
                  ).toList()
              ),
            ),
          ),
        ],
      )
    );
  }
}

class OrderDetail extends StatefulWidget {
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  Restaurant restaurant;
  String code_id;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    List arg = ModalRoute.of(context).settings.arguments;
    restaurant = arg.first;
    code_id = arg.last;
    return StreamBuilder<List<Order>>(
        stream: RealTimeOrders().getOrder(restaurant.restaurant_id, code_id),
        builder: (context, snapshot) {
          if(snapshot.data == null)
            return Loading();
          List<Order> items = snapshot.data;
          double bill = 0.0;
          items.where((element) => element.send).forEach((order) {
            MenuEntry entry = restaurant.menu.firstWhere((entry) => entry.id == order.entry_id);
            bill += entry.price*order.amount;
          });
          return Scaffold(
            body: Column(
              children: [
                Text("Table: $code_id", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
                SizedBox(height: 30.h,),
                Text("Total: $bill  ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
                SizedBox(height: 30.h,),
                Row( mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Price", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(15),),)),
                    SizedBox(width: 15.w,),
                    Text("Amount", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(15),),)),
                    SizedBox(width: 10.w,),
                  ],
                ),
                //SizedBox(height: 10.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    height: 540.h,
                    //color: Colors.blue,
                    child: ListView(
                              children: items.where((element) => element.send).map((order) =>
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Container(
                                    width: 400.w,
                                    height: 80.h,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 250.w,
                                          height: 80.h,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              border: Border.all(color: Colors.black, width: 1)
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                                                child: Container(
                                                  width: 190,
                                                  height: 80.h,
                                                  child: Text("${restaurant.menu.firstWhere((element) => element.id == order.entry_id).name}", maxLines: 3, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(height: 5.h,),
                                                  Container(
                                                    height: 30.h,
                                                    child: Checkbox(value: order.check, activeColor: Color.fromRGBO(255, 110, 117, 0.9) , onChanged: (value){
                                                      setState(() {
                                                        order.check = value;
                                                        RealTimeOrders().updateOrderData(
                                                            restaurant.restaurant_id, code_id, order);
                                                      });
                                                    }),
                                                  ),
                                                  order.note != "" ? Container(
                                                    height: 30.h,
                                                    child: IconButton(icon: Icon(Icons.message_outlined, size: ScreenUtil().setSp(26),), onPressed: (){
                                                      Alerts.dialog(order.note, context);
                                                    }),
                                                  ) : Container(),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 14.w,),
                                        Text("${restaurant.menu.firstWhere((element) => element.id == order.entry_id).price} ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                                        SizedBox(width: 28.w,),
                                        Text(order.amount.toString(), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                                      ],
                                    ),
                                  ),
                                )
                              ).toList()
                          ),
                    ),
                  ),
                SizedBox(height: 20.h,),
                GestureDetector(
                  onTap: () async{
                    if(await Alerts.confirmation("You will lose all the data, are you sure?", context)){
                      RealTimeOrders().closeOrder(restaurant.restaurant_id, code_id);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 200.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1)
                    ),
                    child: Center(
                      child: Text("Close order", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                    ),
                  ),
                )
              ],
            ),
          );
    });
  }
}
