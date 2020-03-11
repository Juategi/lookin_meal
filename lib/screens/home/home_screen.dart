import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/json_update.dart';
import 'package:lookinmeal/shared/loading.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	DBService _dbService = DBService();
	List<Restaurant> restaurants;

	@override
	initState(){
		_update();
		super.initState();
	}
	void _update()async{
		restaurants = await _dbService.allrestaurantdata;
	}
	@override
  Widget build(BuildContext context) {
    return restaurants == null ? Loading() : Container(
		child: ListView(
			children: <Widget>[
				Card(
				  child: ListTile(
				  		title: Text(restaurants.elementAt(0).name),
				  		subtitle: Text(restaurants.elementAt(0).address),
				  		leading: Image.network(restaurants.elementAt(0).images.first),
				  		trailing: Icon(Icons.arrow_right),
				  ),
				),
				Card(
					child: ListTile(
						title: Text(restaurants.elementAt(1).name),
						subtitle: Text(restaurants.elementAt(1).address),
						leading: Image.network(restaurants.elementAt(1).images.first),
						trailing: Icon(Icons.arrow_right),
					),
				),
				Card(
					child: ListTile(
						title: Text(restaurants.elementAt(2).name),
						subtitle: Text(restaurants.elementAt(2).address),
						leading: Image.network(restaurants.elementAt(2).images.first),
						trailing: Icon(Icons.arrow_right),
					),
				),
				Card(
					child: ListTile(
						title: Text(restaurants.elementAt(3).name),
						subtitle: Text(restaurants.elementAt(3).address),
						leading: Image.network(restaurants.elementAt(3).images.first),
						trailing: Icon(Icons.arrow_right),
					),
				)
			],
		),
	);
  }
}
