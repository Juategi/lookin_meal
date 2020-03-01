import 'package:flutter/material.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/shared/decos.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

	final AuthService _auth = AuthService();
	final _formKey = GlobalKey<FormState>();
	String email, password, error = " ";

  @override
  Widget build(BuildContext context) {
	  return Scaffold(
		  backgroundColor: Colors.brown[100],
		  appBar: AppBar(
			  backgroundColor: Colors.brown[400],
			  elevation: 0.0,
			  title: Text("Register to Brew Crew"),
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
						  RaisedButton(
							  color: Colors.pink[400],
							  child: Text("Register", style: TextStyle(color: Colors.white),),
							  onPressed: () async{
								  if(_formKey.currentState.validate()){
									  dynamic result = await _auth.registerEP(email, password);
									  if(result == null)
										  setState(() {
											  error = "valid email";
										  });
								  }
							  },
						  ),
						  SizedBox(height: 12),
						  Text(
							  error,
							  style: TextStyle(color: Colors.red, fontSize: 14),
						  )
					  ],
				  ),
			  )
		  ),
	  );
  }
}
