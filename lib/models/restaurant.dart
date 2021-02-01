import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/reservation.dart';
import 'package:lookinmeal/models/table.dart';
import 'package:lookinmeal/models/translate.dart';

class Restaurant{
	String restaurant_id, ta_id, name, phone, website, webUrl, address, email, city, country,currency;
	double latitude, longitude, rating, distance;
	num mealtime;
	int numrevta;
	List<String> types, images, sections, dailymenu, delivery;
	Map<String,List<String>> schedule;
	List<MenuEntry> menu;
	List<Translate> english, italian, german, french, spanish, original;
	List<RestaurantTable> tables;
	Map<String, List<Reservation>> reservations;

	Restaurant({this.restaurant_id, this.mealtime, this.reservations, this.tables, this.dailymenu, this.ta_id,this.name,this.phone,this.website,this.webUrl,this.address,this.email,this.city,this.country,this.latitude,this.longitude,this.distance,this.rating,this.numrevta,this.images,this.types,this.schedule, this.currency,this.sections, this.menu, this.delivery});
}