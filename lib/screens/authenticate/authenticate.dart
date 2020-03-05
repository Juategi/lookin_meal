import 'package:lookinmeal/services/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:lookinmeal/services/auth.dart';

class Authenticate extends StatefulWidget {

	@override
	_AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

	final AuthService _auth = AuthService();

	@override
	Widget build(BuildContext context) {
		AppLocalizations tr = AppLocalizations.of(context);
		return Scaffold(
			backgroundColor: Colors.brown[100],
			appBar: AppBar(
				backgroundColor: Colors.brown[400],
				elevation: 0.0,
				title: Text(tr.translate("app")),
			),
			body: Container(
				padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
				child: Column(
					children: <Widget>[
						SizedBox(height: 20,),
						RaisedButton(
							color: Colors.pink[400],
							onPressed: () async{
								await Navigator.pushNamed(context, "/login");
							},
							child: Text(tr.translate("login"), style: TextStyle(color: Colors.white),),
						),
						SizedBox(height: 20,),
						RaisedButton(
							color: Colors.pink[400],
							onPressed: () async{
								await Navigator.pushNamed(context, "/signin");
							},
							child: Text(tr.translate("register"), style: TextStyle(color: Colors.white),),
						),
						SizedBox(height: 60,),
						FlatButton(
							padding: EdgeInsets.all(0),
							child: Image.asset("assets/fb.bmp"),
							onPressed: () async{
								dynamic result = await _auth.loginFB();
							}
							),
						SizedBox(height: 20,),
						FlatButton(
							padding: EdgeInsets.all(0),
							child: Image.asset("assets/google.PNG"),
							onPressed: () async{
								dynamic result = await _auth.loginGoogle();
							}
							),
					],
				)
			)
		);
	}
}