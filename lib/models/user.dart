import 'package:flutter/cupertino.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';

class User with ChangeNotifier{
	String name,email,picture, country, username;
	final String uid,service;
	List<Restaurant> favorites, recently;
	List<Rating> ratings;
	List<MenuEntry> favoriteEntry;
	Map<String,Restaurant> history;

	set recent(List<Restaurant> l){
		recently = l;
		notifyListeners();
	}

	User({this.uid, this.email, this.name,this.picture,this.favorites,this.service, this.ratings, this.username, this.country, this.favoriteEntry, this.recently, this.history});
}