import 'dart:convert';
import 'package:lookinmeal/models/dish_query.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/strings.dart';

class SearchService{

  Future<List<Restaurant>> query(double latitude, double longitude, double maxDistance, int offset, List<String> types, String query, String searchType) async {
    //transformar 'platero:* &utopi:* &fo:*'
    String originalQuery = query;
    List aux = query.split(" ");
    for(int i = 0; i < aux.length; i++){
      aux[i] = aux[i] + ":*";
      if(i != 0)
        aux[i] = "&" + aux[i];
    }
    query = aux.join(" ");
    List<String> newTypes = Functions.copyList(types);
    for(int i = 0; i < newTypes.length; i++){
      newTypes[i] = "'" + newTypes[i] + "'";
      if(newTypes[i].split(" ").length > 1){
        newTypes[i] = '"' + newTypes[i] + '"';
      }
    }
    String finalTypes = newTypes.toString().replaceAll("[", "{").replaceAll("]", "}");
    var response = await http.get(
        "${StaticStrings.api}/search",
        headers: {"query": query, "distance" : maxDistance.toString(), "latitude": latitude.toString(), "longitude": longitude.toString(), "valoration": searchType, "offset" :offset.toString(), "types":finalTypes});
    List<Restaurant> parsed = await DBService().parseResponse(response);
    if(parsed.length == 0 || (parsed.length < 10 && offset < 20)){
      //transformar 'platero:* |utopi:* |fo:*'
      query = originalQuery;
      List aux = query.split(" ");
      for(int i = 0; i < aux.length; i++){
        aux[i] = aux[i] + ":*";
        if(i != 0)
          aux[i] = "|" + aux[i];
      }
      query = aux.join(" ");
      var response = await http.get(
          "${StaticStrings.api}/search",
          headers: {"query": query, "distance" : maxDistance.toString(), "latitude": latitude.toString(), "longitude": longitude.toString(), "valoration": searchType, "offset" :offset.toString(), "types":finalTypes});
      for(Restaurant restaurant in await DBService().parseResponse(response)){
        if(!parsed.contains(restaurant))
          parsed.add(restaurant);
      }
    }
    return parsed;
  }

  Future<Map<Restaurant, List<String>>> queryEntry(double latitude, double longitude, String valoration, List<DishQuery> queries) async{
    List<String> allergensString = [];
    List<String> textQueries = [];
    //transformar 'platero:* &utopi:* &fo:*'
    for(DishQuery query in queries){
      List aux = query.query.trim().split(" ");
      for(int i = 0; i < aux.length; i++){
        aux[i] = aux[i] + ":*";
        if(i != 0)
          aux[i] = "&" + aux[i];
      }
      textQueries.add(aux.join(" "));
      List<String> newAllergens = Functions.copyList(query.allergens);
      for(int i = 0; i < newAllergens.length; i++){
        newAllergens[i] = "'" + newAllergens[i] + "'";
        if(newAllergens[i].split(" ").length > 1){
          newAllergens[i] = '"' + newAllergens[i] + '"';
        }
      }
      allergensString.add(newAllergens.toString().replaceAll("[", "{").replaceAll("]", "}"));
    }
    var response;
    Map<Restaurant, List<String>> finalMap;
    if(queries.length == 3){
      response = await http.get(
          "${StaticStrings.api}/searchentry",
          headers: {
            "latitude": latitude.toString(), "longitude": longitude.toString(), "valoration": valoration,
            "query1": textQueries.first, "query2": textQueries.first[1], "query3": textQueries.last,
            "rating1": queries.first.rating.toString(), "rating2": queries[1].rating.toString(), "rating3": queries.last.rating.toString(),
            "price1": queries.first.price.toString(), "price2": queries[1].price.toString(), "price3": queries.last.price.toString(),
            "allergens1": allergensString.first, "allergens2": allergensString[1], "allergens3": allergensString.last
          });
      print(response.body);
      List<Restaurant> parsed = await DBService().parseResponse(response);
      List<dynamic> result = json.decode(response.body);
      finalMap = {};
      for(int i = 0; i < result.length; i++){
        var element = result[i];
        List<String> aux = [];
        aux.add(element['id1'].toString());
        aux.add(element['id2'].toString());
        aux.add(element['id3'].toString());
        finalMap[parsed[i]] = aux;
      }
    }
    else if(queries.length == 2){
      response = await http.get(
          "${StaticStrings.api}/searchentry",
          headers: {
            "latitude": latitude.toString(), "longitude": longitude.toString(), "valoration": valoration,
            "query1": textQueries.first, "query2": textQueries[1], "query3": "",
            "rating1": queries.first.rating.toString(), "rating2": queries[1].rating.toString(), "rating3": "",
            "price1": queries.first.price.toString(), "price2": queries[1].price.toString(), "price3": "",
            "allergens1": allergensString.first, "allergens2": allergensString[1], "allergens3": ""
          });
      print(response.body);
      List<Restaurant> parsed = await DBService().parseResponse(response);
      List<dynamic> result = json.decode(response.body);
      finalMap = {};
      for(int i = 0; i < result.length; i++){
        var element = result[i];
        List<String> aux = [];
        aux.add(element['id1'].toString());
        aux.add(element['id2'].toString());
        finalMap[parsed[i]] = aux;
      }
    }
    else{
      response = await http.get(
          "${StaticStrings.api}/searchentry",
          headers: {
            "latitude": latitude.toString(), "longitude": longitude.toString(), "valoration": valoration,
            "query1": textQueries.first, "query2": "", "query3": "",
            "rating1": queries.first.rating.toString(), "rating2": "", "rating3": "",
            "price1": queries.first.price.toString(), "price2": "", "price3": "",
            "allergens1": allergensString.first, "allergens2": "", "allergens3": ""
          });
      print(response.body);
      List<Restaurant> parsed = await DBService().parseResponse(response);
      List<dynamic> result = json.decode(response.body);
      finalMap = {};
      for(int i = 0; i < result.length; i++){
        var element = result[i];
        List<String> aux = [];
        aux.add(element['id1'].toString());
        finalMap[parsed[i]] = aux;
      }
    }
    return finalMap;
  }
}