import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';

class User{
	String name,email,picture;
	final String uid,service;
	List<Restaurant> favorites;
	List<Rating> ratings;
	User({this.uid, this.email, this.name,this.picture,this.favorites,this.service, this.ratings});
}