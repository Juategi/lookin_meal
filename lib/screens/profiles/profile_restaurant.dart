import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';

class ProfileRestaurant extends StatefulWidget {
  @override
  _ProfileRestaurantState createState() => _ProfileRestaurantState();
}

class _ProfileRestaurantState extends State<ProfileRestaurant> {
	Restaurant restaurant;


  @override
  Widget build(BuildContext context) {
  	restaurant = ModalRoute.of(context).settings.arguments;
  	print(restaurant.name);
    return Container();
  }
}
