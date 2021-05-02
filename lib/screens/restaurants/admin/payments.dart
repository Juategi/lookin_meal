import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:lookinmeal/shared/loading.dart';
import 'package:permission/permission.dart';

class PaymentList extends StatefulWidget {
  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  Restaurant restaurant;
  List<Payment> payments;
  Future getPayments() async{
    payments = await DBServicePayment.dbServicePayment.getPayments(restaurant.restaurant_id);
    payments.sort((p1,p2) => Functions.compareDates(p1.paymentdate.substring(0,10), p2.paymentdate.substring(0,10)));
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    restaurant = ModalRoute.of(context).settings.arguments;
    getPayments();
    return SafeArea(child:
      payments == null? Loading() :Scaffold(
        body: Column(
          children: [
            SizedBox(height: 32.h,),
            Center(child: Text("Payments", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(24),),))),
            SizedBox(height: 25.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                height: 600.h,
                child: ListView(
                  children: payments.map((payment) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Container(
                      width: 345.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(1, 1), // changes position of shadow
                        ),],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Container(
                              height: 70.h,
                              width: 190.w,
                              child: Text("${payment.description}", maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.niramit(textStyle: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: .3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(13),),)),
                            ),
                            Text("${Functions.formatDate(payment.paymentdate.substring(0,10))}", maxLines: 2,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.niramit(textStyle: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.normal,
                                  fontSize: ScreenUtil().setSp(15),),)),
                            SizedBox(width: 20.w,),
                            IconButton(icon: Icon(Icons.file_download, size: ScreenUtil().setSp(28),), onPressed: () async{
                              await Permission.requestPermissions([PermissionName.Storage]);
                              final pdf = pw.Document();
                              Directory directory = await getApplicationDocumentsDirectory();
                              var dbPath = directory.path + "applogo.PNG";
                              ByteData data = await rootBundle.load("assets/applogo.PNG");
                              List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                              File i = await File(dbPath).writeAsBytes(bytes);
                              final image = pw.MemoryImage(
                                i.readAsBytesSync(),
                              );
                              pdf.addPage(pw.Page(
                                  pageFormat: PdfPageFormat.a4,
                                  build: (pw.Context context) {
                                    return pw.Container(
                                        color: PdfColors.white,
                                        height: 1240,
                                        width: 880,
                                        child: pw.Column(
                                          children: [
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end,
                                              children: [
                                                pw.Container(
                                                  height: 55,
                                                  width: 125,
                                                  decoration: pw.BoxDecoration(
                                                      image:  pw.DecorationImage(
                                                          fit: pw.BoxFit.cover,
                                                          image: pw.Image(image).image
                                                      )
                                                  ),
                                                )
                                              ]
                                            ),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                                              children: [
                                                pw.Text("Factura", style: pw.TextStyle(color: PdfColors.black,
                                                  letterSpacing: .3,
                                                  fontWeight: pw.FontWeight.bold,
                                                  fontSize: ScreenUtil().setSp(16),))
                                              ]
                                            ),
                                            pw.SizedBox(height: 20),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Text("Fecha ${Functions.formatDate(payment.paymentdate.substring(0,10))}", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(13),))
                                                ]
                                            ),
                                            pw.SizedBox(height: 5),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Text("Número de factura: ${payment.id}", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(13),))
                                                ]
                                            ),
                                            pw.SizedBox(height: 5),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Text("ID de usuario: ${payment.user_id}", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(13),))
                                                ]
                                            ),
                                            pw.SizedBox(height: 5),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Text("ID del local: ${payment.restaurant_id}", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(13),))
                                                ]
                                            ),
                                            pw.SizedBox(height: 5),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Text("Nombre del local: ${restaurant.name}", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(13),))
                                                ]
                                            ),
                                            pw.SizedBox(height: 30),
                                            pw.Container(
                                              height: 1,
                                              width: 850,
                                              color: PdfColors.black,
                                            ),
                                            pw.SizedBox(height: 20),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                children: [
                                                  pw.Text("Servicio", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.bold,
                                                    fontSize: ScreenUtil().setSp(13),)),
                                                  pw.Text("Descripción", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.bold,
                                                    fontSize: ScreenUtil().setSp(13),)),
                                                  pw.Text("Precio", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.bold,
                                                    fontSize: ScreenUtil().setSp(13),)),
                                                ]
                                            ),
                                            pw.SizedBox(height: 10),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                children: [
                                                  pw.Text(payment.service, style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(13),)),
                                                  pw.Container(
                                                    height: 20,
                                                    width: 140,
                                                    child: pw.Text(payment.description, style: pw.TextStyle(color: PdfColors.black,
                                                      letterSpacing: .3,
                                                      fontWeight: pw.FontWeight.normal,
                                                      fontSize: ScreenUtil().setSp(13),)),
                                                  ),
                                                  pw.Text("${payment.price} EUR", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(13),)),
                                                ]
                                            ),
                                            pw.SizedBox(height: 60),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Text("Incluye 10% de IVA ${payment.price/10} EUR", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(13),))
                                                ]
                                            ),
                                            pw.SizedBox(height: 10),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                                                children: [
                                                  pw.Text("Factura emitida por FindEat", style: pw.TextStyle(color: PdfColors.black,
                                                    letterSpacing: .3,
                                                    fontWeight: pw.FontWeight.normal,
                                                    fontSize: ScreenUtil().setSp(13),))
                                                ]
                                            ),
                                            pw.SizedBox(height: 180),
                                            pw.Container(
                                              height: 1,
                                              width: 850,
                                              color: PdfColors.black,
                                            ),
                                          ]
                                        )
                                    );// Center
                                  }));
                              final output2 = Directory("/storage/emulated/0/Download/");
                              final file = File("${output2.path}/${payment.id}.pdf");
                              await file.writeAsBytes(await pdf.save());
                              print(output2.path);
                              Alerts.toast("Payment downloaded!");
                            })
                          ],
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            )
          ],
        ),
    ));
  }
}
