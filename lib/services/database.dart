import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';

class DBService {

	Future<User> getUserData(String id) async{
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
			favorites: await this.getUserFavorites(id)
		);
		print("User obtained: ${result.first}");
		return user;
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
							element['sections'])
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
			List<String> types, Map<String, List<int>> schedule) async {
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
			"schedule": jsonEncode(schedule) ?? Map<String, List<int>>().toString()
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
							element['sections'])
			);
			restaurants.add(restaurant);
		}
		print("Number of restaurants : ${restaurants.length}");
		return restaurants;
	}

	Future addMenuEntry(String restaurant_id, String name, String section, double price) async{
		Map body = {
			"restaurant_id": restaurant_id,
			"name": name,
			"section": section,
			"rating": 0.0,
			"numReviews": 0,
			"price" : price
		};
		var response = await http.post(
				"https://lookinmeal-dcf41.firebaseapp.com/menus", body: body);
		print(response.body);
	}
}