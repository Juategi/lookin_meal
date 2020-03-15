import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/favorites/favorite.dart';
import 'package:lookinmeal/screens/home/home_screen.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
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
	Position myPos;
	List<Restaurant> restaurants;
	List<double> distances = List<double>();
	int _selectedIndex = 0;
	bool flag = true;


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
		restaurants = await _dbService.allrestaurantdata;
		myPos = await _geolocationService.getLocation();
		for(Restaurant restaurant in restaurants){
			distances.add(await _geolocationService.distanceBetween(myPos.latitude,myPos.longitude, restaurant.latitude, restaurant.longitude));
		}
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
	  final user = Provider.of<User>(context);
	  AppLocalizations tr = AppLocalizations.of(context);
	  return StreamBuilder<User>(
		  stream: DBService(uid: user.uid).userdata,
		  builder: (context, snapshot) {
			if (snapshot.hasData & (restaurants != null) & (distances.length >= 4)) {
				User userData = snapshot.data;
				flag = false;
				return Scaffold(
					backgroundColor: Colors.brown[50],
					appBar: AppBar(
						title: Text(tr.translate("app")),
						backgroundColor: Colors.brown[400],
						elevation: 0.0,
						actions: <Widget>[
							FlatButton.icon(
								onPressed: () async {
									await _auth.signOut();
								},
								icon: Icon(Icons.exit_to_app),
								label: Text(tr.translate("signout"))
							),
						],
					),
					body: Stack(
						children: <Widget>[
							Offstage(
								offstage: _selectedIndex != 0,
								child: TickerMode(
									enabled: _selectedIndex == 0,
									child: HomeScreen(myPos: myPos, restaurants: restaurants,distances: distances,),
								),
							),
							Offstage(
								offstage: _selectedIndex != 1,
								child: TickerMode(
									enabled: _selectedIndex == 1,
									child: Container(child: Text("STAR"),),
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
									child: Container(child: Text("PROFILE"),),
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
								icon: Icon(Icons.star),
								title: Text("Stars"),
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
		});
  }
}
