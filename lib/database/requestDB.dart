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
}