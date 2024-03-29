import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/realtime_orders.dart';
import 'package:permission/permission.dart';
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
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

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

    AppLocalizations tr = AppLocalizations.of(context);
    restaurant = ModalRoute.of(context).settings.arguments;
    if(init){
      _getCodes();
      init = false;
    }
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 32.h,),
            Center(child: Text(tr.translate("ordersconf"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(24),),))),
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
                            Container(width: 140.w, child: Text("${tr.translate("table")}: " + code.code_id, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                            GestureDetector(
                              onTap: () async{
                                await Permission.requestPermissions([PermissionName.Storage]);
                                final pdf = pw.Document();
                                Directory directory = await getApplicationDocumentsDirectory();
                                var dbPath = directory.path + "PDF.png";
                                ByteData data = await rootBundle.load("assets/PDF.png");
                                List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                                File i = await File(dbPath).writeAsBytes(bytes);
                                final image = pw.MemoryImage(
                                  i.readAsBytesSync(),
                                );
                                pdf.addPage(pw.Page(
                                    pageFormat: PdfPageFormat.a4,
                                    build: (pw.Context context) {
                                      return pw.Transform.rotate(
                                        child: pw.Center(
                                            child: pw.Container(
                                                height: 333.333,
                                                width: 500,
                                                decoration: pw.BoxDecoration(
                                                    image:  pw.DecorationImage(
                                                        fit: pw.BoxFit.cover,
                                                        image: pw.Image(image).image
                                                    )
                                                ),
                                                child: pw.Stack(
                                                    children: [
                                                      pw.Positioned(
                                                        child: pw.Container(
                                                          height: 140,
                                                          width: 140,
                                                          child: pw.BarcodeWidget(
                                                            color: PdfColor.fromHex("#000000"),
                                                            barcode: pw.Barcode.qrCode(),
                                                            data: "https://findeat.page.link/?link=https://findeat.page.link/order?id=${restaurant.restaurant_id + "/" + code.code_id}&apn=com.wt.lookinmeal",
                                                          ),
                                                        ),
                                                        top: 127,
                                                        left: 287
                                                      ),
                                                      pw.Positioned(
                                                          child: pw.Container(
                                                            width: 170,
                                                            height: 50,
                                                            //color: PdfColor.fromHex("FFFFFF"),
                                                            child: pw.Center(
                                                              child: pw.Text(restaurant.name, maxLines: 2, textAlign: pw.TextAlign.center, style: pw.TextStyle(color: PdfColor.fromHex("FFFFFF"), letterSpacing: .3, fontWeight: pw.FontWeight.bold, fontSize: ScreenUtil().setSp(15))),
                                                            )
                                                          ),
                                                          top: 20,
                                                          left: 280
                                                      ),
                                                      pw.Positioned(
                                                          child: pw.Container(
                                                            //color: PdfColor.fromHex("FFFFFF"),
                                                            width: 170,
                                                            child: pw.Center(
                                                              child: pw.Text("${tr.translate("table")}: " + code.code_id, maxLines: 1,  textAlign: pw.TextAlign.center, style: pw.TextStyle(color: PdfColor.fromHex("FFFFFF"), letterSpacing: .3, fontWeight: pw.FontWeight.normal, fontSize: ScreenUtil().setSp(15))),
                                                            )
                                                          ),
                                                          top: 80,
                                                          left: 280
                                                      ),
                                                    ]
                                                )
                                            )),
                                        //transform: Matrix4.rotationZ(1)
                                        angle: pi/2
                                      );// Center
                                    }));
                                final output2 = Directory("/storage/emulated/0/Download/");
                                final file = File("${output2.path}/${code.code_id}.pdf");
                                await file.writeAsBytes(await pdf.save());
                                print(output2.path);
                                Alerts.toast(tr.translate("qrdownloaded"));
                              },
                              child: Row(
                                children: [
                                  Text("${tr.translate("downloadqr")}  ", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14),),)),
                                  Icon(FontAwesomeIcons.qrcode, size: ScreenUtil().setSp(25),),
                                ],
                              ),
                            ),
                            SizedBox(width: 42.w,),
                            IconButton(icon: Icon(Icons.delete, size: ScreenUtil().setSp(28),), onPressed: ()async{
                              DBServiceReservation.dbServiceReservation.deleteCode(code.code_id, code.restaurant_id);
                              RealTimeOrders().deleteOrder(restaurant.restaurant_id, code.code_id);
                              restaurant.codes.remove(code);
                              setState(() {
                              });
                              Alerts.toast(tr.translate("deletedqr"));
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
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: "/newcode", arguments: restaurant),
                  screen: NewQRCode(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                ).then((value) => setState(() {}));
                //Navigator.pushNamed(context, "/newcode",arguments: restaurant).then((value) => setState(() {}));
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

    AppLocalizations tr = AppLocalizations.of(context);
    restaurant = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 32.h,),
          Center(child: Text(tr.translate("newqr"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(24),),))),
          SizedBox(height: 50.h,),
          Text(tr.translate("codeunique"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(16),),)),
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
                  //FIREBASE CODE
                  RealTimeOrders().createOrder(restaurant.restaurant_id, name);
                  Navigator.pop(context);
                }
                else{
                  Alerts.dialog(tr.translate("nameno"), context);
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
                child: Center(child: Text(tr.translate("save"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(22),),))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
