import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/models/code.dart';
import 'package:lookinmeal/models/reservation.dart';
import 'package:lookinmeal/models/table.dart';
import 'package:lookinmeal/shared/strings.dart';

class DBServiceReservation{

  static final DBServiceReservation dbServiceReservation = DBServiceReservation();


  //TABLES


  Future<String> createTable(RestaurantTable table) async{
    Map body = {
      "restaurant_id": table.restaurant_id,
      "capmax" : table.capmax.toString(),
      "capmin" : table.capmin.toString(),
      "amount": table.amount.toString()
    };
    var response = await http.post(
        "${StaticStrings.api}/table", body: body);
    List<dynamic> result = json.decode(response.body);
    print("table created" + result.first["table_id"].toString());
    return result.first["table_id"].toString();
  }

  Future<List<RestaurantTable>> getTables(String restaurant_id) async {
    List<RestaurantTable> tables = [];
    var response = await http.get(
        "${StaticStrings.api}/tables",
        headers: {"restaurant_id":restaurant_id});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      RestaurantTable table = RestaurantTable(
        table_id: element['table_id'].toString(),
        restaurant_id: element['restaurant_id'].toString(),
        amount: element['amount'],
        capmax: element['capmax'],
        capmin: element['capmin'],
        edited: false,
      );
      tables.add(table);
    }
    return tables;
  }

  Future updateTable(RestaurantTable table) async{
    Map body = {
      "id": table.table_id,
      "capmax" : table.capmax.toString(),
      "capmin" : table.capmin.toString(),
      "amount": table.amount.toString()
    };
    var response = await http.put(
        "${StaticStrings.api}/table", body: body);
    print(response.body);
  }

  Future deleteTable(String table_id) async{
    var response = await http.delete(
        "${StaticStrings.api}/table", headers: {"id" : table_id});
    print(response.body);
  }

  //RESERVATIONS


  Future createReservation(Reservation reservation) async{
    Map body = {
      "restaurant_id": reservation.restaurant_id,
      "user_id" : reservation.user_id,
      "table_id": reservation.table_id,
      "people": reservation.people.toString(),
      "reservationdate" : reservation.reservationdate,
      "reservationtime": reservation.reservationtime
    };
    var response = await http.post(
        "${StaticStrings.api}/reservation", body: body);
    print(response.body);
  }

  Future<List<Reservation>> getReservationsDay(String restaurant_id, String reservationdate) async {
    List<Reservation> reservations = [];
    var response = await http.get(
        "${StaticStrings.api}/reservationsday",
        headers: {"restaurant_id":restaurant_id, "reservationdate" : reservationdate});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      Reservation reservation = Reservation(
        table_id: element['table_id'].toString(),
        restaurant_id: element['restaurant_id'].toString(),
        people: element['people'],
        reservationdate: element['reservationdate'],
        reservationtime: element['reservationtime'],
        user_id: element['user_id'],
        username: element['name']
      );
      reservations.add(reservation);
    }
    return reservations;
  }

  Future<List<Reservation>> getReservationsUser(String user_id, String reservationdate) async {
    List<Reservation> reservations = [];
    var response = await http.get(
        "${StaticStrings.api}/reservationsuser",
        headers: {"user_id": user_id, "reservationdate" : reservationdate});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      Reservation reservation = Reservation(
        table_id: element['table_id'].toString(),
        restaurant_id: element['restaurant_id'].toString(),
        people: element['people'],
        reservationdate: DateTime.parse(element['reservationdate']).add(Duration(days: 1)).toString(),
        reservationtime: element['reservationtime'],
        user_id: element['user_id'],
        username: element['name'],
        resturant_name: element['restaurant_name']
      );
      reservations.add(reservation);
    }
    return reservations;
  }

  Future deleteReservation(String table_id, String reservationdate, String reservationtime) async{
    var response = await http.delete(
        "${StaticStrings.api}/reservation", headers: {"table_id" : table_id, "reservationdate" : reservationdate, "reservationtime" : reservationtime});
    print(response.body);
  }

  //CODES


  Future createCode(Code code) async{
    Map body = {
      "restaurant_id": code.restaurant_id,
      "code_id" : code.code_id,
      "link" : code.link
    };
    var response = await http.post(
        "${StaticStrings.api}/codes", body: body);
    print(response.body);
  }

  Future<List<Code>> getCodes(String restaurant_id) async {
    List<Code> codes = [];
    var response = await http.get(
        "${StaticStrings.api}/codes",
        headers: {"restaurant_id":restaurant_id});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      Code code = Code(
          restaurant_id: element['restaurant_id'].toString(),
          code_id: element['code_id'].toString(),
          link: element['link'].toString()
      );
      codes.add(code);
    }
    return codes;
  }

  Future deleteCode(String code_id, String restaurant_id) async{
    var response = await http.delete(
        "${StaticStrings.api}/codes", headers: {"restaurant_id" : restaurant_id, "code_id" : code_id});
    print(response.body);
  }

  //EXCLUDED DAYS

  Future addExcluded(String excludeddate, String restaurant_id) async{
    Map body = {
      "restaurant_id": restaurant_id,
      "excludeddate" : excludeddate,
    };
    var response = await http.post(
        "${StaticStrings.api}/excluded", body: body);
    print(response.body);
  }


  Future<List<String>> getExcluded(String restaurant_id) async {
    List<String> days = [];
    var response = await http.get(
        "${StaticStrings.api}/excluded",
        headers: {"restaurant_id": restaurant_id,});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      days.add(DateTime.parse(element['excludeddate']).add(Duration(days: 1)).toString().substring(0,10),);
    }
    return days;
  }

  Future deleteExcluded(String excludeddate, String restaurant_id) async{
    var response = await http.delete(
        "${StaticStrings.api}/excluded", headers: {"restaurant_id": restaurant_id, "excludeddate" : excludeddate,});
    print(response.body);
  }

}