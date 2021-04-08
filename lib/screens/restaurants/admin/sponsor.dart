import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';

class Sponsor extends StatefulWidget {
  @override
  _SponsorState createState() => _SponsorState();
}

class _SponsorState extends State<Sponsor> {
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight,
        width: CommonData.screenWidth,
        allowFontScaling: true);
    restaurant = ModalRoute
        .of(context)
        .settings
        .arguments;
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Sponsor", maxLines: 1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.niramit(textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: .3,
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(24),),)),
                //Spacer(),
              ],
            ),
          ),
          Container(
            height: 360.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.2),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "Aumenta las visitas a tu local uniendote a nuestro programa de patrocinados, compra un pack de visitas y aparecerás al principio de las búsquedas y el feed de los usuarios. Tu saldo de visitas solo se restará si el usuario entra al perfil de tu local y nunca caducan. ¿A que esperas? Da una publicidad a tu local como nunca antes y a un precio excepcional!",
                      maxLines: 15,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.niramit(textStyle: TextStyle(
                        color: Colors.black45,
                        letterSpacing: .3,
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(20),),)),
                  SizedBox(height: 25.h,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Mas información en el manual  ", maxLines: 1,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.niramit(textStyle: TextStyle(
                            color: Colors.black,
                            letterSpacing: .3,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(20),),)),
                      Icon(Icons.info, size: ScreenUtil().setSp(22),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h,),
          Text("Número de visitas restantes contratadas:", maxLines: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.niramit(textStyle: TextStyle(
                color: Colors.black45,
                letterSpacing: .3,
                fontWeight: FontWeight.w600,
                fontSize: ScreenUtil().setSp(18),),)),
          SizedBox(height: 5.h,),
          Text(restaurant.clicks.toString(), maxLines: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.niramit(textStyle: TextStyle(
                color: Colors.black,
                letterSpacing: .3,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(22),),)),
          SizedBox(height: 10.h,),
          Text("Compra un nuevo pack:", maxLines: 1,
              textAlign: TextAlign.start,
              style: GoogleFonts.niramit(textStyle: TextStyle(
                color: Colors.black,
                letterSpacing: .3,
                fontWeight: FontWeight.normal,
                fontSize: ScreenUtil().setSp(18),),)),
          SizedBox(height: 10.h,),
          Column(
            children: CommonData.prices.where((element) => element.type == "click").toList().map((price) =>
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: GestureDetector(
                    onTap: () async{
                      String today = DateTime.now().toString().substring(0,10);
                      if(restaurant.clicks == 0) {
                        try{
                          await DBServicePayment.dbServicePayment.createSponsor(
                              restaurant.restaurant_id);
                        }catch(e){
                          print(e);
                        }
                      }
                      await DBServicePayment.dbServicePayment.updateSponsor(restaurant.restaurant_id, price.quantity);
                      DBServicePayment.dbServicePayment.createPayment(Payment(
                        restaurant_id: restaurant.restaurant_id,
                        service: "clicks",
                        paymentdate: today,
                        price: price.price,
                        user_id: DBServiceUser.userF.uid,
                        description: "Sponsor visits for " + restaurant.name,
                      ));
                      restaurant.clicks += price.quantity;
                      setState(() {
                      });
                    },
                    child: Container(
                      width: 345.w,
                      height: 50.h,
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
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${price.quantity} visitas", maxLines: 1,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.niramit(textStyle: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(20),),)),
                            Text("${price.price.toString().substring(0, price.price.toString().length -2)} €", maxLines: 1,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.niramit(textStyle: TextStyle(
                                  color: Color.fromRGBO(255, 110, 117, 0.7),
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.normal,
                                  fontSize: ScreenUtil().setSp(20),),)),
                            Text("(${price.price*100/price.quantity} cents/visita)", maxLines: 1,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.niramit(textStyle: TextStyle(
                                  color: Colors.black45,
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.normal,
                                  fontSize: ScreenUtil().setSp(15),),)),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ).toList(),
          )
        ],
      ),
    ));
  }
}
