import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';
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
    return Container(
      child: RaisedButton(
        child: Text("Prueba"),
        onPressed: ()async{
          for(int i = 1; i < 10; i++)
            await JsonUpdate().updateFromJson("valencia_tripad.json",i);
          },
        //onPressed: ()async{DBService dbService = DBService(); dbService.getUserFavorites(user.uid);},
        //onPressed: () async {DBService dbService = DBService();dbService.updateUserData(user.uid, user.email, "juancho", user.picture, user.service);},
        /*onPressed: ()async{
          DBService dbService = DBService();
          List<Restaurant> restaurants = await dbService.getAllRestaurants();
          for(Restaurant res in restaurants){
            await dbService.updateUserFavorites(user.uid, res);
          }
        },*/
      ),
    );
  }
}
