import 'package:lookinmeal/models/restaurant.dart';

class User{
	String name,email,picture;
	final String uid,service;
	List<Restaurant> favorites;
	List<num> ratings;
	User({this.uid, this.email, this.name,this.picture,this.favorites,this.service, this.ratings});
}