import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/owner.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/shared/alert.dart';
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
              ] + (owners == null? [Loading()] : owners.map((user) =>
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
                                  DBServiceUser.dbServiceUser.updateOwner(user);
                                },
                          ),
                          SizedBox(width: 20.w,),
                          IconButton(
                            icon:  Icon(Icons.delete, color: owners.firstWhere((o) => o.user_id == DBServiceUser.userF.uid).type == 'B'? Colors.grey : Colors.black,),
                            iconSize: ScreenUtil().setSp(26),
                            onPressed: owners.firstWhere((o) => o.user_id == DBServiceUser.userF.uid).type == 'B'? null : ()async{
                              DBServiceUser.dbServiceUser.deleteOwner(user);
                              setState(() {
                                owners.remove(user);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )
              ).toList()),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 80.h,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50.h,
                    width: 160.w,
                    child: RaisedButton(elevation: 0,
                      color: Color.fromRGBO(255, 110, 117, 0.9),
                      child: Text("Add new", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18)),),
                      onPressed: ()async{
                        await showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              String username;
                              InputDecoration input = InputDecoration(
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(20)
                                  )
                              );
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 300.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                                    child: Column(
                                      children: [
                                        Text("Add new admin", style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(18)),),
                                        SizedBox(height: 30.h,),
                                        TextField(
                                          onChanged: (val){
                                            username = val;
                                          },
                                          decoration: input.copyWith(hintText: "Username..."),
                                        ),
                                        SizedBox(height: 10.h,),
                                        Container(
                                          height: 50.h,
                                          width: 160.w,
                                          child: RaisedButton(elevation: 0,
                                            color: Color.fromRGBO(255, 110, 117, 0.9),
                                            child: Text("Add", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18)),),
                                            onPressed: () async{
                                              User user = await DBServiceUser.dbServiceUser.getUserDataUsername(username);
                                              print(user);
                                              if(user == null){
                                                Alerts.toast("User not found!");
                                              }
                                              else{
                                                if(owners.firstWhere((o) => o.username == user.username, orElse: () => Owner()).username == null){
                                                  Owner owner = Owner(
                                                      restaurant_id: restaurant.restaurant_id,
                                                      username: user.username,
                                                      user_id: user.uid,
                                                      type: 'B',
                                                      token: ""
                                                  );
                                                  DBServiceUser.dbServiceUser.createOwner(owner);
                                                  owners.add(owner);
                                                  Navigator.pop(context);
                                                }
                                                else{
                                                  Alerts.toast("User is already an admin!");
                                                }
                                              }
                                            }, ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                        setState(() {
                        });
                      },),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
