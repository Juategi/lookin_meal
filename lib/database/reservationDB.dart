import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/models/reservation.dart';
import 'package:lookinmeal/models/table.dart';
import 'package:lookinmeal/shared/strings.dart';

class DBServiceReservation{

  static final DBServiceReservation dbServiceReservation = DBServiceReservation();


  //TABLES


  Future<String> createTable(Table table) async{
    Map body = {
      "restaurant_id": table.restaurant_id,
      "capmax" : table.capmax.toString(),
      "capmin" : table.capmin.toString(),
      "amount": table.amount.toString()
    };
    var response = await http.post(
        "${StaticStrings.api}/table", body: body);
    List<dynamic> result = json.decode(response.body);
    return result.first["table_id"].toString();
  }

  Future<List<Table>> getTables(String restaurant_id) async {
    List<Table> tables = [];
    var response = await http.get(
        "${StaticStrings.api}/tables",
        headers: {"restaurant_id":restaurant_id});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      Table table = Table(
        table_id: element['table_id'].toString(),
        restaurant_id: element['restaurant_id'].toString(),
        amount: element['amount'],
        capmax: element['capmax'],
        capmin: element['capmin'],
      );
      tables.add(table);
    }
    return tables;
  }

  Future updateTable(Table table) async{
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
      "people": reservation.people,
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
        headers: {"restaurant_id":restaurant_id, "reservationsdate" : reservationdate});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      Reservation reservation = Reservation(
        table_id: element['table_id'].toString(),
        restaurant_id: element['restaurant_id'].toString(),
        people: element['people'],
        reservationdate: element['reservationdate'],
        reservationtime: element['reservationtime'],
        user_id: element['user_id'],
      );
      reservations.add(reservation);
    }
    return reservations;
  }

  Future<List<Reservation>> getReservationsUser(String user_id, String reservationdate) async {
    List<Reservation> reservations = [];
    var response = await http.get(
        "${StaticStrings.api}/reservationsuser",
        headers: {"user_id": user_id, "reservationsdate" : reservationdate});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      Reservation reservation = Reservation(
        table_id: element['table_id'].toString(),
        restaurant_id: element['restaurant_id'].toString(),
        people: element['people'],
        reservationdate: element['reservationdate'],
        reservationtime: element['reservationtime'],
        user_id: element['user_id'],
      );
      reservations.add(reservation);
    }
    return reservations;
  }

  Future deleteReservation(String table_id, String reservationdate, String reservationtime) async{
    var response = await http.delete(
        "${StaticStrings.api}/reservation", headers: {"table_id" : table_id, "reservationsdate" : reservationdate, "reservationstime" : reservationtime});
    print(response.body);
  }

}