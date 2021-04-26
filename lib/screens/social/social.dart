import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  List<List> feed;
  bool init = true;

  Future _loadFeed() async{
    feed = await DBServiceRestaurant.dbServiceRestaurant.getFeed(DBServiceUser.userF.uid);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    if(init){
      _loadFeed();
      init = false;
    }
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(child:
      Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: feed == null? Loading() : Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Find out new people to follow near you', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.9), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(20),),)),
              Text('What are your friends eating? ', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.9), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10.h,),
              Container(
                height: 500.h,
                child: ListView(
                  children: feed.map((sublist) {
                    User user = sublist.first;
                    MenuEntry entry = sublist[1];
                    Rating rating = sublist[2];
                    Restaurant restaurant = sublist.last;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      child: Container(
                        width: 385.w,
                        height: 110.h,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(height: 55.h, width: 55.w,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(1, 1), // changes position of shadow
                                        ),],
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                user.picture)
                                        )
                                    )
                                ),
                                SizedBox(height: 10.h,),
                                Container(
                                  width: 60.w,
                                  child: Text(user.username, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(104, 97, 105, 0.9), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(15),),)),
                                )
                              ],
                            ),
                            SizedBox(width: 5.w,),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5.h,),
                                Row(
                                  children: [
                                    StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: rating.rating, size: ScreenUtil().setSp(11),),
                                  ],
                                ),
                                Container(width: 75.w, child: Text(Functions.formatDate(rating.date), maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(104, 97, 105, 0.9), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(11),),))),
                                Container(width: 75.w, child: Text(entry.name, maxLines: 3, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(104, 97, 105, 0.9), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(11),),))),
                                Container(width: 75.w, child: Text(restaurant.name, maxLines: 2, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.9), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(11),),))),
                              ],
                            ),
                            SizedBox(width: 6.w,),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 135.w,
                                  height: 100.h,
                                  child: Text(rating.comment , maxLines: 6, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(104, 97, 105, 0.9), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),)),
                                ),
                              ],
                            ),
                            SizedBox(width: 5.w,),
                            Column(
                              children: [
                                SizedBox(height: 4.h,),
                                Container(
                                  width: 85.w,
                                  height: 85.h,
                                    decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(18)),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                entry.image)
                                        )
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  ).toList(),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
