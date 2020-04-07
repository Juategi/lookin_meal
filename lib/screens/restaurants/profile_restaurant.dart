import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/database.dart';

class ProfileRestaurant extends StatefulWidget {
  @override
  _ProfileRestaurantState createState() => _ProfileRestaurantState();
}

class _ProfileRestaurantState extends State<ProfileRestaurant> {
	Restaurant restaurant;
	double distance;

  @override
  Widget build(BuildContext context) {
  	var args = List<Object>.of(ModalRoute.of(context).settings.arguments);
  	restaurant = args.first;
  	distance = args.elementAt(1);
  	User user = args.last;
	final DBService _dbService = DBService();
    return Scaffold(
      body: Column(
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
						print(user.name);
						print(restaurant.restaurant_id);
						user.favorites = await _dbService.updateUserFavorites(user.uid, restaurant);
					},
				)
      	],
      ),
    );
  }
}
