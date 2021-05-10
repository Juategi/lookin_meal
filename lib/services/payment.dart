import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/price.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InAppPurchasesService{

  static Future initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("UDNbeRhooFwbsXgUbczLSKynlYDnrnQV");
    StripePayment.setOptions(StripeOptions(
        publishableKey: 'pk_test_51IhExDASgVZXSVMB9wXSrT0sZTYEnGDm457t9QzpFPLDYXCKnyDWLydMmvf5cbFbTUV4IOhZ381pEVdromgRnJLK006ctClKs9',
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  Future<bool> buyProduct(String id) async{
    try {
      Offerings offerings = await Purchases.getOfferings();
      Offering offering = offerings.getOffering(id);
      if (offering != null && offering.lifetime != null) {
        Product product = offering.lifetime.product;
        PurchaserInfo info = await Purchases.purchaseProduct(product.identifier, type: PurchaseType.inapp);
        print(product.title);
        print(info.entitlements.all[id].identifier);
        return true;
      }
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> createPaymentMethodCard(BuildContext context, int amount, String cardNumber, String cardHolderName, String cvvCode, String expiryDate, String email, bool init) async {
    StripePayment.setStripeAccount(null);
    PaymentMethod paymentMethod = PaymentMethod();
    final CreditCard testCard = CreditCard(
        number: cardNumber,
        expMonth: int.parse(expiryDate.substring(0,2)),
        expYear: int.parse(expiryDate.substring(3)),
        name: cardHolderName,
        cvc: cvvCode
    );
    paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: testCard,
      ),
    ).then((PaymentMethod paymentMethod) {
      return paymentMethod;
    }).catchError((e) {
      print('Errore Card: ${e.toString()}');
    });  if(paymentMethod != null)
          return await _processPaymentAsDirectCharge(context, paymentMethod, amount, email, init);
        else {
      Alerts.dialog("It is not possible to pay with this card.", context);
      return null;
    }
  }

  Future<String> _processPaymentAsDirectCharge(BuildContext context, PaymentMethod paymentMethod, int amount, String email, bool init) async {
    PaymentIntentResult _paymentIntent;
    var response = await http.post(
        Uri.http(StaticStrings.api, "/intent"), body: {"amount":amount.toString()});
        Map aux = json.decode(response.body);
    String _paymentIntentClientSecret = aux['client_secret'];
    await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: _paymentIntentClientSecret,
        paymentMethodId: paymentMethod.id,
      ),
    ).then((paymentIntent) {
      _paymentIntent = paymentIntent;
      print(paymentIntent.status);
      print(_paymentIntent.paymentIntentId);
    });
    if(_paymentIntent.status == "succeeded") {
      String subscriptionId;
      if(init){
        var response = await http.post(
            Uri.http(StaticStrings.api, "/customer"), body: {"email":email, "payment_intent_id" : _paymentIntent.paymentIntentId});
        Map aux = json.decode(response.body);
        String customerId = aux['customer'];
        print(customerId);
        response = await http.post(
            Uri.http(StaticStrings.api, "/subscription"), body: {"customerId":customerId, "payment_intent_id" : _paymentIntent.paymentIntentId});
        aux = json.decode(response.body);
        subscriptionId = aux['subscriptionId'];
        print(subscriptionId);
      }
      else{
        var response = await http.post(
            Uri.http(StaticStrings.api, "/customer"), body: {"email":email, "payment_intent_id" : _paymentIntent.paymentIntentId, "billing_cycle_anchor" : "-1"});
        Map aux = json.decode(response.body);
        String customerId = aux['customer'];
        print(customerId);
        response = await http.post(
            Uri.http(StaticStrings.api, "/subscription"), body: {"customerId":customerId, "payment_intent_id" : _paymentIntent.paymentIntentId, "billing_cycle_anchor" : "${DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch}"});
        aux = json.decode(response.body);
        print(new DateTime.fromMillisecondsSinceEpoch((DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch).toInt()));
        subscriptionId = aux['subscriptionId'];
        print(subscriptionId);
      }
      StripePayment.completeNativePayRequest();
      return subscriptionId;
    }
    else {
      StripePayment.cancelNativePayRequest();
      return null;
    }
  }

  Future cancelSubscription(Restaurant restaurant) async{
    var response = await http.get(
        Uri.http(StaticStrings.api, "/premium"),
        headers: {"restaurant_id": restaurant.restaurant_id});
    List<dynamic> result = json.decode(response.body);
    String subscriptionId  = result.first['subscriptionid'];
    response = await http.post(
        Uri.http(StaticStrings.api, "/cancel"), body: {"subscriptionId" : subscriptionId});
    Map aux = json.decode(response.body);
    print(aux);
    restaurant.premium = false;
  }

  /*
  void updateSubscription(String restaurant_id) async{
    var response = await http.get(
        Uri.http(StaticStrings.api, "/premium"),
        headers: {"restaurant_id": restaurant_id});
    List<dynamic> result = json.decode(response.body);
    String subscriptionId  = result.first['subscriptionid'];
    print(subscriptionId);
    var response2 = await http.put(
        Uri.http(StaticStrings.api, "/subscription"), body: {"subscriptionId" : subscriptionId});
    print(response2.body);
    Map aux = json.decode(response2.body);
  }

   */

  Future deliverSubscription(Restaurant restaurant, String subscriptionId) async{
    String today = DateTime.now().toString().substring(0,10);
    var response = await http.get(
        Uri.http(StaticStrings.api, "/premium"),
        headers: {"restaurant_id":restaurant.restaurant_id});
    List<dynamic> result = json.decode(response.body);
    if(result.length == 0){
      /*DBServicePayment.dbServicePayment.createPayment(Payment(
        restaurant_id: restaurant.restaurant_id,
        service: "premium",
        paymentdate: today,
        price: CommonData.prices.firstWhere((element) => element.type == "premium").price,
        user_id: DBServiceUser.userF.uid,
        description: "Premium suscription",
      ));*/
      DBServicePayment.dbServicePayment.createPremium(restaurant.restaurant_id, subscriptionId);
      restaurant.premium = true;
      restaurant.premiumtime = today;
    }
    else{
      /*DBServicePayment.dbServicePayment.createPayment(Payment(
        restaurant_id: restaurant.restaurant_id,
        service: "premium",
        paymentdate: today,
        price: CommonData.prices.firstWhere((element) => element.type == "premium").price,
        user_id: DBServiceUser.userF.uid,
        description: "Premium suscription",
      ));*/
      DBServicePayment.dbServicePayment.updatePremium(restaurant.restaurant_id, subscriptionId);
      restaurant.premium = true;
      restaurant.premiumtime = today;
    }
  }

  Future deliverProduct(Restaurant restaurant, Price actual) async{
    String today = DateTime.now().toString().substring(0,10);
    if(restaurant.clicks == 0) {
      try{
        await DBServicePayment.dbServicePayment.createSponsor(
            restaurant.restaurant_id);
      }catch(e){
        print(e);
      }
    }
    await DBServicePayment.dbServicePayment.updateSponsor(restaurant.restaurant_id, actual.quantity);
    DBServicePayment.dbServicePayment.createPayment(Payment(
      restaurant_id: restaurant.restaurant_id,
      service: "clicks",
      paymentdate: today,
      price: actual.price,
      user_id: DBServiceUser.userF.uid,
      description: "${actual.quantity} Sponsor visits " ,
    ));
    restaurant.clicks += actual.quantity;
  }

}