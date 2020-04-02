import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';

class DBServiceN{

  //URL: https://lookinmeal-dcf41.firebaseapp.com
  //https://us-central1-lookinmeal-dcf41.cloudfunctions.net/app
  String uid;

  Future updateUserData(String email, String name, String picture, String service ) async {
   
  }

  Future updateUserImage(String picture,String uid) async {

  }


  Future updateUserFavorites(String id) async{

  }

  Future updateRestaurantData(String taId, String name, String phone, String website, String webUrl, String address, String email, String city, String country, double latitude,
      double longitude, double rating, int numberViews, List<String> images, List<String> types, Map<String,List<int>> schedule ) async{

    Map body = {
      "taid":taId ?? "",
      "name":name,
      "phone":phone ?? "",
      "website":website ?? "",
      "webUrl":webUrl ?? "",
      "address":address,
      "email":email ?? "",
      "city":city,
      "country":country,
      "latitude":latitude.toString(),
      "longitude":longitude.toString(),
      "rating":rating.toString() ?? "0.0",
      "numrevta":numberViews.toString()  ?? "0",
      "images":images.toString().replaceAll("[", "{").replaceAll("]", "}") ?? List<String>().toString(),
      "types":types.toString().replaceAll("[", "{").replaceAll("]", "}") ?? List<String>().toString(),
      "schedule":jsonEncode(schedule) ?? Map<String,List<int>>().toString()
    };
    var response = await http.post("https://lookinmeal-dcf41.firebaseapp.com/restaurants", body: body);
    print(response.body);
  }



  Future<List<Restaurant>> getAllRestaurants() async{
    var response = await http.get("https://lookinmeal-dcf41.firebaseapp.com/allrestaurants");
    List<Restaurant> restaurants = List<Restaurant>();
    List<dynamic> result = json.decode(response.body);
    Map<String,List<int>> schedule;
    for(dynamic element in result){
      schedule = {'1': new List<int>(), '2': new List<int>(), '3': new List<int>(), '4': new List<int>(), '5': new List<int>(), '6': new List<int>(), '0': new List<int>()};
      if(element['schedule'] != null) {
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
        restaurant_id : element['restaurant_id'].toString(),
        ta_id: element['ta_id'].toString(),
        name: element['name'],
        phone: element['phone'],
        website: element['website'],
        webUrl: element['weburl'],
        address: element['address'],
        city: element['city'],
        country: element['country'],
        latitude: element['latitude'],
        longitude: element['longitude'],
        rating: double.parse(element['rating'].toString()),
        numrevta: element['numrevta'],
        images: element['images'] == null ? null : List<String>.from(element['images']),
        types: element['types'] == null ? null : List<String>.from(element['types']),
        schedule: schedule,
        currency: element['currency'],
        sections: element['sections'] == null ? null : List<String>.from(element['sections'])
      );
      restaurants.add(restaurant);
    }
    return restaurants;
  }

  Future<List<Restaurant>> getFavorites(List<String> ids) async{

  }


  Stream<User> get userdata{

  }

}