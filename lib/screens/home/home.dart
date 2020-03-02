import 'package:flutter/material.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

	final AuthService _auth = AuthService();

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
					body: Container(
						child: Column(
							children: <Widget>[
								Image.network(userData.picture),
							],
						),
					),
				);
			}
			else
				return Loading();
		});
  }
}
