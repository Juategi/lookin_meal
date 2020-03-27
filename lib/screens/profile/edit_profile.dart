import 'package:flutter/material.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/strings.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final DBService _dbService = DBService();
  final StorageService _storageService = StorageService();
  String email, password, name = " ";
  String error = " ";

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context).settings.arguments;
    AppLocalizations tr = AppLocalizations.of(context);
    String image = user.picture;
    //
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                SizedBox(height: 20,),
                SizedBox(height: 20,),
                Container(
                      child: FlatButton(
                          onPressed: () async{
                            image = await _storageService.imagePicker(context);
                            if(image != null){
                              await _dbService.updateUserImage(image,user.uid); // deberia actualizarse cuando se apreta el boton save
                              if(user.picture != StaticStrings.defaultImage)
                                await _storageService.removeFile(user.picture); // deberia actualizarse cuando se apreta el boton save
                              user.picture = image;
                              setState((){
                              });
                            }
                          },
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                              constraints: BoxConstraints.expand(
                                height: 200.0,
                              ),
                              padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: Image.network(image).image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    right: 80,
                                    bottom: 0.0,
                                    child: Icon(Icons.collections, size: 60, color: Colors.grey[300],),
                                  ),
                                ],
                              )
                          )
                      )
                ),
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
