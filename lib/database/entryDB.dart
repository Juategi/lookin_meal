import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lookinmeal/database/userDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/strings.dart';

class DBServiceEntry{
  static final DBServiceEntry dbServiceEntry = DBServiceEntry();

  Future<String> addMenuEntry(String restaurant_id, String name, String section, double price, String image, int pos, String description, List<String> allergens, bool hide) async{
    Map body = {
      "restaurant_id": restaurant_id,
      "name": name,
      "section": section,
      "price" : price.toString(),
      "image" : image ?? "",
      "pos" : pos.toString(),
      "description": description,
      "hide": hide,
      "allergens": allergens.toString().replaceAll("[", "{").replaceAll("]", "}")
    };
    var response = await http.post(
        "${StaticStrings.api}/menus", body: body);
    List<dynamic> result = json.decode(response.body);
    return result.first["entry_id"].toString();
  }

  Future<List<MenuEntry>> getMenu(String restaurant_id) async {
    List<MenuEntry> menu = List<MenuEntry>();
    var response = await http.get(
        "${StaticStrings.api}/menus",
        headers: {"restaurant_id": restaurant_id});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      MenuEntry me = MenuEntry(
          id: element['entry_id'].toString(),
          restaurant_id: element['restaurant_id'].toString(),
          name: element['name'],
          section: element['section'].toString().replaceAll("'", ""),
          rating: element['rating'] == null ? 0.0 : double.parse(element['rating'].toStringAsFixed(2)),
          numReviews: int.parse(element['numreviews']),
          price: element['price'].toDouble(),
          image: element['image'],
          pos: element['pos'],
          description: element['description'],
          hide: element['hide'].toString() == "true",
          allergens: element['allergens'] == null ? [] : List<String>.from(element['allergens'])
      );
      menu.add(me);
    }
    return menu;
  }


  Future addSection(String restaurant_id, String section) async{
    var response = await http.post(
        "${StaticStrings.api}/sections", body: {"restaurant_id" : restaurant_id, "sections" : section});
    print(response.body);
  }


  Future<List<String>> getSections(String restaurant_id) async{
    var response = await http.get(
        "${StaticStrings.api}/sections", headers: {"restaurant_id" : restaurant_id});
    List<dynamic> result = json.decode(response.body);
    List<String> sections =  List<String>.from(result.first['sections']);
    print(sections);
    return sections;
  }


  Future<List<Rating>> getAllRating(String user_id) async{
    List<Rating> ratings = List<Rating>();
    var response = await http.get(
        "${StaticStrings.api}/allrating", headers: {"user_id" : user_id});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      ratings.add(Rating(
          entry_id: element["entry_id"].toString(),
          rating: element["rating"].toDouble(),
          date: element["ratedate"].toString().substring(0,10),
          comment: element["comment"] == null? " " : element["comment"]
      ));
    }
    //print(ratings);
    return ratings;
  }

  Future deleteRate(String user_id, String entry_id) async{
    var response = await http.delete(
        "${StaticStrings.api}/rating", headers: {"user_id" : user_id, "entry_id" : entry_id});
    print(response.body);
  }

  Future addRate(String user_id, String entry_id, num rating, String comment) async{
    final formatter = new DateFormat('yyyy-MM-dd');
    var response = await http.post(
        "${StaticStrings.api}/rating", body: {"user_id" : user_id, "entry_id" : entry_id, "rating" : rating.toString(), "ratedate" : formatter.format(DateTime.now()), "comment": comment});
    print(response.body);
  }

  Future uploadMenu(List<String> sections, List<MenuEntry> menu, Restaurant restaurant)async{
    List<String> checkDeletes = List<String>();
    List<String> notNews = List<String>();
    for(MenuEntry entryR in restaurant.menu){
      notNews.add(entryR.id);
      //print(entryR.allergens);
    }
    var response = await http.put("${StaticStrings.api}/sections", body: {"restaurant_id": restaurant.restaurant_id, "sections":sections.toString().replaceAll("[", "").replaceAll("]", "")});
    //print(response.body);
    for(MenuEntry entry in menu){
      if(!notNews.contains(entry.id)){
        entry.id = await addMenuEntry(entry.restaurant_id, entry.name, entry.section, entry.price, entry.image, entry.pos, entry.description, entry.allergens, entry.hide);
      }
      else{
        for(MenuEntry entryR in restaurant.menu){
          if(entry.id == entryR.id) {
            if (!(entry.price == entryR.price && entry.name == entryR.name && entry.section == entryR.section && entry.image == entryR.image && entry.hide == entryR.hide && entry.description == entryR.description && Functions.compareList(entry.allergens, entryR.allergens))) {
              var response = await http.put("${StaticStrings.api}/menus",
                  body: {
                    "entry_id": entry.id,
                    "name": entry.name,
                    "section": entry.section,
                    "price": entry.price.toString(),
                    "image": entry.image ?? "",
                    "pos": entry.pos.toString(),
                    "description": entry.description ?? "",
                    "hide": entry.hide.toString(),
                    "allergens": entry.allergens.toString().replaceAll("[", "{").replaceAll("]", "}")
                  });
              print("${response.body}    ${entry.name}");
            }
          }
        }
      }
      checkDeletes.add(entry.id);
    }
    for(MenuEntry entryR in restaurant.menu){
      if(!checkDeletes.contains(entryR.id)){
        var response = await http.delete("${StaticStrings.api}/menus", headers: {"entry_id": entryR.id});
        print(response.body);
      }
    }
    restaurant.menu = menu;
    restaurant.sections = sections;
  }

  Future updateDailyMenu(String restaurant_id, List<String> dailyMenu) async{
    var response = await http.put("${StaticStrings.api}/daily", body: {"restaurant_id": restaurant_id, "dailymenu":dailyMenu.toString().replaceAll("[", "").replaceAll("]", "")});
    print(response.body);
  }

  Future<Map<String,Restaurant>> getRatingsHistory(String id, List<String> ratings, int offset, int limit) async {
    var response = await http.get("${StaticStrings.api}/ratingshistory", headers: {
      "user_id" : id,
      "ratings": ratings.toString().replaceAll("[", "{").replaceAll("]", "}"),
      "limit": limit.toString(),
      "offset": offset.toString(),
      "latitude": GeolocationService.myPos.latitude.toString(),
      "longitude": GeolocationService.myPos.longitude.toString()
    });
    List<Restaurant> restaurants = await DBServiceRestaurant.dbServiceRestaurant.parseResponse(response);
    List<dynamic> result = json.decode(response.body);
    Map<String,Restaurant> finalMap = {};
    for(int i = 0; i < result.length; i++){
      var element = result[i];
      finalMap[element['entry_id'].toString()] = restaurants.firstWhere((restaurant) => restaurant.restaurant_id == element['restaurant_id'].toString());
    }
    return finalMap;
  }

  Future<Map<String,Restaurant>> getEntriesById(List<String> ids) async {
    var response = await http.get("${StaticStrings.api}/entriesbyid", headers: {
      "ids": ids.toString().replaceAll("[", "{").replaceAll("]", "}"),
      "latitude": GeolocationService.myPos.latitude.toString(),
      "longitude": GeolocationService.myPos.longitude.toString()
    });
    List<Restaurant> restaurants = await DBServiceRestaurant.dbServiceRestaurant.parseResponse(response);
    List<dynamic> result = json.decode(response.body);
    Map<String,Restaurant> finalMap = {};
    for(int i = 0; i < result.length; i++){
      var element = result[i];
      finalMap[element['entry_id'].toString()] = restaurants.firstWhere((restaurant) => restaurant.restaurant_id == element['restaurant_id'].toString());
    }
    return finalMap;
  }

  Future<Map<Rating, User>> getEntryRatings(String entry_id) async{
    Map<Rating, User> ratings = {};
    var response = await http.get(
        "${StaticStrings.api}/comments", headers: {"entry_id" : entry_id});
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
      );
      ratings[rating] = user;
    }
    return ratings;
  }
}