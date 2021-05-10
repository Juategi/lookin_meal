import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/payment.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:url_launcher/url_launcher.dart';

class Premium extends StatefulWidget {
  @override
  _PremiumState createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  Restaurant restaurant;


  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    restaurant = ModalRoute.of(context).settings.arguments;
    return SafeArea(child:
    Scaffold(
      body: Column(
        children: [
          Container(
            height: 42.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.9),
            ),
            child: Row( mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(tr.translate("premium"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
                //Spacer(),
              ],
            ),
          ),
          Container(
            height: 480.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.2),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: Column( mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(tr.translate("premiumtext"),
                      maxLines: 18, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black45, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),)),
                  SizedBox(height: 10.h,),
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tr.translate("manualinfo"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),)),
                      Icon(Icons.info, size: ScreenUtil().setSp(22),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          Text("${tr.translate("subonly")} ${CommonData.prices.firstWhere((element) => element.type == "premium").price}€ ${tr.translate("formonth")}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),)),
          Container(
            height: 70.h,
            width: 300.w,
            child: Text(restaurant.premium == false && restaurant.premiumtime != null? "${tr.translate("subcancel")} ${Functions.formatDate(restaurant.premiumtime.substring(0,10))}" : "", maxLines: 2, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black45, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
          ),
          GestureDetector(
            onTap: () async{
              //Loading, coger precio en db, sistema tarjeta
              if(restaurant.premium){
                  bool sure = await Alerts.confirmation(tr.translate("surecancelsub"), context);
                  if(sure){
                    await InAppPurchasesService().cancelSubscription(restaurant);
                  }
              }
              else if(restaurant.premiumtime == null){
                //Check email, guardar customer y payment
                List<String> result = await InAppPurchasesService().createPaymentMethodCard(context, 1500, "4242424242424242", "cardHolderName", "777", "11/24", "juantg1994@gmail.com", true, restaurant);
                if(result != null){
                  await InAppPurchasesService().deliverSubscription(restaurant, result[0], result[1], result[2]);
                }
              }
              else{
                List<String> result = await InAppPurchasesService().createPaymentMethodCard(context, 1500, "4242424242424242", "cardHolderName", "777", "11/24", "juantg1994@gmail.com", false, restaurant);
                if(result != null){
                  await InAppPurchasesService().deliverSubscription(restaurant, result[1], result[2], result[3]);
                }
              }
              setState(() {
              });
            },
            child: Container(
              width: 200.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: restaurant.premium == true? Color.fromRGBO(255, 110, 117, 0.7) : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(1, 1), // changes position of shadow
                ),],
              ),
              child: restaurant.premium == false? Center(child: Text(tr.translate("sub"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.greenAccent, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),))):
              Center(child: Text(tr.translate("cancel"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),)))
            ),
          ),
        ],
      ),
    ));
  }
}
