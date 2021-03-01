import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
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
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
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
                  Container(width: 382.w, child: Text(restaurant.address, maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
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
                      Container(width: 340.w, height: 25.h,  child: Text(restaurant.types.length > 1 ? "${restaurant.types[0]}, ${restaurant.types[1]}" : restaurant.types.length > 0 ? "${restaurant.types[0]}" : "", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                    ],
                  ),
                  SizedBox(height: 20.h,),
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
                  SizedBox(height: 10.h,),
                  Row(
                    children: <Widget>[
                      restaurant.delivery[0] == "" ? Container() : GestureDetector(
                        child: Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/glovo.png").image),
                            borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                        ),
                        onTap: () async{
                          if (await canLaunch(restaurant.delivery[0])) {
                            await launch(restaurant.delivery[0]);
                          }
                          else
                            throw 'Could not open the web.';
                        },
                      ),
                      restaurant.delivery[0] == "" ? Container() : SizedBox(width: 20.w,),
                      restaurant.delivery[1] == "" ? Container() : GestureDetector(
                        child: Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/ubereats.png").image),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                        ),
                        onTap: () async{
                          //await launch(restaurant.delivery[1].replaceAll('"', ''));
                          if (await canLaunch(restaurant.delivery[1])) {
                            await launch(restaurant.delivery[1]);
                          }
                          else {
                            print(restaurant.delivery[1]);
                            throw 'Could not open the web.';
                          }
                        },
                      ),
                      restaurant.delivery[1] == "" ? Container() : SizedBox(width: 20.w,),
                      restaurant.delivery[2] == "" ? Container() : GestureDetector(
                        child: Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/justeat.png").image),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                        ),
                        onTap: () async{
                          if (await canLaunch(restaurant.delivery[2])) {
                            await launch(restaurant.delivery[2]);
                          }
                          else
                            throw 'Could not open the web.';
                        },
                      ),
                      restaurant.delivery[2] == "" ? Container() : SizedBox(width: 20.w,),
                      restaurant.delivery[3] == "" ? Container() : GestureDetector(
                        child: Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/deliveroo.png").image),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                        ),
                        onTap: () async{
                          if (await canLaunch(restaurant.delivery[3])) {
                            await launch(restaurant.delivery[3]);
                          }
                          else
                            throw 'Could not open the web.';
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h,),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Monday", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 50.w,),
                          Text(parseSchedule(restaurant.schedule["1"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          //Text(restaurant.schedule["1"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text("Tuesday", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 50.w,),
                          Text(parseSchedule(restaurant.schedule["2"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text("Wednesday", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 27.w,),
                          Text(parseSchedule(restaurant.schedule["3"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text("Thrusday", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 43.w,),
                          Text(parseSchedule(restaurant.schedule["4"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text("Friday", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 65.w,),
                          Text(parseSchedule(restaurant.schedule["5"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text("Saturday", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 44.w,),
                          Text(parseSchedule(restaurant.schedule["6"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        children: <Widget>[
                          Text("Sunday", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                          SizedBox(width: 57.w,),
                          Text(parseSchedule(restaurant.schedule["0"]), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
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

  String parseSchedule(List<String> hours){
    String text = "";
    for(int i = 0; i < hours.length; i+=2){
      hours[i] = hours[i].replaceAll("[", "").replaceAll("]", "").trim();
      hours[i+1] = hours[i+1].replaceAll("[", "").replaceAll("]", "").trim();
      if(hours[i].toString() != "-1"){
        if(hours[i].toString().length == 2){
          text += hours[i].toString() + ":00" ;
        }
        else{
          text += hours[i].toString().substring(0,2) + ":" + hours[i].toString().substring(2,4);
        }
        text += " - ";
        if(hours[i+1].toString().length == 2){
          text += hours[i+1].toString() + ":00" ;
        }
        else{
          text += hours[i+1].toString().substring(0,2) + ":" + hours[i+1].toString().substring(2,4);
        }
        text += "     ";
      }
    }
    return text;
  }
}
