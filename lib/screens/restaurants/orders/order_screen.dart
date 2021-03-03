import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/order.dart';
import 'package:lookinmeal/models/owner.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/menu.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/push_notifications.dart';
import 'package:lookinmeal/services/realtime_orders.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with ChangeNotifier{
  Restaurant restaurant;
  String restaurant_id, table_id, code;
  bool init = true;
  bool first = true;
  double bill = 0.0;
  final RealTimeOrders controller = RealTimeOrders();
  PersistentTabController _controller;

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
    widgets.addAll(RealTimeOrders.items.where((order) => order.send).map((order) {
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
    widgets.add(SizedBox(height: 12.h,));
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
    widgets.addAll(RealTimeOrders.items.where((order) => !order.send).map((order) {
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
          DropdownButton(items: List<int>.generate(31, (i) => i).map((n) => DropdownMenuItem(value: n, child:
          Text(n.toString(), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(22),),)),
          )).toList(), onChanged: (s){
            setState(() {
              if(s == 0){
                controller.deleteOrderData(restaurant_id, table_id, order);
              }
              else{
                order.amount = s;
                controller.updateOrderData(restaurant_id, table_id, order);
              }
            });
          }, value: order.amount,),
        ],
      );
    }
    ));
    return widgets;
  }

  Future<void> scanQR() async {
    if(DBServiceUser.userF.inOrder == null){
      try {
        code = await FlutterBarcodeScanner.scanBarcode(
            "#FF6E75", "Cancel", true, ScanMode.QR);
        print(code);
      } on PlatformException {
        code = null;
      }
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      if(code != null)
        if(!RegExp(r'[a-zA-Z0-9]+/+[a-zA-Z0-9]').hasMatch(code))
          setState(() {
            _controller.jumpToTab(0);
          });
        else setState(() {
          _controller.notifyListeners();
        });
    }
    else setState(() {
      _controller.notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    _controller = Provider.of<PersistentTabController>(context);
    if(first){
      CommonData.tabContext = context;
      first = false;
    }
    if(code == null)
      return SafeArea(child: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: scanQR,
            child: Icon(Icons.camera , size: ScreenUtil().setSp(60)),
          ),
        ),
      ));
    if(init){
      restaurant_id = code.split("/").first;
      table_id = code.split("/").last;
      RealTimeOrders.actualTable = table_id;
      restaurant = Pool.getRestaurant(restaurant_id);
      DBServiceUser.userF.inOrder = code;
      if(restaurant == null)
        getRestaurant();
      init = false;
    }
    return restaurant == null ? Loading() :
    StreamBuilder<bool>(
        stream: controller.checkClose(restaurant.restaurant_id, table_id),
        builder: (context, snapshot) {
        if (snapshot.data == null)
          return Loading();
        bool closed = snapshot.data;
        if(closed) {
          DBServiceUser.userF.inOrder = null;
          Navigator.pop(context);
        }
        return StreamBuilder<List<Order>>(
            stream: controller.getOrder(restaurant_id, table_id),
            builder: (context, snapshot) {
              if (snapshot.data == null)
                return Loading();
              RealTimeOrders.items = snapshot.data;
              if(RealTimeOrders.items.length > 0)
                RealTimeOrders.sent = true;
              if(RealTimeOrders.items.length == 0 && RealTimeOrders.sent){
                DBServiceUser.userF.inOrder = null;
                RealTimeOrders.sent = false;
                Navigator.pop(context);
              }
              bill = 0.0;
              RealTimeOrders.items.where((element) => element.send).forEach((
                  order) {
                MenuEntry entry = restaurant.menu.firstWhere((entry) =>
                entry.id == order.entry_id);
                bill += entry.price * order.amount;
              });
              return Scaffold(
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h,),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              DBServiceUser.userF.inOrder = null;
                              RealTimeOrders.sent = false;
                              code = null;
                              _controller.notifyListeners();
                              setState(() {
                              });
                              _controller.jumpToTab(0);
                            },
                            child: Container(
                              width: 100.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30)),
                                boxShadow: [BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 3),
                                ),
                                ],),
                              child: Center(child: Text("Exit", maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.niramit(
                                    textStyle: TextStyle(color: Colors.black,
                                      letterSpacing: .3,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(12),),))),
                            ),
                          ),
                          SizedBox(width: 40.w,),
                          Text("Total cost: ", maxLines: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.niramit(textStyle: TextStyle(
                                color: Colors.black,
                                letterSpacing: .3,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(20),),)),
                          SizedBox(width: 10.w,),
                          Container(
                            width: 90.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 110, 117, 0.9),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(12))
                            ),
                            child: Align(alignment: Alignment.center,
                                child: Text("${bill} ${restaurant.currency}",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.niramit(
                                      textStyle: TextStyle(color: Colors.white,
                                        letterSpacing: .3,
                                        fontWeight: FontWeight.normal,
                                        fontSize: ScreenUtil().setSp(18),),))),
                          ),
                        ],
                      ),
                      Container(
                        height: 530.h,
                        child: ListView(
                            children: _loadOrder()
                        ),
                      ),
                      //SizedBox(height: 10.h,),
                      GestureDetector(
                        onTap: () async {
                          if(!(RealTimeOrders.items.where((element) => !element.send).length == 0))
                            if (await Alerts.confirmation("If you send the order you won't be able to change it back, are you sure?", context)) {
                              setState(() {
                                RealTimeOrders.items.where((element) =>
                                !element.send).forEach((order) {
                                  /*bool found = false;
                          RealTimeOrders.items.where((element) => element.send).forEach((o) {
                            if(o.entry_id == order.entry_id){
                              found = true;
                              o.amount += order.amount;
                              o.note = o.note + " / " + order.note;
                              controller.updateOrderData(restaurant_id, table_id, o);
                              controller.deleteOrderData(restaurant_id, table_id, order);
                            }
                          });*/
                                  if (true) {
                                    order.send = true;
                                    controller.updateOrderData(
                                        restaurant_id, table_id, order);
                                  }
                                });
                              });
                              for(Owner owner in await DBServiceUser.dbServiceUser.getOwners(restaurant.restaurant_id)){
                                PushNotificationService.sendNotification("Order sent", "On restaurant: ${restaurant.name}", restaurant.restaurant_id, "order", owner.token);
                              }
                            }
                        },
                        child: Container(
                          height: 50.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 110, 117, 0.9),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(12))
                          ),
                          child: Center(child: Text("Send order", maxLines: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.niramit(
                                textStyle: TextStyle(color: Colors.white,
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.normal,
                                  fontSize: ScreenUtil().setSp(22),),))),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      GestureDetector(
                        onTap: () {
                          pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: "/addorder", arguments: restaurant),
                            screen: AddMoreOrder(),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.slideUp,
                          );
                          //Navigator.pushNamed(context, "/addorder", arguments: restaurant);
                        },
                        child: Container(
                          height: 50.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(12)),
                              border: Border.all(
                                color: Color.fromRGBO(255, 110, 117, 0.9),)
                          ),
                          child: Center(child: Text("Add more", maxLines: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.niramit(
                                textStyle: TextStyle(color: Colors.black,
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.normal,
                                  fontSize: ScreenUtil().setSp(22),),))),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
    });
  }
}


class AddMoreOrder extends StatefulWidget {
  @override
  _AddMoreOrderState createState() => _AddMoreOrderState();
}

class _AddMoreOrderState extends State<AddMoreOrder> {
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 42.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.9),
            ),
            child: Align( alignment: AlignmentDirectional.topCenter, child: Text("Add more to the order", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
          ),
          Provider.value(value: true, child: Provider.value(value: restaurant, child: Menu()))
        ],
      ),
    );
  }
}
