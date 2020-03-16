import 'package:flutter/material.dart';
import 'package:lookinmeal/services/json_update.dart';

class Stars extends StatefulWidget {
  @override
  _StarsState createState() => _StarsState();
}

class _StarsState extends State<Stars> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: ()async{JsonUpdate().updateFromJson("valencia_tripad.json",161);},
      ),
    );
  }
}
