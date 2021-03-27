import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/notification.dart';
import 'package:lookinmeal/models/owner.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/analytics.dart';
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
          followers: await dbServiceUser.getFollowers(id),
          following: await dbServiceUser.getFollowing(id)
        );
        print("User obtained: ${result.first}");
        DBServiceUser.userF = user;
        user.lists = await dbServiceUser.getLists();
        user.history = await DBServiceEntry.dbServiceEntry.getRatingsHistory(user.uid, user.ratings.map((r) => r.entry_id).toList(), 0, 15);
        user.numFollowing = user.following.length;
        user.numFollowers = user.followers.length;
        user.owned = await DBServiceRestaurant.dbServiceRestaurant.getOwned(user.uid);
        String owner;
        if(user.owned.length == 0)
          owner = "false";
        else
          owner = "true";
        AnalyticsService().setUserProperties(user.uid, user.username, owner);
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

  Future<User> getUserDataUsername(String username) async{
    var response = await http.get(
        "${StaticStrings.api}/username", headers: {"username": username});
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

  Future createOwner(Owner owner) async{
    Map body = {
      "user_id": owner.user_id,
      "restaurant_id": owner.restaurant_id,
      "token": owner.token,
      "type": owner.type
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
          token: element['token'].toString(),
          type: element['type'].toString(),
          username: element["username"].toString(),
      );
      owners.add(owner);
    }
    return owners;
  }

  Future deleteOwner(Owner owner) async{
    var response = await http.delete(
        "${StaticStrings.api}/owner", headers: {"user_id" : owner.user_id, "restaurant_id" : owner.restaurant_id});
    print(response.body);
  }

  Future updateOwner(Owner owner) async{
    var response = await http.put("${StaticStrings.api}/owner", body: {
      "user_id" : owner.user_id,
      "type": owner.type,
      "token": owner.token ?? "",
      "restaurant_id": owner.restaurant_id,
    });
    print(response.body);
  }

  Future addFollower(String followerid)async{
    var response = await http.post("${StaticStrings.api}/follower", body: {"userid": userF.uid, "followerid":followerid});
    print(response.body);
  }

  Future deleteFollower(String userid, String followerid)async{
    var response = await http.delete("${StaticStrings.api}/follower", headers: {"userid":userid, "followerid":followerid});
    print(response.body);
  }

  Future<int> getNumFollowers(String userid) async{
    var response = await http.get("${StaticStrings.api}/numfollowers", headers: {"userid":userid});
    List result = json.decode(response.body);
    return int.parse(result.first['num']);
  }

  Future<int> getNumFollowing(String userid) async{
    var response = await http.get("${StaticStrings.api}/numfollowing", headers: {"userid":userid});
    List result = json.decode(response.body);
    return int.parse(result.first['num']);
  }

  Future<List<String>> getFollowers(String userid) async{
    var response = await http.get("${StaticStrings.api}/followers", headers: {"userid":userid});
    List<String> follows = [];
    List result = json.decode(response.body);
    for(var element in result){
      follows.add(element['user_id']);
    }
    return follows;
  }

  Future<List<String>> getFollowing(String userid) async{
    var response = await http.get("${StaticStrings.api}/following", headers: {"userid":userid});
    List<String> follows = [];
    List result = json.decode(response.body);
    for(var element in result){
      follows.add(element['followerid']);
    }
    return follows;
  }

  Future createTicket(String ticket, String type)async{
    var response = await http.post("${StaticStrings.api}/ticket", body: {"userid":userF.uid, "ticket":ticket, "type":type});
    print(response.body);
  }

  Future addNotification(Notification notification) async{
    Map body = {
      "user_id": notification.user_id,
      "restaurant_id": notification.restaurant_id,
      "body": notification.body,
      "type": notification.type
    };
    var response = await http.post(
        "${StaticStrings.api}/notifications", body: body);
    print(response.body);
  }

  Future<List<Notification>> getNotifications(String user_id) async {
    List<Notification> notifications = [];
    var response = await http.get(
        "${StaticStrings.api}/notifications",
        headers: {"user_id" : user_id});
    List<dynamic> result = json.decode(response.body);
    for(var element in result){
      Notification notification = Notification(
        id: element['id'].toString(),
        restaurant_id: element['restaurant_id'].toString(),
        user_id: element['user_id'].toString(),
        body: element['body'].toString(),
        type: element['type'].toString(),
        restaurant_name: element['name'].toString(),
      );
      notifications.add(notification);
    }
    return notifications;
  }

  Future deleteNotification(String id) async{
    var response = await http.delete(
        "${StaticStrings.api}/notifications", headers: {"id" : id});
    print(response.body);
  }

}