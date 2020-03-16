import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
	final DBService _dbService = DBService();
	final GeolocationService _geolocationService = GeolocationService();
	User user;
	Position myPos;
	List<Restaurant> restaurants;
	List<double> distances = List<double>();

	//User stream, cada vez que cambie los favs reconstruir restaurantes

	List<Widget> _initTiles(User user){
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
							args.add(user);
							Navigator.pushNamed(context, "/restaurant",arguments: args);
						}
					),
				)
			);
		}
		return tiles;
	}

	void update()async{
		if(user.favorites.length == 0){
			restaurants = List<Restaurant>();
			distances = List<double>();
			return;
		}
		restaurants = await _dbService.getFavorites(user.favorites);
		void _update()async{
			restaurants = await _dbService.allrestaurantdata;
			myPos = await _geolocationService.getLocation();
			for(Restaurant restaurant in restaurants){
				distances.add(await _geolocationService.distanceBetween(myPos.latitude,myPos.longitude, restaurant.latitude, restaurant.longitude));
			}
		}
	}

	@override
  void initState() {
    update();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
		user = Provider.of<User>(context);
	  return restaurants == null || distances.length < restaurants.length? Loading() : Container(
		  child: ListView(
			  children: _initTiles(user)
		  ),
	  );
  }
}
