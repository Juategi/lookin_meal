import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/translate.dart';

class Restaurant{
	String restaurant_id, ta_id, name, phone, website, webUrl, address, email, city, country,currency;
	double latitude, longitude, rating, distance;
	int numrevta;
	List<String> types, images, sections, dailymenu, delivery;
	Map<String,List<String>> schedule;
	List<MenuEntry> menu;
	List<Translate> english, italian, german, french, spanish, original;

	//Map<String,List<int>> schedule = {'1': new List<int>(), '2': new List<int>(), '3': new List<int>(), '4': new List<int>(), '5': new List<int>(), '6': new List<int>(), '0': new List<int>()};
	Restaurant({this.restaurant_id, this.dailymenu, this.ta_id,this.name,this.phone,this.website,this.webUrl,this.address,this.email,this.city,this.country,this.latitude,this.longitude,this.distance,this.rating,this.numrevta,this.images,this.types,this.schedule, this.currency,this.sections, this.menu, this.delivery});
}