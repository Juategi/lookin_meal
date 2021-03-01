import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/owner.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/services/geolocation.dart';

class DBServiceUser {

  static User userF;
  static final DBServiceUser dbServiceUser = DBServiceUser();
  //String api = "https://lookinmeal-dcf41.firebaseapp.com";//"http://localhost:5001/lookinmeal-dcf41/us-central1/app";//

  Future<User> getUserData(String id) async{
    await GeolocationService().getLocation();
    if(userF == null){
      var response = await http.get(
          "${StaticStrings.api}/users", headers: {"id": id});
      while(response.body == "[]"){
        Future.delayed(const Duration(milliseconds: 900), () {});
        response = await http.get(
            "${StaticStrings.api}/users", headers: {"id": id});
      }
      if(response.body != "[]") {
        List<dynamic> result = json.decode(response.body);
        User user = User(
          uid: result.first["user_id"],
          name: result.first["name"],
          email: result.first["email"],
          service: result.first["service"],
          picture: result.first["image"],
          country: result.first["country"],
          username: result.first["username"],
          about: result.first["about"],
          ratings: await DBServiceEntry.dbServiceEntry.getAllRating(id),
          recently: await DBServiceRestaurant.dbServiceRestaurant.getRecently(id),
        );
        print("User obtained: ${result.first}");
        DBServiceUser.userF = user;
        user.lists = await dbServiceUser.getLists();
        user.history = await DBServiceEntry.dbServiceEntry.getRatingsHistory(user.uid, user.ratings.map((r) => r.entry_id).toList(), 0, 15);
        return user;
      }
    }
    else {
      return userF;
    }
  }

  Future<User> getUserDataChecker(String id) async{
    var response = await http.get(
        "${StaticStrings.api}/users", headers: {"id": id});
    if(response.body != "[]") {
      List<dynamic> result = json.decode(response.body);
      User user = User(
        uid: result.first["user_id"],
        name: result.first["name"],
        email: result.first["email"],
        service: result.first["service"],
        picture: result.first["image"],
        country: result.first["country"],
        username: result.first["username"],
      );
      return user;
    }
    else
      return null;
  }

  Future createUser(String id, String email, String name, String picture,
      String service, String country, String username) async {
    Map body = {
      "id": id,
      "name": name,
      "email": email,
      "service": service,
      "image": picture,
      "country": country,
      "username": username
    };
    var response = await http.post(
        "${StaticStrings.api}/users", body: body);
    print(response.body);
    await DBServiceUser.dbServiceUser.createList(id, "favorites", StaticStrings.defaultEntry, "R");
    await DBServiceUser.dbServiceUser.createList(id, "favorites", StaticStrings.defaultEntry, "E");
  }

  Future<bool> checkUsername(String username) async{
    String us;
    var response = await http.get("${StaticStrings.api}/checkuser", headers: {"username": username});
    print(response.body);
    try {
      var aux = json.decode(response.body);
      us = aux[0]['username'];
    }catch(e){}
    if(us == null)
      return false;
    else
      return true;
  }

  Future<String> checkUsernameEmail(String username, String email) async{
    String em, us;
    String result = "";
    var response = await http.get("${StaticStrings.api}/checkmail", headers: {"email": email});
    print(response.body);
    var response2 = await http.get("${StaticStrings.api}/checkuser", headers: {"username": username});
    print(response2.body);
    try {
      var aux = json.decode(response.body);
      em = aux[0]['email'];
    } catch(e){}
    try {
      var aux = json.decode(response2.body);
      us = aux[0]['username'];
    }catch(e){}
    if(us != null)
      result += "u";
    if(em != null)
      result += "e";
    return result;
  }

  Future updateUserData(String id, String name, String about, String picture,
      String service, String country, String username,) async {
    Map body = {
      "id": id,
      "name": name,
      "about": about,
      "image": picture,
      "service": service,
      "country": country,
      "username" : username
    };
    print(body);
    var response = await http.put(
        "${StaticStrings.api}/users", body: body);
    print(response.body);
  }


  Future<FavoriteList> createList(String user, String name, String image, String type) async{
    var response = await http.post("${StaticStrings.api}/lists", body: {
      "user_id" : user,
      "name": name,
      "image": image,
      "type": type
    });
    List<dynamic> result = json.decode(response.body);
    return FavoriteList(name: name, image: image, type: type, items: [], id: result.first['id'].toString());
  }

  Future<List<FavoriteList>> getLists() async{
    var response = await http.get("${StaticStrings.api}/lists", headers: {
      "user_id" : userF.uid,
    });
    List<dynamic> result = json.decode(response.body);
    List<FavoriteList> lists = [];
    for (dynamic element in result) {
      lists.add(FavoriteList(
        id: element['id'].toString(),
        name: element['name'],
        image: element['image'],
        type: element['type'],
        items: element['list']  == null ? null : List<String>.from(element['list']),
      ));
    }
    print("Lists gotten");
    return lists;
  }

  Future updateList (FavoriteList list) async{
    var response = await http.put("${StaticStrings.api}/lists", body: {
      "id" : list.id,
      "name": list.name,
      "image": list.image,
      "list": list.items.toString().replaceAll("[", "{").replaceAll("]", "}"),
    });
    print(response.body);
  }

  Future deleteList(String id) async{
    var response = await http.delete("${StaticStrings.api}/lists", headers: {
      "id" : id
    });
    print(response.body);
  }

  //CODES


  Future createOwner(Owner owner) async{
    Map body = {
      "user_id": owner.user_id,
      "restaurant_id": owner.restaurant_id,
      "token": owner.token,
    };
    var response = await http.post(
        "${StaticStrings.api}/owner", body: body);
    print(response.body);
  }

  Future<List<Owner>> getOwners(String restaurant_id) async {
    List<Owner> owners = [];
    var response = await http.get(
        "${StaticStrings.api}/ownerres",
        headers: {"restaurant_id":restaurant_id});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      Owner owner = Owner(
          restaurant_id: element['restaurant_id'].toString(),
          user_id: element['user_id'].toString(),
          token: element['token'].toString()
      );
      owners.add(owner);
    }
    return owners;
  }

  Future deleteCode(String user_id, String restauratnt_id) async{
    var response = await http.delete(
        "${StaticStrings.api}/owner", headers: {"user_id" : user_id, "restaurant_id" : restauratnt_id});
    print(response.body);
  }


}