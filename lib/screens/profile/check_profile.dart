import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/shared/common_data.dart';

class CheckProfile extends StatefulWidget {
  @override
  _CheckProfileState createState() => _CheckProfileState();
}

class _CheckProfileState extends State<CheckProfile> {
  User user;

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 260.h,
            //color: Colors.blue,
            child: Stack(
              children: [
                Container(
                  height: 130.h,
                  width: 411.w,
                  color: Color.fromRGBO(255, 110, 117, 0.60),
                ),
                Column(
                  children: [
                    SizedBox(height: 30.h,),
                    Container(
                      height: 220.h,
                      width: 220.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Container(
                          height: 160.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                          ),
                          child: Center(
                            child: Container(
                              height: 143.h,
                              width: 143.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey
                              ),
                              child: Center(
                                child: Container(
                                  height: 136.h,
                                  width: 136.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: Image.network(user.picture).image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 90.h,
                  right: 10.w,
                  child: Container(
                    width: 190.w,
                    child:Text(user.username, maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(23),),)),
                  ),
                ),
                Positioned(
                  top: 140.h,
                  right: 10.w,
                  child: Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 160.w,
                        child:Text(user.name, maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                      ),
                      Flag(
                        user.country,
                        height: 30.h,
                        width: 30.w,
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 175.h,
                  right: 20.w,
                  child: Container(
                    width: 180.w,
                    child:Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Text("770 T", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                        //Spacer(),
                        Text("2894 ", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                        Icon(Icons.star, size: ScreenUtil().setSp(28), color: Colors.yellow,)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
                children: [
                  Text("2894 ", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(19),),)),
                  Text("followers", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                  Spacer(),
                  Text("123 ", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(19),),)),
                  Text("following", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                ]
            ),
          ),
          SizedBox(height: 20.h,),
          GestureDetector(
            child: Center(
              child: Container(
                width: 165.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(1, 1), // changes position of shadow
                  ),],
                ),
                child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: ScreenUtil().setSp(32), color: Colors.white,),
                    Column(
                      children: [
                        SizedBox(height: 4.h,),
                        Text("   Follow", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(23),),)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              width: 381.w,
              height: user.about == null ? 1 : 130.h,
              child:Text(user.about ?? "", maxLines: 5, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
            ),
          ),
        ],
      )
    );
  }
}
