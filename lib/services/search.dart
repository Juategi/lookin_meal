import 'dart:convert';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/screens/stars/parameters.dart';
import 'package:lookinmeal/shared/strings.dart';

class SearchService{

  Future<List<Restaurant>> query(double latitude, double longitude, String locality, String query, bool isRestaurant) async {
    query = "%" + query + "%";
    print(query);
    if(isRestaurant){
      var response = await http.get(
          "${StaticStrings.api}/search",
          headers: {"query": query, "locality":locality.toUpperCase() ,"latitude": latitude.toString(), "longitude": longitude.toString(), "valoration": Parameters.valoration.toString(), "types":Parameters.types.toString().replaceAll("[", "{").replaceAll("]", "}")});
      return _parseResponseRestaurant(response);
    }
    else{

    }
  }

  Future<List<Restaurant>> _parseResponseRestaurant(var response) async{
    List<Restaurant> restaurants = List<Restaurant>();
    List<dynamic> result = json.decode(response.body);
    print(response.body);
    Map<String, List<int>> schedule;
    for (dynamic element in result) {
      schedule = {
        '1': new List<int>(),
        '2': new List<int>(),
        '3': new List<int>(),
        '4': new List<int>(),
        '5': new List<int>(),
        '6': new List<int>(),
        '0': new List<int>()
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