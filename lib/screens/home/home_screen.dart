import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	User user;
	List<Restaurant> restaurants;

	List<Widget> _initTiles(User user){
		List<Widget> tiles = new List<Widget>();
		for(int i = 0; i < restaurants.length; i ++){
			tiles.add(
				Card(
					child: ListTile(
						title: Text(restaurants.elementAt(i).name),
						subtitle: Text(" 📍 ${restaurants.elementAt(i).distance} Km"),
						leading: Image.network(restaurants.elementAt(i).images.first, width: 100, height: 100,),
						trailing: Icon(Icons.arrow_right),
						onTap: () {
							List<Object> args = List<Object>();
							args.add(restaurants.elementAt(i));
							args.add(user);
							Navigator.pushNamed(context, "/restaurant",arguments: args);
						}
					),
				)
			);
		}
		return tiles;
	}

	@override
  Widget build(BuildContext context) {
		user = Provider.of<User>(context);
		restaurants = Provider.of<List<Restaurant>>(context);
		return Container(
			child: ListView(
				children: _initTiles(user)
			),
		);
  }
}
