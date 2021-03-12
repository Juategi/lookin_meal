import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';

class ManageAdmins extends StatefulWidget {
  @override
  _ManageAdminsState createState() => _ManageAdminsState();
}

class _ManageAdminsState extends State<ManageAdmins> {
  Map<User, String> users;
  Restaurant restaurant;
  bool init = true;

  Future loadUsers() async{
    users = await DBServiceRestaurant.dbServiceRestaurant.getOwners(restaurant.restaurant_id);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    if(init){
      loadUsers();
      init = false;
    }
    return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: ListView(
              children: [
                Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Manage Admins", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(28),),)),
                  ],
                ),
              ],
            ),
          )
        )
    );
  }
}
