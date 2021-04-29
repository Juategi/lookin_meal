import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/home/home.dart';
import 'package:lookinmeal/screens/profile/ratings_tile.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';

class UserNotifications extends StatefulWidget {
  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {

  Future _getNotifications() async{
    DBServiceUser.userF.notifications = await DBServiceUser.dbServiceUser.getNotifications(DBServiceUser.userF.uid);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    AppLocalizations tr = AppLocalizations.of(context);
    _getNotifications();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 42.h,
              width: 411.w,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 110, 117, 0.9),
              ),
              child:Text(tr.translate("mynot"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
            ),
            SizedBox(height: 10.h,),
            DBServiceUser.userF.notifications == null? Loading() : Expanded(child: ListView(
                children: DBServiceUser.userF.notifications.map((notification) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.w),
                  child: Container(
                    width: 380.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.w),
                      child: Row( mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 27.h,
                                width: 260.w,
                                child: Text(notification.restaurant_name, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18),),)),
                              ),
                              Container(
                                  height: 50.h,
                                  width: 260.w,
                                  child: Text(notification.body, maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                            ],
                          ),
                          Container(
                            height: 60.h,
                            width: 60.w,
                            child: IconButton(icon: Icon(Icons.delete,  size: ScreenUtil().setSp(29), color: Color.fromRGBO(255, 110, 117, 0.7),), onPressed: ()async{
                              DBServiceUser.userF.notifications.remove(notification);
                              await DBServiceUser.dbServiceUser.deleteNotification(notification.id);
                              setState(() {
                              });
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList()
            ))
          ],
        ),
      ),
    );
  }
}
