import 'package:flutter/cupertino.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/reservation.dart';
import 'package:lookinmeal/models/restaurant.dart';

class User with ChangeNotifier{
	String name,email,picture, country, username;
	final String uid,service;
	List<Restaurant> favorites, recently;
	List<Rating> ratings;
	List<MenuEntry> favoriteEntry;
	Map<String,Restaurant> history;
	List<FavoriteList> lists;
	List<Reservation> reservations;
	bool inOrder;

	set recent(List<Restaurant> l){
		recently = l;
		notifyListeners();
	}

	User({this.uid, this.reservations, this.inOrder, this.email, this.name,this.picture,this.favorites,this.service, this.ratings, this.username, this.country, this.favoriteEntry, this.recently, this.history, this.lists});
}