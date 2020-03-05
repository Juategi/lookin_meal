import 'package:flutter/material.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/shared/decos.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

	final AuthService _auth = AuthService();
	final _formKey = GlobalKey<FormState>();
	String email, password, error = " ";

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
			  child: Form(
				  key: _formKey,
				  child: Column(
					  children: <Widget>[
						  SizedBox(height: 20,),
						  TextFormField(
							  onChanged: (value){
								  setState(() => email = value);
							  },
							  validator: (val) => val.isEmpty ? tr.translate("enteremail") : null,
							  decoration: textInputDeco.copyWith(hintText: tr.translate("email"))
						  ),
						  SizedBox(height: 20,),
						  TextFormField(
							  obscureText: true,
							  onChanged: (value){
								  setState(() => password = value);
							  },
							  validator: (val) => val.length < 6 ? tr.translate("enterpassw") : null,
							  decoration: textInputDeco.copyWith(hintText: tr.translate("passw")),
						  ),
						  SizedBox(height: 20,),
						  RaisedButton(
							  color: Colors.pink[400],
							  child: Text(tr.translate("login"), style: TextStyle(color: Colors.white),),
							  onPressed: () async{
								  if(_formKey.currentState.validate()){
									  dynamic result = await _auth.signInEP(email, password);
									  if(result == null)
										  setState(() {
											  error = tr.translate("validmail");
										  });
									  else
										  Navigator.pop(context);
								  }
							  },
						  ),
						  SizedBox(height: 12),
						  Text(
							  error,
							  style: TextStyle(color: Colors.red, fontSize: 14),
						  )
					  ]
				  ),
			  ),
		  ),
	  );
  }
}
