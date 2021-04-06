import 'package:http/http.dart' as http;
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/price.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'dart:convert';

class DBServicePayment{
  static final DBServicePayment dbServicePayment = DBServicePayment();

  Future<List<Price>> getPrices() async {
    List<Price> prices = [];
    var response = await http.get(
        "${StaticStrings.api}/prices",
        headers: {});
    List<dynamic> result = json.decode(response.body);
    for (var element in result) {
      prices.add(Price(
          type: element['type'],
          price: double.parse(element['price'].toString()),
          quantity: element['quantity']
      ));
    }
    return prices;
  }

  Future getSponsor(Restaurant restaurant) async {
    var response = await http.get(
        "${StaticStrings.api}/sponsor",
        headers: {"restaurant_id":restaurant.restaurant_id});
    List<dynamic> result = json.decode(response.body);
    if(result.length > 0)
      restaurant.clicks = result.first['clicks'];
    else
      restaurant.clicks = 0;
  }

  Future updateSponsor(String restaurant_id) async{
    var response = await http.put(
        "${StaticStrings.api}/sponsor", body: {"restaurant_id":restaurant_id});
    print(response.body);
  }

  Future createSponsor(String restaurant_id) async{
    var response = await http.post(
        "${StaticStrings.api}/sponsor", body: {"restaurant_id":restaurant_id});
    print(response.body);
  }

  Future getPremium(Restaurant restaurant) async {
    var response = await http.get(
        "${StaticStrings.api}/premium",
        headers: {"restaurant_id":restaurant.restaurant_id});
    List<dynamic> result = json.decode(response.body);
    print(result);
    if(result.length > 0) {
      restaurant.premiumtime = result.first['premiumtime'].toString().substring(0,10);
      if(restaurant.premium = result.first['ispremium'] == null)
        restaurant.premium = false;
      else
        restaurant.premium = result.first['ispremium'];
    }
    else{
      restaurant.premium = false;
    }
  }

  Future updatePremium(String restaurant_id, String date, bool premium) async{
    var response = await http.put(
        "${StaticStrings.api}/premium", body: {"restaurant_id":restaurant_id, "date" : date, "premium" : premium.toString()});
    print(response.body);
  }

  Future createPremium(String restaurant_id, String date) async{
    var response = await http.post(
        "${StaticStrings.api}/premium", body: {"restaurant_id":restaurant_id, "date" : date});
    print(response.body);
  }

  Future<List<Payment>> getPayments(String restaurant_id) async {
    List<Payment> payments = [];
    var response = await http.get(
        "${StaticStrings.api}/payment",
        headers: {"restaurant_id":restaurant_id});
    List<dynamic> result = json.decode(response.body);
    for (var element in result) {
      payments.add(Payment(
          id: element['id'],
          price: element['price'],
          restaurant_id: element['restaurant_id'],
          user_id: element['user_id'],
          paymentdate: element['paymentdate'],
          service: element['service'],
          description: element['description']
      ));
    }
    return payments;
  }

  Future createPayment(Payment payment) async{
    Map body = {
      'restaurant_id': payment.restaurant_id,
      'user_id': payment.user_id,
      'paymentdate': payment.paymentdate,
      'price': payment.price.toString(),
      'service': payment.service,
      'description': payment.description
    };
    var response = await http.post(
        "${StaticStrings.api}/payment", body: body);
    print(response.body);
  }

}