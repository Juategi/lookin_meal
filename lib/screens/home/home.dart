import 'package:flutter/material.dart';
import 'package:lookinmeal/models/user.dart';
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
	final GeolocationService _geolocationService = GeolocationService();
	int _selectedIndex = 0;
	void _onItemTapped(int index) {
		setState(()  {
			_selectedIndex = index;
		});
	}

	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
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
  Widget build(BuildContext context) {
	  final user = Provider.of<User>(context);
	  AppLocalizations tr = AppLocalizations.of(context);
	  return StreamBuilder<User>(
		  stream: DBService(uid: user.uid).userdata,
		  builder: (context, snapshot) {
			if (snapshot.hasData) {
				User userData = snapshot.data;
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
									child: Container(child: Text("HOME"),),
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
									child: Container(child: Text("FAV"),),
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
