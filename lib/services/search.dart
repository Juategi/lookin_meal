import 'dart:convert';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/strings.dart';

class SearchService{

  Future<List<Restaurant>> query(double latitude, double longitude, double maxDistance, int offset, List<String> types, String query, String searchType) async {
    //transformar 'platero:* &utopi:* &fo:*'
    List aux = query.split(" ");
    for(int i = 0; i < aux.length; i++){
      aux[i] = aux[i] + ":*";
      if(i != 0)
        aux[i] = "&" + aux[i];
    }
    query = aux.join(" ");
    for(int i = 0; i < types.length; i++){
      types[i] = "'" + types[i] + "'";
      if(types[i].split(" ").length > 1){
        types[i] = '"' + types[i] + '"';
      }
    }
    String finalTypes = types.toString().replaceAll("[", "{").replaceAll("]", "}");
    print(finalTypes);
    var response = await http.get(
        "${StaticStrings.api}/search",
        headers: {"query": query, "distance" : maxDistance.toString(), "latitude": latitude.toString(), "longitude": longitude.toString(), "valoration": searchType, "offset" :offset.toString(), "types":finalTypes});
    print(response.body);
    return DBService().parseResponse(response);
  }

  /*Future<Map<MenuEntry, Restaurant>> queryEntry(double latitude, double longitude, double maxDistance, int offset, List<String> types, String query, String searchType) async{
    query = "%" + query + "%";
    var response = await http.get(
        "${StaticStrings.api}/searchentry",
        headers: {"query": query, "maxDistance" : maxDistance.toString(), "latitude": latitude.toString(), "longitude": longitude.toString(), "valoration": searchType, "offset" :offset.toString(), "types":types.toString().replaceAll("[", "{").replaceAll("]", "}")});
    return DBService().parseResponseEntry(response);
  }*/

  Future<Map<MenuEntry, Restaurant>> _parseResponseEntry(var response) async {
    Map<MenuEntry, Restaurant> map = Map<MenuEntry, Restaurant>();
    List<dynamic> result = json.decode(response.body);
    Map<String, List<String>> schedule;
    for (dynamic element in result) {
      Restaurant restaurant = Pool.getRestaurant(
          element['restaurant_id'].toString());
      if (restaurant != null) {
        MenuEntry entry;
        for (MenuEntry e in restaurant.menu) {
          if (e.id == element['entry_id'].toString()) {
            entry = e;
            break;
          }
        }
        map[entry] = restaurant;
      }
      else {
        schedule = {
          '1': new List<String>(),
          '2': new List<String>(),
          '3': new List<String>(),
          '4': new List<String>(),
          '5': new List<String>(),
          '6': new List<String>(),
          '0': new List<String>()
        };
        if (element['schedule'] != null) {
          dynamic result = json.decode(element['schedule'].toString()
              .replaceAll("0:", '"0":')
              .replaceAll("1:", '"1":')
              .replaceAll("2:", '"2":')
              .replaceAll("3:", '"3":')
              .replaceAll("4:", '"4":')
              .replaceAll("5:", '"5":')
              .replaceAll("6:", '"6":')
          );
          for (int i = 0; i < 7; i++) {
            for (dynamic hour in result[i.toString()].toList()) {
              schedule[i.toString()].add(hour.toString());
            }
          }
        }
        Restaurant restaurant = Restaurant(
          restaurant_id: element['restaurant_id'].toString(),
          ta_id: element['ta_id'].toString(),
          name: element['name'],
          phone: element['phone'],
          email: element['email'],
          website: element['website'],
          webUrl: element['weburl'],
          address: element['address'],
          city: element['city'],
          country: element['country'],
          latitude: element['latitude'],
          longitude: element['longitude'],
          distance: double.parse(element['distance'].toStringAsFixed(2)),
          rating: double.parse(element['rating'].toString()),
          numrevta: element['numrevta'],
          images: element['images'] == null ? null : List<String>.from(
              element['images']),
          types: element['types'] == null ? null : List<String>.from(
              element['types']),
          schedule: schedule,
          currency: element['currency'],
          sections: element['sections'] == null ? null : List<String>.from(
              element['sections']),
          dailymenu: element['dailymenu'] == null ? null : List<String>.from(
              element['dailymenu']),
          delivery: element['delivery'] == null ? null : List<String>.from(
              element['delivery']),
          //menu: await getMenu(element['restaurant_id'].toString())
        );
        MenuEntry entry;
        for (MenuEntry e in restaurant.menu) {
          if (e.id == element['entry_id'].toString()) {
            entry = e;
            break;
          }
        }
        map[entry] = restaurant;
        Pool.addRestaurant(restaurant);
      }
      return map;
    }

    Future<List<Restaurant>> _parseResponseRestaurant(var response) async {
      List<Restaurant> restaurants = List<Restaurant>();
      List<dynamic> result = json.decode(response.body);
      print(response.body);
      Map<String, List<String>> schedule;
      for (dynamic element in result) {
        schedule = {
          '1': new List<String>(),
          '2': new List<String>(),
          '3': new List<String>(),
          '4': new List<String>(),
          '5': new List<String>(),
          '6': new List<String>(),
          '0': new List<String>()
        };
        if (element['schedule'] != null) {
          dynamic result = json.decode(element['schedule'].toString()
              .replaceAll("0:", '"0":')
              .replaceAll("1:", '"1":')
              .replaceAll("2:", '"2":')
              .replaceAll("3:", '"3":')
              .replaceAll("4:", '"4":')
              .replaceAll("5:", '"5":')
              .replaceAll("6:", '"6":')
          );
          for (int i = 0; i < 7; i++) {
            for (dynamic hour in result[i.toString()].toList()) {
              schedule[i.toString()].add(hour);
            }
          }
        }
        Restaurant restaurant = Restaurant(
          restaurant_id: element['restaurant_id'].toString(),
          ta_id: element['ta_id'].toString(),
          name: element['name'],
          phone: element['phone'],
          email: element['email'],
          website: element['website'],
          webUrl: element['weburl'],
          address: element['address'],
          city: element['city'],
          country: element['country'],
          latitude: element['latitude'],
          longitude: element['longitude'],
          distance: double.parse(element['distance'].toStringAsFixed(2)),
          rating: double.parse(element['rating'].toString()),
          numrevta: element['numrevta'],
          images: element['images'] == null ? null : List<String>.from(
              element['images']),
          types: element['types'] == null ? null : List<String>.from(
              element['types']),
          schedule: schedule,
          currency: element['currency'],
          sections: element['sections'] == null ? null : List<String>.from(
              element['sections']),
          //menu: await getMenu(element['restaurant_id'].toString())
        );
        restaurants.add(restaurant);
      }
      print("Number of restaurants : ${restaurants.length}");
      return restaurants;
    }
  }
}