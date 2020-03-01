import 'package:flutter/material.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/shared/decos.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

	final AuthService _auth = AuthService();
	final _formKey = GlobalKey<FormState>();
	String email, password, error, name = " ";

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
			  child: Form(
				  key: _formKey,
			    child: Column(
					  children: <Widget>[
				  SizedBox(height: 20,),
				  TextFormField(
					  onChanged: (value){
						  setState(() => email = value);
					  },
					  validator: (val) => val.isEmpty ? "Enter email" : null,
					  decoration: textInputDeco.copyWith(hintText: "Email")
				  ),
				  SizedBox(height: 20,),
				  TextFormField(
					  obscureText: true,
					  onChanged: (value){
						  setState(() => password = value);
					  },
					  validator: (val) => val.length < 6 ? "Enter password 6+" : null,
					  decoration: textInputDeco.copyWith(hintText: "Password"),
				  ),
			 	 SizedBox(height: 20,),
				  Row(
				  	mainAxisAlignment: MainAxisAlignment.center,
				  	children: <Widget>[
						  RaisedButton(
							  color: Colors.pink[400],
							  child: Text("Register", style: TextStyle(color: Colors.white),),
							  onPressed: () async{
								  if(_formKey.currentState.validate()){
									  dynamic result = await _auth.registerEP(email, password, name);
									  if(result == null)
										  setState(() {
											  error = "valid email";
										  });
								  }
							  },
						  ),
						  SizedBox(width: 20),
						  Text(" or "),
						  SizedBox(width: 20),
						  RaisedButton(
							  color: Colors.pink[400],
							  child: Text("Log in", style: TextStyle(color: Colors.white),),
							  onPressed: () async{
								  if(_formKey.currentState.validate()){
									  dynamic result = await _auth.signInEP(email, password);
									  if(result == null)
										  setState(() {
											  error = "valid email";
										  });
								  }
							  },
						  ),
					]),
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
					  ]),
			  ),
		  ),
	  );
  }
}
