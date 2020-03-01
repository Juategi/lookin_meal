
import 'package:lookinmeal/services/app_localizations.dart';

import 'sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {

	@override
	_AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

	@override
	Widget build(BuildContext context) {
		AppLocalizations tr = AppLocalizations.of(context);
		return Scaffold(
			backgroundColor: Colors.brown[100],
			appBar: AppBar(
				backgroundColor: Colors.brown[400],
				elevation: 0.0,
				title: Text("LookinMeal"),
			),
			body: Container(
				padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
				child: Column(
					children: <Widget>[
						SizedBox(height: 20,),
						RaisedButton(
							color: Colors.pink[400],
							onPressed: null,
							child: Text(tr.translate("login"), style: TextStyle(color: Colors.white),),
						),
						SizedBox(height: 20,),
						RaisedButton(
							color: Colors.pink[400],
							onPressed: null,
							child: Text(tr.translate("register"), style: TextStyle(color: Colors.white),),
						),
						SizedBox(height: 60,),
						FlatButton(
							padding: EdgeInsets.all(0),
							child: Image.asset("assets/fb.bmp"),
							onPressed: null,
							),
						SizedBox(height: 20,),
						FlatButton(
							padding: EdgeInsets.all(0),
							child: Image.asset("assets/google.PNG"),
							onPressed: null,
							),
					],
				)
			)
		);
	}
}