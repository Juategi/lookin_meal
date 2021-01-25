import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/info.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/strings.dart';

class DBServiceUser {

	static User userF;
	static final DBServiceUser dbServiceUser = DBServiceUser();
	//String api = "https://lookinmeal-dcf41.firebaseapp.com";//"http://localhost:5001/lookinmeal-dcf41/us-central1/app";//

	Future<User> getUserData(String id) async{
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
				GeolocationService _geolocationService = GeolocationService();
				Position myPos = await _geolocationService.getLocation();
				User user = User(
						uid: result.first["user_id"],
						name: result.first["name"],
						email: result.first["email"],
						service: result.first["service"],
						picture: result.first["image"],
						country: result.first["country"],
						username: result.first["username"],
						//favorites: await this.getUserFavorites(id, myPos.latitude, myPos.longitude),
						ratings: await DBServiceEntry.dbServiceEntry.getAllRating(id),
						recently: await DBServiceRestaurant.dbServiceRestaurant.getRecently(result.first["user_id"].toString()),
				);
				print("User obtained: ${result.first}");
				userF = user;
				user.lists = await dbServiceUser.getLists();
				user.history = await DBServiceEntry.dbServiceEntry.getRatingsHistory(DBServiceUser.userF.uid, DBServiceUser.userF.ratings.map((r) => r.entry_id).toList(), 0, 15);
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

	Future<String> getCountry()async{
		String ipUrl = "https://api.ipify.org?format=json";
		String locIpUrl = "https://ipapi.co/";
		var result = await http.get(ipUrl, headers: {});
		String ip = json.decode(result.body)['ip'];
		result = await http.get("$locIpUrl${ip}/json/", headers: {});
		dynamic iplocalization = json.decode(result.body);
		return iplocalization["country_name"];
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

	Future updateUserData(String id, String email, String name, String picture,
			String service) async {
		Map body = {
			"id": id,
			"name": name,
			"email": email,
			"service": service,
			"image": picture
		};
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


}