import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';

class ProfileRestaurant extends StatefulWidget {
	Restaurant restaurant;
	ProfileRestaurant({this.restaurant});
  @override
  _ProfileRestaurantState createState() => _ProfileRestaurantState(restaurant: restaurant);
}

class _ProfileRestaurantState extends State<ProfileRestaurant> {
	Restaurant restaurant;
	_ProfileRestaurantState({this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
