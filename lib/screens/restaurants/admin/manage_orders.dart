import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/order.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/realtime_orders.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';

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
                        print(snapshot.data);
                        if(snapshot.data == null)
                          return Text("1");
                        if(!snapshot.data){
                          return StreamBuilder<List<Order>>(
                              stream: controller.getOrder(restaurant.restaurant_id, code.code_id),
                              builder: (context, snapshot){
                                if(snapshot.data == null)
                                  return Text("2");
                                List<Order> items = snapshot.data;
                                double bill = 0.0;
                                RealTimeOrders.items.where((element) => element.send).forEach((order) {
                                  MenuEntry entry = restaurant.menu.firstWhere((entry) => entry.id == order.entry_id);
                                  bill += entry.price*order.amount;
                                });
                                return GestureDetector(
                                  onTap: (){
                                    
                                  },
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
                                        Container(width: 190.w, child: Text("Mesa: ${code.code_id}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                                        Container(width: 180.w, child: Text("Cuenta: $bill  ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                                      ],
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
