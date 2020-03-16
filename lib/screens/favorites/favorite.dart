import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/json_update.dart';

class Favorites extends StatefulWidget {
	User user;
	Favorites({this.user});
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
	final User user;
	List<Restaurant> restaurants;
	_FavoritesState({this.user});

	//User stream

	List<Widget> _initTiles(User user){
		List<Widget> tiles = new List<Widget>();

		return tiles;
	}

  @override
  Widget build(BuildContext context) {
	  return Container(
		  child: ListView(
			  children: _initTiles(user)
		  ),
	  );
  }
}
