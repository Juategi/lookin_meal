import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

	String id, name, phone, website, address, email, city, country;
	double latitude, longitude, rating;
	int numberViews;
	List<String> types;
	Map<String,List<int>> schedule = {'1': new List<int>(), '2': new List<int>(), '3': new List<int>(), '4': new List<int>(), '5': new List<int>(), '6': new List<int>(), '0': new List<int>()};

  @override
  Widget build(BuildContext context) {
    return Container(
		child: Column(
			children: <Widget>[
				RaisedButton(
					onPressed: ()async{
						var client = http.Client();
						var url = 'https://www.google.com/search?q=honoo&safe=active&client=firefox-b-d&hl=es&sxsrf=ALeKk016Erw4DAkV7kl1yeCC52Cci_01YA:1583780051438&source=lnms&tbm=isch&sa=X&ved=2ahUKEwi22fi6iI7oAhWMVBUIHaChBBMQ_AUoA3oECCMQBQ&biw=1600&bih=786';
						var response = await http.get(url);
						var document = parse(response.body);
						var priceElement = document.getElementsByTagName("div").first.outerHtml;
						print(priceElement);
						String jsonString = await rootBundle.loadString('dbjson/valencia_tripad.json');
						List<dynamic> restaurants = json.decode(jsonString);
						Map<String, dynamic> place = restaurants.elementAt(104);
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
						numberViews = int.parse(place['numberOfReviews']);
						types = List<String>.from(place['cuisine']);
						for(int i = 0; i < 7; i++){
							schedule[i.toString()].clear();
							for(dynamic hour in place['hours'].elementAt(i)){
								int formattedHour = hour['open']~/60;
								if(formattedHour >= 24){
									formattedHour -= 24;
								}
								schedule[i.toString()].add(formattedHour);
								formattedHour = hour['close']~/60;
								if(formattedHour >= 24){
									formattedHour -= 24;
								}
								schedule[i.toString()].add(formattedHour);
							}
						}
						print(name);
						print(id);
						print(phone);
						print(website);
						print(address);
						print(country);
						print(city);
						print(email);
						print(latitude);
						print(longitude);
						print(rating);
						print(numberViews);
						print(types);
						print(schedule);
						setState(() {

						});
					},
				)
			],
		),
	);
  }
}
