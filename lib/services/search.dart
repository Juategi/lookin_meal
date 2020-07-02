import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/strings.dart';

class SearchService{

  Future<List<Restaurant>> query(double latitude, double longitude, String locality, String query) async {
    query = "%" + query + "%";
    print(query);
    var response = await http.get(
        "${StaticStrings.api}/search",
        headers: {"query": query, "locality":locality.toUpperCase() ,"latitude": latitude.toString(), "longitude": longitude.toString()});
    return DBService().parseResponse(response);
  }

}