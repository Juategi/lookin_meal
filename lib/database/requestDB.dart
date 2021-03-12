import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'entryDB.dart';

class DBServiceRequest{

  static final DBServiceRequest dbServiceRequest = DBServiceRequest();

  Future sendConfirmationCode(int localcode, String email) async{
    Map body = {
      "email" : email,
      "localcode" : localcode.toString(),
    };
    var response = await http.post(
        "${StaticStrings.api}/emailsend", body: body);
    print(response.body);
  }

  Future reSendConfirmationCode(int localcode, String email) async{
    Map body = {
      "email" : email,
      "localcode" : localcode.toString(),
    };
    var response = await http.put(
        "${StaticStrings.api}/emailresend", body: body);
    print(response.body);
  }

  Future<bool> confirmCodes(int code, int localcode) async{
    Map body = {
      "code" : code.toString(),
      "localcode" : localcode.toString(),
    };
    var response = await http.post(
        "${StaticStrings.api}/confirmcodes", body: body);
    print(response.body);
    if(response.body == 'match')
      return true;
    if(response.body == 'error')
      return false;
  }

  Future<bool> createRequest(String restaurant_id, String user_id, String relation, String confirmation, String idfront, String idback) async{
    Map body = {
      "restaurant_id" : restaurant_id,
      "user_id" : user_id,
      "relation" : relation,
      "confirmation" : confirmation,
      "idfront" : idfront,
      "idback" : idback
    };
    try {
      var response = await http.post(
          "${StaticStrings.api}/request", body: body);
      print(response.body);
      if(response.body == 'Request created')
        return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> createRequestRestaurant(String user_id, String relation, String name, String phone, String website, String address, String email, String city, String country, double latitude, double longitude, String image, List<String> types, String currency) async{
    Map body = {
      "user_id" : user_id,
      "relation" : relation,
      "name": name,
      "phone": phone ?? "",
      "website": website ?? "",
      "address": address,
      "email": email ?? "",
      "city": city.trim().toUpperCase(),
      "country": country,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "image" : image ?? "",
      "types": types == null? "{}" : types.toString().replaceAll("[", "{").replaceAll("]", "}"),
      "currency": currency,
    };
    var response = await http.post("${StaticStrings.api}/requestrestaurant", body: body);
    print(response.body);
  }
}