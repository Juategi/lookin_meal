import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/loading.dart';

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
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
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
                            IconButton(icon: Icon(Icons.file_download, size: ScreenUtil().setSp(28),), onPressed: (){
                              //Descargar factura
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
