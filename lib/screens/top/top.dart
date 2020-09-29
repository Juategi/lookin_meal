import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:provider/provider.dart';

class Top extends StatefulWidget {
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> {
  List<Restaurant> topRestaurant;
  Map<MenuEntry,Restaurant> topEntry;

  Future _loadData() async{

  }
  void _timer() {
    if(topEntry == null || topRestaurant == null) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        setState(() {
          print("Loading..");
        });
        _timer();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    //_timer();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 10.w),
        child: Column(
          children: <Widget>[
            Text('Top dishes', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
            SizedBox(height: 10.h,),
          ],
        ),
      ),
    );
  }
}
