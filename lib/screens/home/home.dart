import 'package:flutter/material.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
	final AuthService _auth = AuthService();

	int _selectedIndex = 0;
	TabController _tabController;
	void _onItemTapped(int index) {
		setState(() {
			_selectedIndex = index;
		});
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
						title: Text("LookinMeal"),
						backgroundColor: Colors.brown[400],
						elevation: 0.0,
						actions: <Widget>[
							FlatButton.icon(
								onPressed: () async {
									await _auth.signOut();
								},
								icon: Icon(Icons.people),
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
									child: Container(child: Text("hola1"),),
								),
							),
							Offstage(
								offstage: _selectedIndex != 1,
								child: TickerMode(
									enabled: _selectedIndex == 1,
									child: Container(child: Text("hola2"),),
								),
							)
						],
					),
					bottomNavigationBar: BottomNavigationBar(
						backgroundColor: Colors.brown[200],
						type: BottomNavigationBarType.fixed,
						items: const <BottomNavigationBarItem>[
							BottomNavigationBarItem(
								icon: Icon(Icons.home),
								title: Text('Home'),
							),
							BottomNavigationBarItem(
								icon: Icon(Icons.map),
								title: Text('Map'),
							),
							BottomNavigationBarItem(
								icon: Icon(Icons.album),
								title: Text('Add'),
							),
							BottomNavigationBarItem(
								icon: Icon(Icons.favorite),
								title: Text('Favorites'),
							),
							BottomNavigationBarItem(
								icon: Icon(Icons.person),
								title: Text('Profile'),
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
