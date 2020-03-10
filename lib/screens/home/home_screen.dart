import 'package:flutter/material.dart';
import 'package:lookinmeal/services/json_update.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	

  @override
  Widget build(BuildContext context) {
    return Container(
		child: Column(
			children: <Widget>[
				RaisedButton(
					onPressed: ()async{
						JsonUpdate js = JsonUpdate();
						await js.updateFromJson("valencia_tripad.json");
						setState(() {

						});
					},
				)
			],
		),
	);
  }
}
