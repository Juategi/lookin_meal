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
    var response = await http.get(Uri.http(StaticStrings.api, "/prices"), headers: {});
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
        Uri.http(StaticStrings.api, "/sponsor"),
        headers: {"restaurant_id":restaurant.restaurant_id});
    List<dynamic> result = json.decode(response.body);
    if(result.length > 0)
      restaurant.clicks = result.first['clicks'];
    else
      restaurant.clicks = 0;
  }

  Future updateSponsor(String restaurant_id, int clicks) async{
    var response = await http.put(
        Uri.http(StaticStrings.api, "/sponsor"), body: {"restaurant_id":restaurant_id, "clicks": clicks.toString()});
    print(response.body);
  }

  Future createSponsor(String restaurant_id) async{
    var response = await http.post(
        Uri.http(StaticStrings.api, "/sponsor"), body: {"restaurant_id":restaurant_id});
    print(response.body);
  }

  Future getPremium(Restaurant restaurant) async {
    var response = await http.get(
        Uri.http(StaticStrings.api, "/premium"),
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
        Uri.http(StaticStrings.api, "/premium"), body: {"restaurant_id":restaurant_id, "date" : date, "premium" : premium.toString()});
    print(response.body);
  }

  Future createPremium(String restaurant_id, String date, String email) async{
    var response = await http.post(
        Uri.http(StaticStrings.api, "/premium"), body: {"restaurant_id":restaurant_id, "date" : date, "email" : email});
    print(response.body);
  }

  Future<List<Payment>> getPayments(String restaurant_id) async {
    List<Payment> payments = [];
    var response = await http.get(
        Uri.http(StaticStrings.api, "/payment"),
        headers: {"restaurant_id":restaurant_id});
    List<dynamic> result = json.decode(response.body);
    for (var element in result) {
      payments.add(Payment(
          id: element['id'].toString(),
          price: double.parse(element['price'].toString()),
          restaurant_id: element['restaurant_id'].toString(),
          user_id: element['user_id'],
          paymentdate: DateTime.parse(element['paymentdate']).add(Duration(days: 1)).toString(),
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
        Uri.http(StaticStrings.api, "/payment"), body: body);
    print(response.body);
  }

}