import 'package:flutter/material.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/decos.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final DBService _dbService = DBService();
  String email, password, name = " ";
  String error = " ";

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context).settings.arguments;
    AppLocalizations tr = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                SizedBox(height: 20,),
                TextFormField(
                    onChanged: (value){
                      setState(() => name = value);
                    },
                    validator: (val) => val.isEmpty ? tr.translate("entername") : null,
                    decoration: textInputDeco,
                    initialValue: user.name,
                ),
                SizedBox(height: 20,),
                TextFormField(
                    onChanged: (value){
                      setState(() => email = value);
                    },
                    validator: (val) => val.isEmpty ? tr.translate("enteremail") : null,
                    decoration: textInputDeco,
                   initialValue: user.email,
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
                  child: Text(tr.translate("save"), style: TextStyle(color: Colors.white),),
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                      print("bien");
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
