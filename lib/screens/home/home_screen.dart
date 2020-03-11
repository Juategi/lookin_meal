import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/json_update.dart';
import 'package:lookinmeal/shared/loading.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	DBService _dbService = DBService();
	GeolocationService _geolocationService = GeolocationService();
	Position myPos;
	List<Restaurant> restaurants;
	List<double> distances = List<double>();

	@override
	initState(){
		_update();
		super.initState();
	}
	void _update()async{
		restaurants = await _dbService.allrestaurantdata;
		myPos = await _geolocationService.getLocation();
		for(Restaurant restaurant in restaurants){
			distances.add(await _geolocationService.distanceBetween(myPos.latitude,myPos.longitude, restaurant.latitude, restaurant.longitude));
		}
	}
	@override
  Widget build(BuildContext context) {
    return restaurants == null || distances.length < 4 ? Loading() : Container(
		child: ListView(
			children: <Widget>[
				Card(
				  child: ListTile(
				  		title: Text(restaurants.elementAt(0).name),
				  		subtitle: Text(distances.elementAt(0).toString()),
				  		leading: Image.network(restaurants.elementAt(0).images.first, width: 100, height: 100,),
				  		trailing: Icon(Icons.arrow_right),
				  ),
				),
				Card(
					child: ListTile(
						title: Text(restaurants.elementAt(1).name),
						subtitle: Text(distances.elementAt(1).toString()),
						leading: Image.network(restaurants.elementAt(1).images.first, width: 100, height: 100,),
						trailing: Icon(Icons.arrow_right),
					),
				),
				Card(
					child: ListTile(
						title: Text(restaurants.elementAt(2).name),
						subtitle: Text(distances.elementAt(2).toString()),
						leading: Image.network(restaurants.elementAt(2).images.first, width: 100, height: 100,),
						trailing: Icon(Icons.arrow_right),
					),
				),
				Card(
					child: ListTile(
						title: Text(restaurants.elementAt(3).name),
						subtitle: Text(distances.elementAt(3).toString()),
						leading: Image.network(restaurants.elementAt(3).images.first, width: 100, height: 100,),
						trailing: Icon(Icons.arrow_right),
					),
				)
			],
		),
	);
  }
}
