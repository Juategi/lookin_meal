import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/geolocation.dart';
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

  Future getRestaurant() async{
    List aux = await DBServiceRestaurant.dbServiceRestaurant.getRestaurantsById([restaurant_id], GeolocationService.myPos.latitude, GeolocationService.myPos.longitude);
    restaurant = aux.first;
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
      if(restaurant == null)
        getRestaurant();
      init = false;
    }
    return Scaffold(
      body: Column(
        children: [
          Center(child: Text(restaurant == null?  "a" : restaurant.name),)
        ],
      ),
    );
  }
}
