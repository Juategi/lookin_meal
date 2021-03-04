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
                    //color: Colors.blue,
                    child:Text(user.username, maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(23),),)),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
