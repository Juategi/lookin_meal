import 'package:flutter/material.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/menu.dart';
import 'package:lookinmeal/services/database.dart';

class ProfileRestaurant extends StatefulWidget {
  @override
  _ProfileRestaurantState createState() => _ProfileRestaurantState();
}

class _ProfileRestaurantState extends State<ProfileRestaurant> {
	Restaurant restaurant;
	double distance;
	String plato, section;
	double precio;

  @override
  Widget build(BuildContext context) {
  	var args = List<Object>.of(ModalRoute.of(context).settings.arguments);
  	restaurant = args.first;
  	distance = args.elementAt(1);
  	User user = args.last;
	final DBService _dbService = DBService();
    return Scaffold(
      body: ListView(
      	children: <Widget>[
      		Container(
				height: 230,
				width: 400,
				decoration: BoxDecoration(
					image: DecorationImage(
						image: NetworkImage(restaurant.images.elementAt(0)),
						fit: BoxFit.fill,
					),
				),
			),
				SizedBox(height: 20,),
				Text(
					"${restaurant.name}    $distance Km",
					style: TextStyle(
						color: Colors.grey[800],
						fontWeight: FontWeight.w900,
						fontStyle: FontStyle.italic,
						fontFamily: 'Open Sans',
						fontSize: 15
					),
				),
				SizedBox(height: 20,),
				Text(
					"Rating: ${restaurant.rating.toString()}",
					style: TextStyle(
						color: Colors.grey[800],
						fontWeight: FontWeight.w900,
						fontStyle: FontStyle.italic,
						fontFamily: 'Open Sans',
						fontSize: 15
					),
				),
				SizedBox(height: 20,),
				Text(
					restaurant.address ?? " ",
					style: TextStyle(
						color: Colors.grey[800],
						fontWeight: FontWeight.w900,
						fontStyle: FontStyle.italic,
						fontFamily: 'Open Sans',
						fontSize: 15
					),
				),
				SizedBox(height: 20,),
				Text(
					restaurant.email ?? " ",
					style: TextStyle(
						color: Colors.grey[800],
						fontWeight: FontWeight.w900,
						fontStyle: FontStyle.italic,
						fontFamily: 'Open Sans',
						fontSize: 15
					),
				),
				SizedBox(height: 20,),
				Text(
					restaurant.phone ?? " ",
					style: TextStyle(
						color: Colors.grey[800],
						fontWeight: FontWeight.w900,
						fontStyle: FontStyle.italic,
						fontFamily: 'Open Sans',
						fontSize: 15
					),
				),
				SizedBox(height: 20,),
				Text(
					restaurant.website ?? " ",
					style: TextStyle(
						color: Colors.grey[800],
						fontWeight: FontWeight.w900,
						fontStyle: FontStyle.italic,
						fontFamily: 'Open Sans',
						fontSize: 15
					),
				),
				SizedBox(height: 20,),
				Text(
					restaurant.schedule == null ? " " : restaurant.schedule.toString(),
					style: TextStyle(
						color: Colors.grey[800],
						fontWeight: FontWeight.w900,
						fontStyle: FontStyle.italic,
						fontFamily: 'Open Sans',
						fontSize: 15
					),
				),
				SizedBox(height: 20,),
				Text(
					restaurant.types == null ? " " : restaurant.types.toString(),
					style: TextStyle(
						color: Colors.grey[800],
						fontWeight: FontWeight.w900,
						fontStyle: FontStyle.italic,
						fontFamily: 'Open Sans',
						fontSize: 15
					),
				),
				SizedBox(height: 20,),
				RaisedButton(
					child: Text("Fav"),
					onPressed: ()async{
						if(user.favorites.contains(restaurant)) {
							user.favorites.remove(restaurant);
							await _dbService.deleteFromUserFavorites(user.uid, restaurant);
						}
						else {
							user.favorites.add(restaurant);
							await _dbService.addToUserFavorites(user.uid, restaurant);
						}
					},
				),/*
					TextFormField(
							onChanged: (value){
								setState(() => plato = value);
							},
						initialValue: "plato",
					),
					SizedBox(width: 10,),
					TextFormField(
						onChanged: (value){
							setState(() => section = value);
						},
						initialValue: "section",
					),
					SizedBox(width: 10,),
					TextFormField(
						onChanged: (value){
							setState(() => precio = double.parse(value));
						},
						initialValue: "precio",
					),
					SizedBox(width: 10,),
					RaisedButton(
						child: Text("add"),
						onPressed: ()async{
							await _dbService.addMenuEntry(restaurant.restaurant_id, plato, section, precio);
						},
					)*/
					Menu(sections: restaurant.sections, menu: restaurant.menu, currency: restaurant.currency, user: user)
      	],
      ),
    );
  }
}
