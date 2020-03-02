import 'package:flutter/material.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

	final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
	  final user = Provider.of<User>(context);
	  AppLocalizations tr = AppLocalizations.of(context);
	  return Scaffold(
		backgroundColor: Colors.brown[50],
		appBar: AppBar(
			title: Text("LookinMeal"),
			backgroundColor: Colors.brown[400],
			elevation: 0.0,
			actions: <Widget>[
				FlatButton.icon(
					onPressed: ()async{
						await _auth.signOut();
					},
					icon: Icon(Icons.people),
					label: Text(tr.translate("signout"))
				),
			],
		),
		body: Container(),
	);
  }
}
