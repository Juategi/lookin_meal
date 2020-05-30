import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
	final GeolocationService _geolocationService = GeolocationService();
	Position myPos;
	User user;
	List<double> distances = List<double>();
	List<Widget> _initTiles(AppLocalizations tr){
		List<Widget> tiles = new List<Widget>();
		for(int i = 0; i < user.favorites.length; i ++){
			tiles.add(
				Card(
					child: ListTile(
						title: Text(user.favorites.elementAt(i).name),
						subtitle: Text(" 📍 ${distances.elementAt(i).toString()} Km"),
						leading: Image.network(user.favorites.elementAt(i).images.first, width: 100, height: 100,),
						trailing: Icon(Icons.arrow_right),
						onTap: () {
							List<Object> args = List<Object>();
							args.add(user.favorites.elementAt(i));
							args.add(distances.elementAt(i));
							args.add(3.0);
							args.add(user);
							Navigator.pushNamed(context, "/restaurant",arguments: args);
						}
					),
				)
			);
		}
		if(tiles.length == 0)
			tiles.add(Text(tr.translate("norestaurants")));
		return tiles;
	}

	void _distances()async {
		if (user.favorites.length == 0) {
			distances = List<double>();
		}
		else{
			myPos = await _geolocationService.getLocation();
			for (Restaurant restaurant in user.favorites) {
				double distance = await _geolocationService.distanceBetween(myPos.latitude, myPos.longitude, restaurant.latitude, restaurant.longitude);
				distances.add(distance);
			}
		}
	}

  @override
  Widget build(BuildContext context) { //PROBLEMA CON EL CÁLCULO DE DISTANCIAS, LO MEJOR SERÁ HACERLO EN OTRO SITIO
	  user = Provider.of<User>(context);
		AppLocalizations tr = AppLocalizations.of(context);
		_distances();
		if(user.favorites.length == distances.length) {
			return Container(
				child: ListView(
					children: _initTiles(tr)
				),
			);
		}
		else
			return Loading();
  }
}
