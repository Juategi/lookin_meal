import 'package:http/http.dart' as http;
import 'package:lookinmeal/models/payment.dart';
import 'package:lookinmeal/models/price.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'dart:convert';

class DBServiceStatistic{
  static final DBServiceStatistic dbServiceStatistic = DBServiceStatistic();

  Future<List<String>> getVisits(String restaurant_id) async {
    List<String> visits = [];
    var response = await http.get(
        Uri.http(StaticStrings.api, "/visits"),
        headers: {"restaurant_id":restaurant_id});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      visits.add(element['visit']);
    }
    return visits;
  }

  Future addVisit(String restaurant_id) async{
    var response = await http.post(
        Uri.http(StaticStrings.api, "/visits"), body: {"user_id" : DBServiceUser.userF.uid, "restaurant_id":restaurant_id});
    print(response.body);
  }

  Future<List<String>> getRates(String restaurant_id) async {
    List<String> rates = [];
    var response = await http.get(
        Uri.http(StaticStrings.api, "/rates"),
        headers: {"restaurant_id":restaurant_id});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      rates.add(element['rate']);
    }
    return rates;
  }

  Future addRate(String restaurant_id, String entry_id, bool withcomment) async{
    var response = await http.post(
        Uri.http(StaticStrings.api, "/rates"), body: {"user_id" : DBServiceUser.userF.uid, "restaurant_id":restaurant_id, "entry_id" : entry_id, "withcomment" : withcomment.toString()});
    print(response.body);
  }

}