import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';

class Premium extends StatefulWidget {
  @override
  _PremiumState createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {

  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {

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
                Text("Premium", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
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
                  Text("Suscríbete al sistema premium de locales para poder obtar a las funcionalidades mas avanzadas de FindEat en tu local:\n  •  Sistema de reserva de mesas.\n  •  Sistema de pedidos desde la app a través de códigos QR.\n  •  Estadísticas sobre tu local.\n\nLa suscripción se renueva automaticámente cada mes, pero puedes cancelarla siempre que quieras y cuando se termine tu periodo contratado no se te hará ningún cargo más.",
                      maxLines: 18, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black45, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),)),
                  SizedBox(height: 10.h,),
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Mas información en el manual  ", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),)),
                      Icon(Icons.info, size: ScreenUtil().setSp(22),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          Text("Suscríbete por solo ${CommonData.prices.firstWhere((element) => element.type == "premium").price}€ al mes", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),)),
          Container(
            height: 70.h,
            width: 300.w,
            child: Text(restaurant.premium == false && restaurant.premiumtime != null? "Suscripción cancelada, válida hasta el dia ${Functions.formatDate(restaurant.premiumtime)}" : "", maxLines: 2, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black45, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
          ),
          GestureDetector(
            onTap: (){
              String today = DateTime.now().toString().substring(0,10);
              if(restaurant.premiumtime == null){
                DBServicePayment.dbServicePayment.createPayment(Payment(
                  restaurant_id: restaurant.restaurant_id,
                  service: "premium",
                  paymentdate: today,
                  price: CommonData.prices.firstWhere((element) => element.type == "premium").price,
                  user_id: DBServiceUser.userF.uid,
                  description: "Premium suscription",
                ));
                DBServicePayment.dbServicePayment.createPremium(restaurant.restaurant_id, today);
                restaurant.premium = true;
                restaurant.premiumtime = today;
              }
              else if(restaurant.premium){
                DBServicePayment.dbServicePayment.updatePremium(restaurant.restaurant_id, restaurant.premiumtime, false);
                restaurant.premium = false;
              }
              else{
                DBServicePayment.dbServicePayment.updatePremium(restaurant.restaurant_id, restaurant.premiumtime, true);
                restaurant.premium = true;
              }
              setState(() {});
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
              child: restaurant.premium == false? Center(child: Text("Suscribirse", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.greenAccent, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),))):
              Center(child: Text("Cancelar", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),)))
            ),
          ),
        ],
      ),
    ));
  }
}
