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
	final DBService _dbService = DBService();
	final GeolocationService _geolocationService = GeolocationService();
	Position myPos;
	User user;
	List<Restaurant> restaurants;
	List<double> distances = List<double>();

	List<Widget> _initTiles(AppLocalizations tr){
		List<Widget> tiles = new List<Widget>();
		for(int i = 0; i < restaurants.length; i ++){
			tiles.add(
				Card(
					child: ListTile(
						title: Text(restaurants.elementAt(i).name),
						//subtitle: Text(" 📍 ${distances.elementAt(i).toString()} Km"),
						leading: Image.network(restaurants.elementAt(i).images.first, width: 100, height: 100,),
						trailing: Icon(Icons.arrow_right),
						onTap: () {
							List<Object> args = List<Object>();
							args.add(restaurants.elementAt(i));
							//args.add(distances.elementAt(i));
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

	void _update()async {
		if (user.favorites.length == 0) {
			restaurants = List<Restaurant>();
			distances = List<double>();
		}
		else{
			restaurants = await _dbService.getFavorites(user.favorites);
			myPos = await _geolocationService.getLocation();
			for (Restaurant restaurant in restaurants) {
				double distance = await _geolocationService.distanceBetween(myPos.latitude, myPos.longitude, restaurant.latitude, restaurant.longitude);
				distances.add(distance);
			}
		}
	}

  @override
  Widget build(BuildContext context) { //PROBLEMA CON EL CÁLCULO DE DISTANCIAS, LO MEJOR SERÁ HACERLO EN OTRO SITIO
	  user = Provider.of<User>(context);
		AppLocalizations tr = AppLocalizations.of(context);
	  return StreamBuilder<User>(
		  	stream: DBService(uid: user.uid).userdata,
	  		builder: (context, snapshot) {
		  		if(snapshot.hasData) {
					user = snapshot.data;
					_update();
					if(restaurants != null) {
						return Container(
							child: ListView(
								children: _initTiles(tr)
							),
						);
					}
					else
						return Loading();
				}
		  		else
		  			return Loading();
  			}
	  );
  }
}
