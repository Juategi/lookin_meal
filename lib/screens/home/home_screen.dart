import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';



class HomeScreen extends StatefulWidget {
	Position myPos;
	List<Restaurant> restaurants;
	List<double> distances = List<double>();
	HomeScreen({this.myPos,this.distances,this.restaurants});
  @override
  _HomeScreenState createState() => _HomeScreenState(myPos: myPos, restaurants: restaurants,distances: distances,);
}

class _HomeScreenState extends State<HomeScreen> {
	_HomeScreenState({this.myPos,this.distances,this.restaurants});
	final DBService _dbService = DBService();
	final GeolocationService _geolocationService = GeolocationService();
	Position myPos;
	List<Restaurant> restaurants;
	List<double> distances = List<double>();


	List<Widget> _initTiles(){
		List<Widget> tiles = new List<Widget>();
		for(int i = 0; i < restaurants.length; i ++){
			tiles.add(
				Card(
					child: ListTile(
						title: Text(restaurants.elementAt(i).name),
						subtitle: Text(" 📍 ${distances.elementAt(i).toString()} Km"),
						leading: Image.network(restaurants.elementAt(i).images.first, width: 100, height: 100,),
						trailing: Icon(Icons.arrow_right),
						onTap: () {
							List<Object> args = List<Object>();
							args.add(restaurants.elementAt(i));
							args.add(distances.elementAt(i));
							Navigator.pushNamed(context, "/restaurant",arguments: args);
						}
					),
				)
			);
		}
		return tiles;
	}
	@override
	initState(){
		super.initState();
	}

	@override
  Widget build(BuildContext context) {
    return Container(
		child: ListView(
			children: _initTiles()
		),
	);
  }
}
