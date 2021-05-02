/*import 'package:flutter/material.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:modal_progress_hud/modal_progress_hud.dart';

class StripeService {
  void initStripe() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: 'pk_test_51IhExDASgVZXSVMB9wXSrT0sZTYEnGDm457t9QzpFPLDYXCKnyDWLydMmvf5cbFbTUV4IOhZ381pEVdromgRnJLK006ctClKs9',
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  Future<void> createPaymentMethodCard(BuildContext context, double amount, String cardNumber, String cardHolderName, String cvvCode, String expiryDate) async {
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
    });  paymentMethod != null
        ? processPaymentAsDirectCharge(context, paymentMethod, amount)
        : Alerts.dialog("It is not possible to pay with this card.", context);
  }

  Future<void> processPaymentAsDirectCharge(BuildContext context, PaymentMethod paymentMethod, double amount) async {
    PaymentIntentResult paymentIntent;
    var response = await http.post(
        Uri.http(StaticStrings.api, "/stripe", body: {"amount":1000.toString()});
    Map aux = json.decode(response.body);
    String _paymentIntentClientSecret = aux['client_secret'];
    await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: _paymentIntentClientSecret,
        paymentMethodId: paymentMethod.id,
      ),
    ).then((paymentIntent) {
        paymentIntent = paymentIntent;
        print(paymentIntent.status);
      });
    if(paymentIntent.status == "succeeded")
      StripePayment.completeNativePayRequest();
    else
      StripePayment.cancelNativePayRequest();
  }

}

 */