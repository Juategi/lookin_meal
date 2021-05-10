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
    if(result.length > 0) {
      String subscriptionId  = result.first['subscriptionid'];
      var response = await http.get(
          Uri.http(StaticStrings.api, "/subscription"), headers: {"subscriptionId" : subscriptionId});
      Map aux = json.decode(response.body);
      restaurant.subscriptionId = subscriptionId;
      restaurant.customerId = result.first['customerid'];
      restaurant.paymentId = result.first['paymentid'];
      print(result);
      aux = aux["subscription"];
      var current_period_start = new DateTime.fromMillisecondsSinceEpoch(aux["current_period_start"]*1000);
      var current_period_end = new DateTime.fromMillisecondsSinceEpoch(aux["current_period_end"]*1000);
      print(aux["status"]);
      if(aux["status"] != "canceled"){
        restaurant.premium = true;
        restaurant.premiumtime = current_period_end.toString();
      }
      else if(current_period_end.isAfter(DateTime.now())) {
        restaurant.premium = false;
        restaurant.premiumtime = current_period_end.toString();
      }
      else{
        restaurant.premium = false;
      }
    }
    else{
      restaurant.premium = false;
    }
    print(restaurant.premiumtime);
    print(restaurant.premium);
  }

  Future updatePremium(String restaurant_id, String subscriptionId, String paymentId) async{
    var response = await http.put(
        Uri.http(StaticStrings.api, "/premium"), body: {"restaurant_id":restaurant_id, "subscriptionId" : subscriptionId, "paymentId" : paymentId});
    print(response.body);
  }

  Future createPremium(String restaurant_id,  String subscriptionId, String customerId, String paymentId) async{
    var response = await http.post(
        Uri.http(StaticStrings.api, "/premium"), body: {"restaurant_id":restaurant_id, "subscriptionId" : subscriptionId, "customerId" : customerId, "paymentId" : paymentId});
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