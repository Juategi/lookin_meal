import 'dart:convert';
import 'package:http/http.dart' as http;
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/database/reservationDB.dart';
import 'entryDB.dart';

class DBServiceRestaurant{

  static final DBServiceRestaurant dbServiceRestaurant = DBServiceRestaurant();

  Future deleteFromUserFavorites(String userId,
      Restaurant restaurant) async {
    var response = await http.delete(
        Uri.http(StaticStrings.api, "/userfavs"), headers: {"user_id": userId,
      "restaurant_id": restaurant.restaurant_id});
    print(response.body);

  }

  Future addToUserFavorites(String userId,
      Restaurant restaurant) async{
    var response = await http.post(
        Uri.http(StaticStrings.api, "/userfavs"),
        body: {"user_id": userId, "restaurant_id": restaurant.restaurant_id});
    print(response.body);
  }

  Future<List<Restaurant>> getUserFavorites(String id, latitude, longitude) async {
    var response = await http.get(
        Uri.http(StaticStrings.api, "/userfavs"),
        headers: {"latitude": latitude.toString(), "longitude": longitude.toString(),"id": id});
    return parseResponse(response);
  }

  Future<List<Restaurant>> getRecently(String id) async {
    var response = await http.get(Uri.http(StaticStrings.api, "/recently"), headers: {"user_id" : id, "latitude": GeolocationService.myPos.latitude.toString(), "longitude": GeolocationService.myPos.longitude.toString() });
    return parseResponse(response);
  }

  Future<List<Restaurant>> getOwned(String id) async {
    var response = await http.get(Uri.http(StaticStrings.api, "/owned"), headers: {"user_id" : id, "latitude": GeolocationService.myPos.latitude.toString(), "longitude": GeolocationService.myPos.longitude.toString() });
    return parseResponse(response);
  }

  Future<List<Restaurant>> getRestaurantsById(List<String> ids, latitude, longitude) async {
    var response = await http.get(
        Uri.http(StaticStrings.api, "/restbyid"),
        headers: {"ids": ids.toString().replaceAll("[", "{").replaceAll("]", "}"), "latitude": latitude.toString(), "longitude": longitude.toString()});
    return parseResponse(response);
  }

  Future<List<Restaurant>> getSponsored(int quantity) async {
    var response = await http.get(Uri.http(StaticStrings.api, "/sponsored"), headers: {"latitude": GeolocationService.myPos.latitude.toString(), "longitude": GeolocationService.myPos.longitude.toString(), "quantity":quantity.toString() });
    return parseResponse(response);
  }

  Future<bool> checkRequestStatus(String restaurant_id) async {
    var response = await http.get(Uri.http(StaticStrings.api, "/nanonets"), headers: {"restaurant_id" : restaurant_id, "user_id" : DBServiceUser.userF.uid});
    List<dynamic> result = json.decode(response.body);
    print(response.body);
    if(result.length > 0)
      return true;
    else
      return false;
  }

  Future updateRecently(Restaurant restaurant) async{
    for(Restaurant r in DBServiceUser.userF.recently){
      if(r.restaurant_id == restaurant.restaurant_id){
        return;
      }
    }
    if(DBServiceUser.userF.recently.length == 5){
      DBServiceUser.userF.recently.removeAt(0);
    }
    DBServiceUser.userF.recently.add(restaurant);
    DBServiceUser.userF.recent = DBServiceUser.userF.recently;
    Map body = {
      "user_id": DBServiceUser.userF.uid,
      "recently": DBServiceUser.userF.recently.map((r) => r.restaurant_id).toList().toString().replaceAll("[", "{").replaceAll("]", "}")
    };
    var response = await http.put(
        Uri.http(StaticStrings.api, "/recently"), body: body);
    print(response.body);
  }

  Future<Map<MenuEntry,Restaurant>> getPopular() async {
    var response = await http.get(Uri.http(StaticStrings.api, "/popular"), headers: {"latitude": GeolocationService.myPos.latitude.toString(), "longitude": GeolocationService.myPos.longitude.toString() });
    return parseResponseEntry(response);
  }

  Future<Map<MenuEntry,Restaurant>> getTopEntries() async {
    var response = await http.get(Uri.http(StaticStrings.api, "/topentry"), headers: {"latitude": GeolocationService.myPos.latitude.toString(), "longitude": GeolocationService.myPos.longitude.toString() });
    return parseResponseEntry(response);
  }

  Future<List<Restaurant>> getTopRestaurants() async {
    var response = await http.get(Uri.http(StaticStrings.api, "/toprestaurant"), headers: {"latitude": GeolocationService.myPos.latitude.toString(), "longitude": GeolocationService.myPos.longitude.toString() });
    return parseResponse(response);
  }

  Future<List<Restaurant>> getRecommended(String id) async {
    var response = await http.get(Uri.http(StaticStrings.api, "/recommended"), headers: {"latitude": GeolocationService.myPos.latitude.toString(), "longitude": GeolocationService.myPos.longitude.toString(), "user_id" : id});
    return parseResponse(response);
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    var response = await http.get(
        Uri.http(StaticStrings.api, "/allrestaurants"));
    return parseResponse(response);
  }

  Future<List<Restaurant>> getNearRestaurants(double latitude, double longitude, int quantity) async {
    var response = await http.get(
        Uri.http(StaticStrings.api, "/restaurants"),
        headers: {"latitude": latitude.toString(), "longitude": longitude.toString(), "quantity": quantity.toString()});
    return parseResponse(response);
  }

  Future<List<Restaurant>> getRestaurantsSquare(double latitude, double longitude, double la1, double la2, double lo1, double lo2) async {
    var response = await http.get(
        Uri.http(StaticStrings.api, "/square"),
        headers: {
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "la1": la1.toString(),
          "la2": la2.toString(),
          "lo1": lo1.toString(),
          "lo2": lo2.toString()
        });
    return parseResponse(response);
  }

  Future uploadRestaurantData(String taId, String name, String phone,
      String website, String webUrl, String address, String email, String city,
      String country, double latitude,
      double longitude, double rating, int numberViews, List<String> images,
      List<String> types, Map<String, List<int>> schedule, String currency, List<String> delivery) async {
    Map body = {
      "taid": taId ?? "",
      "name": name,
      "phone": phone ?? "",
      "website": website ?? "",
      "webUrl": webUrl ?? "",
      "address": address,
      "email": email ?? "",
      "city": city.trim().toUpperCase(),
      "country": country,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "rating": rating.toString() ?? "0.0",
      "numrevta": numberViews.toString() ?? "0",
      "images": images.toString().replaceAll("[", "{").replaceAll("]", "}") ??
          List<String>().toString(),
      "types": types.toString().replaceAll("[", "{").replaceAll("]", "}") ??
          List<String>().toString(),
      "schedule": jsonEncode(schedule) ?? Map<String, List<int>>().toString(),
      "currency": currency,
      "delivery": delivery.toString().replaceAll("[", "{").replaceAll("]", "}") ??
          List<String>().toString(),
    };
    var response = await http.post(
        Uri.http(StaticStrings.api, "/restaurants"), body: body);
    print(response.body);
  }

  updateRestaurantData(String restaurant_id, String name, String phone,
      String website, String address, String email, List<String> types, Map<String, List<String>> schedule, List<String> delivery, String currency) async{
    switch (currency){
      case "€": currency = "euro"; break;
      case "\$": currency = "dolar"; break;
      case "¥": currency = "yen"; break;
      case "£": currency = "libra"; break;
    }
    Map body = {
      "id": restaurant_id,
      "name": name,
      "phone": phone ?? "",
      "website": website ?? "",
      "address": address ?? "",
      "email": email ?? "",
      "types": types.toString().replaceAll("[", "{").replaceAll("]", "}") ??
          List<String>().toString(),
      "schedule": jsonEncode(schedule).toString() ?? Map<String, List<String>>().toString(),
      "delivery": delivery.toString().replaceAll("[", "{").replaceAll("]", "}") ??
          List<String>().toString(),
      "currency": currency
    };
    print(body);
    var response = await http.put(
        Uri.http(StaticStrings.api, "/restaurant"), body: body);
    print(response.body);
  }

  updateRestaurantMealTime(String restaurant_id, num mealtime) async{
    var response = await http.put(
        Uri.http(StaticStrings.api, "/restaurantmeal"), body: {"id" : restaurant_id, "mealtime": mealtime.toString()});
    print(response.body);
  }

  updateRestaurantImages(String restaurant_id, List<String> images) async{
    var response = await http.put(
        Uri.http(StaticStrings.api, "/restaurantimages"), body: {"id" : restaurant_id, "images": images.toString().replaceAll("[", "{").replaceAll("]", "}") ?? List<String>().toString()});
    print(response.body);
  }

  Future<List<List<Object>>> getFeed(String user_id, int offset) async{
    List<List<Object>> ratings = [];
    var response = await http.get(
        Uri.http(StaticStrings.api, "/feed"), headers: {"user_id" : user_id, "offset" : offset.toString()});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      Rating rating = Rating(
          entry_id: element["entry_id"].toString(),
          rating: element["rating"].toDouble(),
          date: element["ratedate"].toString().substring(0,10),
          comment: element["comment"] == null? " " : element["comment"]
      );
      User user = User(
        name: element["name"],
        uid: element["user_id"],
        email: element["email"],
        picture: element["image"],
        username: element["username"],
        about: element["about"],
        country: element["country"],
        checked: element["checked"] == null ? false : element["checked"],
      );
      MenuEntry entry = MenuEntry(
          id: element['entry_id'].toString(),
          restaurant_id: element['restaurant_id'].toString(),
          name: element['entryname'],
          price: element['price'].toDouble(),
          image: element['entryimage'],
          description: element['description'],
          allergens: element['allergens'] == null ? [] : List<String>.from(element['allergens'])
      );
      Restaurant restaurant = (await DBServiceRestaurant.dbServiceRestaurant.getRestaurantsById([entry.restaurant_id], GeolocationService.myPos.latitude, GeolocationService.myPos.longitude)).first;
      ratings.add([user, entry, rating, restaurant]);
    }
    return ratings;
  }

  Future<List<Restaurant>> parseResponse(var response) async{
    List<Restaurant> restaurants = List<Restaurant>();
    List<dynamic> result = json.decode(response.body);
    Map<String, List<String>> schedule;
    for (dynamic element in result) {
      Restaurant restaurant = Pool.getRestaurant(element['restaurant_id'].toString());
      if(restaurant != null){
        restaurants.add(restaurant);
      }
      else{
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
          Map<String, dynamic> result = json.decode(element['schedule'].toString()
              .replaceAll("0:", '"0":')
              .replaceAll("1:", '"1":')
              .replaceAll("2:", '"2":')
              .replaceAll("3:", '"3":')
              .replaceAll("4:", '"4":')
              .replaceAll("5:", '"5":')
              .replaceAll("6:", '"6":')
              .replaceAll("[", '"[')
              .replaceAll("]", ']"')
          );
          for (int i = 0; i < 7; i++) {
            if(result[i.toString()] == null){
              result[i.toString()] = [-1,-1];
            }
            for (dynamic hour in result[i.toString()].toString().split(',')) {
              schedule[i.toString()].add(hour.toString());
            }
          }
        }
        List<String> images = element['images'] == null ? null : List<String>.from(element['images']);
        images = Functions.cleanStrings(images);
        List<String> sections = element['sections'] == null ? null : List<String>.from(element['sections']);
        sections = Functions.cleanStrings(sections);
        List<String> types = element['types'] == null ? null : List<String>.from(element['types']);
        types = Functions.cleanStrings(types);
        List<String> delivery = element['delivery'] == null ? null : List<String>.from(element['delivery']);
        delivery = Functions.cleanStrings(delivery);
        String currency;
        switch (element['currency']){
          case "euro": currency = "€"; break;
          case "dolar": currency = "\$"; break;
          case "yen": currency = "¥"; break;
          case "libra": currency = "£"; break;
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
            mealtime: element['mealtime'],
            distance: double.parse(element['distance'].toStringAsFixed(2)),
            //rating: double.parse(element['rating'].toString()),
            numrevta: element['numrevta'],
            images: images,
            types: types,
            schedule: schedule,
            currency: currency,
            sections: sections,
            dailymenu: element['dailymenu'] == null ? null : List<String>.from(
                element['dailymenu']),
            delivery: delivery,
            menu: await DBServiceEntry.dbServiceEntry.getMenu(element['restaurant_id'].toString()),
            tables: await DBServiceReservation.dbServiceReservation.getTables(element['restaurant_id'].toString()),
            codes: await DBServiceReservation.dbServiceReservation.getCodes(element['restaurant_id'].toString())
        );
        restaurants.add(restaurant);
        Pool.addRestaurant(restaurant);
      }
    }
    //print("Number of restaurants : ${restaurants.length}");
    return restaurants;
  }

  Future<Map<MenuEntry,Restaurant>> parseResponseEntry(var response) async{
    Map<MenuEntry,Restaurant> map = Map<MenuEntry,Restaurant>();
    List<dynamic> result = json.decode(response.body);
    Map<String, List<String>> schedule;
    for (dynamic element in result) {
      Restaurant restaurant = Pool.getRestaurant(element['restaurant_id'].toString());
      if(restaurant != null){
        MenuEntry entry;
        for(MenuEntry e in restaurant.menu){
          if(e.id == element['entry_id'].toString()){
            entry = e;
            break;
          }
        }
        map[entry] = restaurant;
      }
      else{
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
          Map<String, dynamic> result = json.decode(element['schedule'].toString()
              .replaceAll("0:", '"0":')
              .replaceAll("1:", '"1":')
              .replaceAll("2:", '"2":')
              .replaceAll("3:", '"3":')
              .replaceAll("4:", '"4":')
              .replaceAll("5:", '"5":')
              .replaceAll("6:", '"6":')
              .replaceAll("[", '"[')
              .replaceAll("]", ']"')
          );
          for (int i = 0; i < 7; i++) {
            if(result[i.toString()] == null){
              result[i.toString()] = [-1,-1];
            }
            for (dynamic hour in result[i.toString()].toString().split(',')) {
              schedule[i.toString()].add(hour.toString());
            }
          }
        }
        List<String> images = element['images'] == null ? null : List<String>.from(element['images']);
        images = Functions.cleanStrings(images);
        List<String> sections = element['sections'] == null ? null : List<String>.from(element['sections']);
        sections = Functions.cleanStrings(sections);
        List<String> types = element['types'] == null ? null : List<String>.from(element['types']);
        types = Functions.cleanStrings(types);
        List<String> delivery = element['delivery'] == null ? null : List<String>.from(element['delivery']);
        delivery = Functions.cleanStrings(delivery);
        String currency;
        switch (element['currency']){
          case "euro": currency = "€"; break;
          case "dolar": currency = "\$"; break;
          case "yen": currency = "¥"; break;
          case "libra": currency = "£"; break;
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
            mealtime: element['mealtime'],
            distance: double.parse(element['distance'].toStringAsFixed(2)),
            //rating: double.parse(element['rating'].toString()),
            numrevta: element['numrevta'],
            images: element['images'] == null ? null : List<String>.from(
                element['images']),
            types: element['types'] == null ? null : List<String>.from(
                element['types']),
            schedule: schedule,
            currency: currency,
            sections: element['sections'] == null ? null : List<String>.from(
                element['sections']),
            dailymenu: element['dailymenu'] == null ? null : List<String>.from(
                element['dailymenu']),
            delivery: element['delivery'] == null ? null : List<String>.from(
                element['delivery']),
            menu: await DBServiceEntry.dbServiceEntry.getMenu(element['restaurant_id'].toString()),
            tables: await DBServiceReservation.dbServiceReservation.getTables(element['restaurant_id'].toString()),
            codes: await DBServiceReservation.dbServiceReservation.getCodes(element['restaurant_id'].toString())
        );
        MenuEntry entry;
        for(MenuEntry e in restaurant.menu){
          if(e.id == element['entry_id'].toString()){
            entry = e;
            break;
          }
        }
        map[entry] = restaurant;
        Pool.addRestaurant(restaurant);
      }
    }

    for(MenuEntry entry in map.keys.toList()){
      for(Restaurant restaurant in map.values.toList()){
        if(map[entry].restaurant_id == restaurant.restaurant_id){
          //popular[entry] = restaurant;
          for(MenuEntry e in restaurant.menu){
            if(e.id == entry.id){
              map[e] = restaurant;
              map.remove(entry);
            }
            break;
          }
          break;
        }
      }
    }
    /*for(MenuEntry entry in popular.keys){
			for(MenuEntry e in popular[entry].menu){
				if(entry.id == e.id){
					print(entry.hashCode);
					print(e.hashCode);
				}
			}
		}*/
    return map;
  }

}