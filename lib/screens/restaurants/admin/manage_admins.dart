import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/owner.dart';
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
  List<Owner> owners;
  Restaurant restaurant;
  bool init = true;

  Future loadUsers() async{
    owners = await DBServiceUser.dbServiceUser.getOwners(restaurant.restaurant_id);
    setState(() {
    });
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
              children: <Widget>[
                Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Manage Admins", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(28),),)),
                  ]
                ),
                SizedBox(height: 10.h,),
                Text("Mark the check for the user to have permission to manage other admin", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                SizedBox(height: 20.h,),
              ] + owners.map((user) =>
                  user.user_id == DBServiceUser.userF.uid ? Container() : Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Container(
                      height: 80.h,
                      width: 300.w,
                      child: Row(
                        children: [
                          Container(width: 200.w, child: Text(user.username, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),))),
                          SizedBox(width: 10.w,),
                          Checkbox(
                              value: user.type == 'A'? true : false,
                              onChanged: owners.firstWhere((o) => o.user_id == DBServiceUser.userF.uid).type == 'B'? null :
                                (val){
                                  if(val){
                                    user.type = 'A';
                                  }
                                  else{
                                    user.type = 'B';
                                  }
                                  setState(() {
                                  });
                                },
                          ),
                          SizedBox(width: 20.w,),
                          IconButton(
                            icon:  Icon(Icons.delete, color: owners.firstWhere((o) => o.user_id == DBServiceUser.userF.uid).type == 'B'? Colors.grey : Colors.black,),
                            iconSize: ScreenUtil().setSp(26),
                            onPressed: owners.firstWhere((o) => o.user_id == DBServiceUser.userF.uid).type == 'B'? null : ()async{
                              setState(() {
                                owners.remove(user);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )
              ).toList(),
            ),
          )
        )
    );
  }
}
