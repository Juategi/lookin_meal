import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/json_update.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	DBService _dbService = DBService();


	@override
  Widget build(BuildContext context) {
    return Container(
		child: Column(
			children: <Widget>[
				RaisedButton(
					onPressed: ()async{
						//JsonUpdate js = JsonUpdate();
						//await js.updateFromJson("valencia_tripad.json");
						List<Restaurant> restaurants = await _dbService.allrestaurantdata;
						print(restaurants.first.name);
						setState(() {

						});
					},
				)
			],
		),
	);
  }
}
