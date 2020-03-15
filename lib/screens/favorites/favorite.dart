import 'package:flutter/material.dart';
import 'package:lookinmeal/services/json_update.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Container(
		child: RaisedButton(
			onPressed: ()async{JsonUpdate().updateFromJson("valencia_tripad.json",161);},
		),
	);
  }
}
