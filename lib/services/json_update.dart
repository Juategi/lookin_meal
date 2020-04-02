import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:lookinmeal/services/newdatabase.dart';

class JsonUpdate{

	String id, name, phone, website, webUrl, address, email, city, country,image;
	double latitude, longitude, rating;
	int numberViews;
	List<String> types, images;
	Map<String,List<int>> schedule = {'1': new List<int>(), '2': new List<int>(), '3': new List<int>(), '4': new List<int>(), '5': new List<int>(), '6': new List<int>(), '0': new List<int>()};

	Future updateFromJson(String jsonFile, int index) async{
		String jsonString = await rootBundle.loadString('dbjson/$jsonFile');
		List<dynamic> restaurants = json.decode(jsonString);
		Map<String, dynamic> place = restaurants.elementAt(index);
    DBServiceN _dbService = DBServiceN();
		id = place['id'];
		name = place['name'];
		rating = double.parse(place['rating']);
		phone = place['phone'];
		address = place['address'];
		email = place['email'];
		country = place['address'].split(" ").last;
		city = place['address'].split(" ").reversed.elementAt(1);
		latitude = double.parse(place['latitude']);
		longitude = double.parse(place['longitude']);
		website = place['website'];
		webUrl = place['webUrl'];
		numberViews = int.parse(place['numberOfReviews']);
		types = List<String>.from(place['cuisine']);
		if(place['hours'].length != 0) {
			for (int i = 0; i < 7; i++) {
				schedule[i.toString()].clear();
				for (dynamic hour in place['hours'].elementAt(
					i)) {
					int formattedHour = hour['open'] ~/ 60;
					if (formattedHour >= 24) {
						formattedHour -= 24;
					}
					schedule[i.toString()].add(formattedHour);
					formattedHour = hour['close'] ~/ 60;
					if (formattedHour >= 24) {
						formattedHour -= 24;
					}
					schedule[i.toString()].add(formattedHour);
				}
			}
		}
		else
			schedule = null;
		var response = await http.get(webUrl);
		var document = parse(response.body);
		images = new List<String>();
		for(int i = 0; i <document.getElementsByClassName('basicImg').length; i++){
			image = document.getElementsByClassName('basicImg').elementAt(i).attributes['data-lazyurl'];
			if(image.contains("avatar"))
				break;
			images.add(image);
		}
		images = images.toSet().toList();
		dynamic result = await _dbService.updateRestaurantData(id,name, phone, website, webUrl, address, email, city, country, latitude, longitude, rating, numberViews, images, types, schedule);
		print("Update completed ");
	}
}