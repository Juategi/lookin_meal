import 'dart:convert';
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

  /*Future<Map<MenuEntry, Restaurant>> queryEntry(double latitude, double longitude, double maxDistance, int offset, List<String> types, String query, String searchType) async{
    query = "%" + query + "%";
    var response = await http.get(
        "${StaticStrings.api}/searchentry",
        headers: {"query": query, "maxDistance" : maxDistance.toString(), "latitude": latitude.toString(), "longitude": longitude.toString(), "valoration": searchType, "offset" :offset.toString(), "types":types.toString().replaceAll("[", "{").replaceAll("]", "}")});
    return DBService().parseResponseEntry(response);
  }*/


}