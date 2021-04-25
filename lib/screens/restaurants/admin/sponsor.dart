import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';

class Sponsor extends StatefulWidget {
  @override
  _SponsorState createState() => _SponsorState();
}

class _SponsorState extends State<Sponsor> {
  Restaurant restaurant;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
       // _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          //_handleError(purchaseDetails.error!);
          Alerts.dialog(purchaseDetails.error.message, context);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
           // _deliverProduct(purchaseDetails);
          } else {
            //_handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails product) async{
    final QueryPurchaseDetailsResponse response =
    await InAppPurchaseConnection.instance.queryPastPurchases();
    if (response.error != null) {
      // Handle the error.
    }
    for (PurchaseDetails purchase in response.pastPurchases) {
      // Verify the purchase following best practices for each underlying store.
      _verifyPurchase(purchase);
      // Deliver the purchase to the user in your app.
      //_deliverPurchase(purchase);
      if (purchase.pendingCompletePurchase) {
        // Mark that you've delivered the purchase. This is mandatory.
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }
  }

  @override
  void initState() {
    final Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("error in stream");
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

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
                      final bool available = await InAppPurchaseConnection.instance.isAvailable();
                      print(available);
                      if (available) {
                        const Set<String> _kIds = <String>{'visits100'};
                        final ProductDetailsResponse response =
                        await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
                        if (response.notFoundIDs.isNotEmpty) {
                          print("error no id");
                        }
                        List<ProductDetails> products = response.productDetails;
                        print(products);
                        final ProductDetails productDetails = products.first;
                        final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
                        InAppPurchaseConnection.instance.buyConsumable(purchaseParam: purchaseParam);
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
                      }
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
