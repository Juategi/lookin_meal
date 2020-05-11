import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/strings.dart';

class DBService {

	static User _user;

	Future<User> getUserData(String id) async{
		if(_user == null){
			var response = await http.get(
					"https://lookinmeal-dcf41.firebaseapp.com/users", headers: {"id": id});
			print(response.body);
			List<dynamic> result = json.decode(response.body);
			List<Restaurant> favorites = await this.getUserFavorites(id);
			User user = User(
					uid: result.first["user_id"],
					name: result.first["name"],
					email: result.first["email"],
					service: result.first["service"],
					picture: result.first["image"],
					favorites: await this.getUserFavorites(id),
					ratings: await this.getAllRating(id)
			);
			Pool.addRestaurants(user.favorites);
			print("User obtained: ${result.first}");
			_user = user;
			return user;
		}
		else {
      return _user;
    }
	}

	Future createUser(String id, String email, String name, String picture,
			String service) async {
		Map body = {
			"id": id,
			"name": name,
			"email": email,
			"service": service,
			"image": picture
		};
		var response = await http.post(
				"https://lookinmeal-dcf41.firebaseapp.com/users", body: body);
		print(response.body);
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
				"https://lookinmeal-dcf41.firebaseapp.com/users", body: body);
		print(response.body);
	}


	Future deleteFromUserFavorites(String userId,
			Restaurant restaurant) async {
		var response = await http.delete(
				"https://lookinmeal-dcf41.firebaseapp.com/userfavs", headers: {"user_id": userId,
			"restaurant_id": restaurant.restaurant_id});
		print(response.body);

	}

	Future addToUserFavorites(String userId,
			Restaurant restaurant) async{
		var response = await http.post(
				"https://lookinmeal-dcf41.firebaseapp.com/userfavs",
				body: {"user_id": userId, "restaurant_id": restaurant.restaurant_id});
		print(response.body);
	}

	Future<List<Restaurant>> getUserFavorites(String id) async {
		var response = await http.get(
				"https://lookinmeal-dcf41.firebaseapp.com/userfavs",
				headers: {"id": id});
		List<Restaurant> restaurants = List<Restaurant>();
		print(response.body);
		List<dynamic> result = json.decode(response.body);
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
          menu: await getMenu(element['restaurant_id'].toString())
			);
			restaurants.add(restaurant);
		}
		print("Number of favorite restaurants : ${restaurants.length}");
		return restaurants;
	}

	Future updateRestaurantData(String taId, String name, String phone,
			String website, String webUrl, String address, String email, String city,
			String country, double latitude,
			double longitude, double rating, int numberViews, List<String> images,
			List<String> types, Map<String, List<int>> schedule, String currency) async {
		Map body = {
			"taid": taId ?? "",
			"name": name,
			"phone": phone ?? "",
			"website": website ?? "",
			"webUrl": webUrl ?? "",
			"address": address,
			"email": email ?? "",
			"city": city,
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
      "currency": currency
		};
		var response = await http.post(
				"https://lookinmeal-dcf41.firebaseapp.com/restaurants", body: body);
		print(response.body);
	}

	Future<List<Restaurant>> getAllRestaurants() async {
		var response = await http.get(
				"https://lookinmeal-dcf41.firebaseapp.com/allrestaurants");
		List<Restaurant> restaurants = List<Restaurant>();
		List<dynamic> result = json.decode(response.body);
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
          menu: await getMenu(element['restaurant_id'].toString())
			);
			restaurants.add(restaurant);
		}
		print("Number of restaurants : ${restaurants.length}");
		return restaurants;
	}

	Future addMenuEntry(String restaurant_id, String name, String section, double price, String image) async{
		Map body = {
			"restaurant_id": restaurant_id,
			"name": name,
			"section": section,
			"price" : price.toString(),
      "image" : image
		};
		var response = await http.post(
				"https://lookinmeal-dcf41.firebaseapp.com/menus", body: body);
		print(response.body);
	}

	Future<List<MenuEntry>> getMenu(String restaurant_id) async {
		List<MenuEntry> menu = List<MenuEntry>();
		var response = await http.get(
				"https://lookinmeal-dcf41.firebaseapp.com/menus",
				headers: {"restaurant_id": restaurant_id});
		List<dynamic> result = json.decode(response.body);
		print(result);
		for(var element in result){
			MenuEntry me = MenuEntry(
				id: element['entry_id'].toString(),
				restaurant_id: element['restaurant_id'].toString(),
				name: element['name'],
				section: element['section'],
				rating: element['rating'] == null ? 0.0 : double.parse(element['rating'].toStringAsFixed(2)),
				numReviews: int.parse(element['numreviews']),
				price: element['price'].toDouble(),
          image: element['image']
			);
			menu.add(me);
		}
		return menu;
	}


	Future addSection(String restaurant_id, String section) async{
		var response = await http.post(
				"https://lookinmeal-dcf41.firebaseapp.com/sections", body: {"restaurant_id" : restaurant_id, "sections" : section});
		print(response.body);
	}


	Future<List<String>> getSections(String restaurant_id) async{
		var response = await http.get(
				"https://lookinmeal-dcf41.firebaseapp.com/sections", headers: {"restaurant_id" : restaurant_id});
		List<dynamic> result = json.decode(response.body);
		List<String> sections =  List<String>.from(result.first['sections']);
		print(sections);
		return sections;
	}


	Future<List<Rating>> getAllRating(String user_id) async{
		List<Rating> ratings = List<Rating>();
		var response = await http.get(
				"https://lookinmeal-dcf41.firebaseapp.com/allrating", headers: {"user_id" : user_id});
		List<dynamic> result = json.decode(response.body);
		for(var element in result){
      ratings.add(Rating(
        entry_id: element["entry_id"].toString(),
        rating: element["rating"].toDouble(),
        date: element["ratedate"].toString().substring(0,10)
      ));
		}
		print(ratings);
		return ratings;
	}

	Future deleteRate(String user_id, String entry_id) async{
    var response = await http.delete(
        "https://lookinmeal-dcf41.firebaseapp.com/rating", headers: {"user_id" : user_id, "entry_id" : entry_id});
    print(response.body);
  }

  Future addRate(String user_id, String entry_id, num rating) async{
		final formatter = new DateFormat('yyyy-MM-dd');
    var response = await http.post(
        "https://lookinmeal-dcf41.firebaseapp.com/rating", body: {"user_id" : user_id, "entry_id" : entry_id, "rating" : rating.toString(), "ratedate" : formatter.format(DateTime.now())});
    print(response.body);
  }

  Future uploadMenu(List<String> sections, List<MenuEntry> menu, Restaurant restaurant)async{
		var response = await http.put("https://lookinmeal-dcf41.firebaseapp.com/sections", body: {"restaurant_id": restaurant.restaurant_id, "sections":sections.toString().replaceAll("[", "").replaceAll("]", "")});
		print(response.body);
		for(MenuEntry entry in menu){
			if(entry.id == null){
				addMenuEntry(entry.restaurant_id, entry.name, entry.section, entry.price, entry.image ?? StaticStrings.defaultEntry);
			}
			else{
				for(MenuEntry entryR in restaurant.menu){
					if(entry.id == entryR.id) {
						if (!(entry.price == entryR.price && entry.name == entryR.name && entry.section == entryR.section)) {
							var response = await http.put("https://lookinmeal-dcf41.firebaseapp.com/menus",
									body: {
										"entry_id": entry.id,
										"name": entry.name,
										"section": entry.section,
										"price": entry.price.toString()
									});
							print("${response.body}    ${entry.name}");
						}
					}
				}
			}
		}
		restaurant.menu = menu;
		restaurant.sections = sections;
	}

}