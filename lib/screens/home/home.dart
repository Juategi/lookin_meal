import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/favorites/favorites.dart';
import 'package:lookinmeal/screens/home/home_screen.dart';
import 'package:lookinmeal/screens/profile/profile.dart';
import 'package:lookinmeal/screens/stars/stars.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:lookinmeal/screens/map/map.dart';



class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
	final AuthService _auth = AuthService();
	final DBService _dbService = DBService();
	final GeolocationService _geolocationService = GeolocationService();
	User user;
	String id;
	String locality;
	Position myPos;
	List<Restaurant> restaurants;
	List<double> distances = List<double>();
	int _selectedIndex = 0;
	bool flag = true;
	bool ready = false;

	void _onItemTapped(int index) {
		setState(()  {
			_selectedIndex = index;
		});
	}

	void _timer() {
		if(flag) {
			Future.delayed(Duration(seconds: 2)).then((_) {
				setState(() {
					print("2 second closer to NYE!");
				});
				_timer();
			});
		}
	}


	void _update()async{
		myPos = await _geolocationService.getLocation();
		locality = await _geolocationService.getLocality(myPos.latitude, myPos.longitude);
		List<Restaurant> aux;
		aux = await _dbService.getNearRestaurants(myPos.latitude, myPos.longitude, locality.toUpperCase()); //Faltaria obtener la ciudad dada tu posicion
		Pool.addRestaurants(aux);
		restaurants = Pool.restaurants;
		/*for(Restaurant restaurant in restaurants){
			distances.add(await _geolocationService.distanceBetween(myPos.latitude,myPos.longitude, restaurant.latitude, restaurant.longitude));
		}*/
		ready = true;
	}

	@override
	Future<bool> didPopRoute() async {
		if(_selectedIndex == 0)
			return false;
		else {
			setState(() {
				_selectedIndex = 0;
			});
			return Future<bool>.value(true);
		}
	}

	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
		_update();
		_timer();
	}

	@override
  Widget build(BuildContext context) {
	  user = Provider.of<User>(context);
	  AppLocalizations tr = AppLocalizations.of(context);
	  if(ready && user != null) {
	  	flag = false;
			return Scaffold(
						backgroundColor: Colors.brown[50],
						appBar: AppBar(
							//title: Text(tr.translate("app")),
							title: Text(locality),
							backgroundColor: Colors.brown[400],
							elevation: 0.0,
							//bottom: TabBar(tabs: <Widget>[IconButton(icon: Icon(Icons.search), onPressed: (){},)],),
						),
						body: Stack(
							children: <Widget>[
								Offstage(
									offstage: _selectedIndex != 0,
									child: TickerMode(
										enabled: _selectedIndex == 0,
										child: HomeScreen(myPos: myPos,
												restaurants: restaurants,
												locality: locality),
									),
								),
								Offstage(
									offstage: _selectedIndex != 1,
									child: TickerMode(
										enabled: _selectedIndex == 1,
										child: Stars(locality: locality, myPos: myPos,),
									),
								),
								Offstage(
									offstage: _selectedIndex != 2,
									child: TickerMode(
											enabled: _selectedIndex == 2,
											child: MapSample()
									),
								),
								Offstage(
									offstage: _selectedIndex != 3,
									child: TickerMode(
										enabled: _selectedIndex == 3,
										child: Favorites(),
									),
								),
								Offstage(
									offstage: _selectedIndex != 4,
									child: TickerMode(
											enabled: _selectedIndex == 4,
											child: Profile()
									),
								),
							],
						),
						bottomNavigationBar: BottomNavigationBar(
							backgroundColor: Colors.brown[200],
							type: BottomNavigationBarType.fixed,
							items: <BottomNavigationBarItem>[
								BottomNavigationBarItem(
									icon: Icon(Icons.home),
									title: Text(tr.translate("home")),
								),
								BottomNavigationBarItem(
									icon: Icon(Icons.search),
									title: Text("Search"),
								),
								BottomNavigationBarItem(
									icon: Icon(Icons.map),
									title: Text(tr.translate("map")),
								),
								BottomNavigationBarItem(
									icon: Icon(Icons.favorite),
									title: Text(tr.translate("fav")),
								),
								BottomNavigationBarItem(
									icon: Icon(Icons.person),
									title: Text(tr.translate("profile")),
								),
							],
							currentIndex: _selectedIndex,
							selectedItemColor: Colors.amber[800],
							onTap: _onItemTapped,
						)
					);
		}
	  else
	  	return Loading();
  }
}
