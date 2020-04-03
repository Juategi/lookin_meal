import 'package:flutter/material.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/json_update.dart';
import 'package:lookinmeal/services/newdatabase.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:provider/provider.dart';

class Stars extends StatefulWidget {
  @override
  _StarsState createState() => _StarsState();
}

class _StarsState extends State<Stars> {
  User user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return StreamBuilder<User>(
      stream: DBService(uid: user.uid).userdata,
      builder: (context, snapshot) {
        user = snapshot.data;
        return Container(
          child: RaisedButton(
            child: Text("Prueba"),
            //onPressed: ()async{JsonUpdate().updateFromJson("valencia_tripad.json",331);},
            //onPressed: ()async{DBServiceN dbServiceN = DBServiceN(); dbServiceN.getAllRestaurants();},
            //onPressed: () async {DBServiceN dbServiceN = DBServiceN();dbServiceN.createUser(user.uid, user.email, user.name, user.picture, user.service);},
            onPressed: ()async{DBServiceN dbServiceN = DBServiceN(); dbServiceN.getUserData(user.uid);},
          ),
        );
      }
    );
  }
}
