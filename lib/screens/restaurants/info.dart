import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/enviroment.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/common_data.dart';

class RestaurantInfo extends StatefulWidget {
  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  Restaurant restaurant;
  String code;

  Future getCode() async{
    code = await Enviroment.getApi();
    setState(() {
    });
  }

  @override
  void initState() {
    getCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    AppLocalizations tr = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: code == null? Loading() : ListView(
          children: <Widget>[
            Container(
              height: 42.h,
              width: 411.w,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 110, 117, 0.9),
              ),
              child:Text(tr.translate("resinfo"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
            ),
            SizedBox(height: 7.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: <Widget>[
                  Container(width: 382.w, child: Text(restaurant.address, maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
                  SizedBox(height: 8.h,),
                  GestureDetector(
                    child: Container(
                      width: 382.w,
                      height: 92.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=${restaurant.address}&zoom=15&size=900x600&maptype=roadmap&markers=color:red%7Clabel:.%7C${restaurant.latitude},${restaurant.longitude}&key=${code}'))
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
                  SizedBox(height: 18.h,),
                  Row(
                    children: [
                      restaurant.types.length == 0 ? Container() : Container(
                          height: 25.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: Image.asset("assets/food/${CommonData.typesImage[restaurant.types[0]]}.png").image))
                      ),
                      SizedBox(width: 5.w,),
                      Container(width: 340.w, height: 25.h,  child: Text(restaurant.types.length > 1 ? "${tr.translate(restaurant.types[0])}, ${tr.translate(restaurant.types[1])}" : restaurant.types.length > 0 ? "${tr.translate(restaurant.types[0])}" : "", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                    ],
                  ),
                  SizedBox(height: 18.h,),
                  restaurant.phone != null && restaurant.phone.length > 2 ? GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset("assets/telef.svg"),
                        ),
                        SizedBox(width: 10.w,),
                        Column(
                          children: <Widget>[
                            Container(width: 330.w,child: Text(restaurant.phone, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
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
                  ):Container(),
                  SizedBox(height: 10.h,),
                  restaurant.email != null && restaurant.email.length > 2 ? GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset("assets/mail.svg"),
                        ),
                        SizedBox(width: 10.w,),
                        Column(
                          children: <Widget>[
                            Container(width: 330.w,child: Text(restaurant.email, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
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
                  ) : Container(),
                  SizedBox(height: 10.h,),
                  restaurant.website != null && restaurant.website.length > 2  ?GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset("assets/web.svg"),
                        ),
                        SizedBox(width: 10.w,),
                        Column(
                          children: <Widget>[
                            Container(width: 330.w,child: Text(restaurant.website, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
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
                  ):Container(),
                  SizedBox(height: 20.h,),
                  restaurant.schedule.toString() == "{1: [-1, -1], 2: [-1, -1], 3: [-1, -1], 4: [-1, -1], 5: [-1, -1], 6: [-1, -1], 0: [-1, -1]}" ? Container():
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(tr.translate("monday"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 50.w,),
                          Text(Functions.parseSchedule(restaurant.schedule["1"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          //Text(restaurant.schedule["1"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text(tr.translate("tuesday"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 50.w,),
                          Text(Functions.parseSchedule(restaurant.schedule["2"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text(tr.translate("wednesday"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 27.w,),
                          Text(Functions.parseSchedule(restaurant.schedule["3"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text(tr.translate("thursday"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 43.w,),
                          Text(Functions.parseSchedule(restaurant.schedule["4"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text(tr.translate("friday"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 65.w,),
                          Text(Functions.parseSchedule(restaurant.schedule["5"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text(tr.translate("saturday"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 44.w,),
                          Text(Functions.parseSchedule(restaurant.schedule["6"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text(tr.translate("sunday"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 57.w,),
                          Text(Functions.parseSchedule(restaurant.schedule["0"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
