import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/edit_images.dart';
import 'package:lookinmeal/screens/restaurants/menu.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/alert.dart';

class ProfileRestaurant extends StatefulWidget {
  @override
  _ProfileRestaurantState createState() => _ProfileRestaurantState();
}

class _ProfileRestaurantState extends State<ProfileRestaurant> {
	Restaurant restaurant;

	void _loadMenu()async{
		restaurant.menu = await DBService().getMenu(restaurant.restaurant_id);
	}

	void _timer() {
		if(restaurant.menu == null) {
			Future.delayed(Duration(seconds: 2)).then((_) {
				setState(() {
					print("Loading menu...");
				});
				_timer();
			});
		}
	}

  @override
  Widget build(BuildContext context) {
  	var args = List<Object>.of(ModalRoute.of(context).settings.arguments);
  	restaurant = args.first;
		_timer();
  	if(restaurant.menu == null)
  		_loadMenu();
		User user = args.last;
	  final DBService _dbService = DBService();
    return Scaffold(
			appBar: AppBar(),
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
					"${restaurant.name}    ${restaurant.distance} Km",
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
				IconButton(
					icon: user.favorites.contains(restaurant) ? Icon(Icons.favorite) :Icon(Icons.favorite_border),
					iconSize: 50,
					onPressed: ()async{
						if(user.favorites.contains(restaurant)) {
							user.favorites.remove(restaurant);
							_dbService.deleteFromUserFavorites(user.uid, restaurant);
						}
						else {
							user.favorites.add(restaurant);
							_dbService.addToUserFavorites(user.uid, restaurant);
						}
						setState(() {});
					},

				),
					SizedBox(height: 40,),
					SizedBox(width: 10,),
					RaisedButton(
						child: Text("Edit Restaurant"),
						onPressed: ()async{
							Navigator.pushNamed(context, "/editrestaurant",arguments: restaurant).then((value) => setState(() {}));
						},
					),
					RaisedButton(
						child: Text("Edit photos"),
						onPressed: ()async{
							showModalBottomSheet(context: context, builder: (BuildContext bc){
								return EditImages(restaurant: restaurant,);
							}).then((value){setState(() {});});
						},
					),
					RaisedButton(
						child: Text("Edit Menu"),
						onPressed: ()async{
							Navigator.pushNamed(context, "/editmenu",arguments: restaurant).then((value) => setState(() {}));
						},
					),
					restaurant.menu == null? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),) : Menu(sections: restaurant.sections, menu: restaurant.menu, currency: restaurant.currency, user: user)
      	],
      ),
    );
  }
}
