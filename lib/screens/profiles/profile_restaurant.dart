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
    return Column(
    	children: <Widget>[
    		Stack(
    			children: <Widget>[
    				Container(
						child: Center(
							child: Text(
								restaurant.schedule.toString(),
								style: TextStyle(
									color: Colors.grey[800],
									fontWeight: FontWeight.w900,
									fontStyle: FontStyle.italic,
									fontFamily: 'Open Sans',
									fontSize: 22
								),
							)
						),
						height: 230,
						width: 400,
						decoration: BoxDecoration(
							image: DecorationImage(
								image: NetworkImage(restaurant.images.elementAt(0)),
								fit: BoxFit.fill,
							),
						),
					)
    			],
    		),
    	],
    );
  }
}
