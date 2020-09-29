import 'package:flutter/material.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/json_update.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  User user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    AppLocalizations tr = AppLocalizations.of(context);
    return Column(
      children: <Widget>[
        Container(
          child: Image.network(user.picture, height: 150, width: 150,),
        ),
        SizedBox(height: 20,),
        user.service == "EP" ? FlatButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, "/editprofile",arguments: user);
            },
            icon: Icon(Icons.edit),
            label: Text(tr.translate("editinfo"))
        ): SizedBox(height: 0,),
        SizedBox(height: 20,),
        FlatButton.icon(
            onPressed: () async {
              GeolocationService.prueba();
            },
            icon: Icon(Icons.pan_tool),
            label: Text("prueba")
        ),
        SizedBox(height: 20,),
        FlatButton.icon(
            onPressed: () async {
              Navigator.pushNamed(context, "/favs");
            },
            icon: Icon(Icons.favorite),
            label: Text("favoritos")
        ),
        SizedBox(height: 20,),
        FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.exit_to_app),
            label: Text(tr.translate("signout"))
        ),
      ],
    );
  }


}
