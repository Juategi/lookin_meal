import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';

class RestaurantInfo extends StatefulWidget {
  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  Restaurant restaurant;
  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    final DBService _dbService = DBService();
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 32.h,),
          Container(
            height: 42.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.9),
            ),
            child:Text("Restaurant information", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
          ),
          SizedBox(height: 10.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: <Widget>[
                Text(restaurant.address, maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                SizedBox(height: 10.h,),
                GestureDetector(
                  child: Container(
                    width: 382.w,
                    height: 95.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(fit: BoxFit.cover, image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=${restaurant.address}&zoom=15&size=900x600&maptype=roadmap&markers=color:red%7Clabel:.%7C${restaurant.latitude},${restaurant.longitude}&key=AIzaSyAIIK4P68Ge26Yc0HkQ6uChj_NEqF2VeCU'))
                    ),
                  ),
                  onTap: ()async{
                    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${restaurant.latitude},${restaurant.longitude}';
                    if (await canLaunch(googleUrl)) {
                      await launch(googleUrl);
                    }
                    else
                      throw 'Could not open the map.';
                  },
                ),
                SizedBox(height: 20.h,),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset("assets/telef.svg"),
                      ),
                      SizedBox(width: 10.w,),
                      Column(
                        children: <Widget>[
                          Text(restaurant.phone, maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                          SizedBox(height: 5.h,)
                        ],
                      ),
                    ],
                  ),
                  onTap: ()async{
                    String phone= 'tel:${restaurant.phone}';
                    if (await canLaunch(phone)) {
                      await launch(phone);
                    }
                    else
                      throw 'Could not open the call.';
                  },
                ),
                SizedBox(height: 10.h,),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset("assets/mail.svg"),
                      ),
                      SizedBox(width: 10.w,),
                      Column(
                        children: <Widget>[
                          Text(restaurant.email, maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                          SizedBox(height: 7.h,)
                        ],
                      ),
                    ],
                  ),
                  onTap: ()async{
                    String mail= 'mailto:${restaurant.email}';
                    if (await canLaunch(mail)) {
                      await launch(mail);
                    }
                    else
                      throw 'Could not open the email.';
                  },
                ),
                SizedBox(height: 10.h,),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset("assets/web.svg"),
                      ),
                      SizedBox(width: 10.w,),
                      Column(
                        children: <Widget>[
                          Text(restaurant.website, maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                          SizedBox(height: 7.h,)
                        ],
                      ),
                    ],
                  ),
                  onTap: ()async{
                    String web = '${restaurant.website}';
                    if (await canLaunch(web)) {
                      await launch(web);
                    }
                    else
                      throw 'Could not open the web.';
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
