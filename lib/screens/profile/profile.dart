import 'package:flutter/material.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/loading.dart';
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
    return StreamBuilder<User>(
        stream: DBService(uid: user.uid).userdata,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            user = snapshot.data;
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
                      await _auth.signOut();
                    },
                    icon: Icon(Icons.exit_to_app),
                    label: Text(tr.translate("signout"))
                ),
              ],
            );
          }
          else
            return Loading();
        }
    );
  }
}
