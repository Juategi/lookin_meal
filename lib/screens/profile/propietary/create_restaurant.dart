import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'file:///C:/D/lookin_meal/lib/screens/profile/propietary/find_restaurant.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CreateRestaurant extends StatefulWidget {
  @override
  _CreateRestaurantState createState() => _CreateRestaurantState();
}

class _CreateRestaurantState extends State<CreateRestaurant> {
  String relation = "Dueño";
  String name, website, phone, address, city, country, currency, image;
  List<String> types;
  double latitude, longitude;
  final StorageService _storageService = StorageService();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView(
            children: [
              GestureDetector(
                onTap: () async{
                  image = await _storageService.uploadImage(context, "restaurantrequest");
                  if(image != null){
                    setState((){
                    });
                  }
                },
                child: Container(
                  width: 410.w,
                  height: 130.h,
                  decoration: image == null? null: BoxDecoration(
                    image: DecorationImage(
                      image: Image.network(image).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Icon(Icons.camera_alt, size: ScreenUtil().setSp(55), color: Color.fromRGBO(255, 110, 117, 0.7),)
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              Text("Name", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10.h,),
              Center(
                child: TextField(
                  onChanged: (val){
                    name = val;
                  },
                  maxLines: 1,
                  maxLength: 150,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  decoration: textInputDeco.copyWith(hintText: "Name here"),
                ),
              ),
              SizedBox(height: 20.h,),
              Text("Location", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10.h,),
              Container(
                  width: 400.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.black)
                  ),
                  child: Center(child: Text("address", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)))
              ),
              SizedBox(height: 20.h,),
            ],
          ),
        ),
      ),
    );
  }
}
