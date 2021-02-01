import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'package:lookinmeal/models/code.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EditCodes extends StatefulWidget {
  @override
  _EditCodesState createState() => _EditCodesState();
}

class _EditCodesState extends State<EditCodes> {
  Restaurant restaurant;
  bool init = true;

  Future _getCodes() async{
    restaurant.codes = await DBServiceReservation.dbServiceReservation.getCodes(restaurant.restaurant_id);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    if(init){
      _getCodes();
      init = false;
    }
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 32.h,),
          Center(child: Text("Orders configuration", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(24),),))),
          SizedBox(height: 32.h,),
          Container(
            height: 400.h,
            child: Expanded(child: ListView(
                children: restaurant.codes.map((code) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Container(
                    width: 395.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),],),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      child: Row(
                        children: [
                          Container(width: 140.w, child: Text("Table: " + code.code_id, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                          GestureDetector(
                            onTap: (){
                              
                            },
                            child: Row(
                              children: [
                                Text("Download QR  ", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14),),)),
                                Icon(FontAwesomeIcons.qrcode, size: ScreenUtil().setSp(25),),
                              ],
                            ),
                          ),
                          SizedBox(width: 42.w,),
                          IconButton(icon: Icon(Icons.delete, size: ScreenUtil().setSp(28),), onPressed: ()async{
                            await DBServiceReservation.dbServiceReservation.deleteCode(code.code_id, code.restaurant_id);
                            setState(() {
                              restaurant.codes.remove(code);
                            });
                            Alerts.toast("QR deleted!");
                          })
                        ],
                      ),
                    ),
                  ),
                )
              ).toList(),
            )),
          ),
          GestureDetector(
            onTap: () async{
              Navigator.pushNamed(context, "/newcode",arguments: restaurant).then((value) => setState(() {}));
            },
            child: Container(
              height: 100.h,
              width: 100.w,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(1, 1), // changes position of shadow
                ),],
              ),
              child: Icon(Icons.add, size: ScreenUtil().setSp(65),),
            ),
          ),
        ],
      ),
    );
  }
}

class NewQRCode extends StatefulWidget {
  @override
  _NewQRCodeState createState() => _NewQRCodeState();
}

class _NewQRCodeState extends State<NewQRCode> {
  Restaurant restaurant;
  String name = "";

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 32.h,),
          Center(child: Text("New QR Code", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(24),),))),
          SizedBox(height: 50.h,),
          Text("Name of the code, it has to be unique", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(16),),)),
          SizedBox(height: 5.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextField(
              maxLines: 1,
              maxLength: 50,
              decoration: textInputDeco,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z, 0-9]')),
              ],
              onChanged: (v){
                setState(() {
                  name = v;
                });
              },
            ),
          ),
          SizedBox(height: 50.h,),
          Center(
            child: QrImage(
              data: restaurant.restaurant_id + "/" + name,
              version: QrVersions.auto,
              size: ScreenUtil().setSp(250),
            ),
          ),
          SizedBox(height: 80.h,),
          Center(
            child: GestureDetector(
              onTap: () async{
                if(name != "" && restaurant.codes.every((code) => code.code_id != name)){
                  Code code = Code(
                      restaurant_id: restaurant.restaurant_id,
                      code_id: name,
                      link: restaurant.restaurant_id + "/" + name
                  );
                  restaurant.codes.add(code);
                  await DBServiceReservation.dbServiceReservation.createCode(code);
                  Navigator.pop(context);
                }
                else{
                  Alerts.dialog("Name empty or already taken!", context);
                }
              },
              child: Container(
                width: 230.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),],),
                child: Center(child: Text("Save", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(22),),))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
