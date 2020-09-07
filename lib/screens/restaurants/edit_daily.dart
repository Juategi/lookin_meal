import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/strings.dart';

class EditDaily extends StatefulWidget {
  @override
  _EditDailyState createState() => _EditDailyState();
}

class _EditDailyState extends State<EditDaily> {
  Restaurant restaurant;
  List<String> dailyMenu;
  String description;
  double price;
  bool init = false;
  
  void _copyMenu(){
    if(restaurant.dailymenu == null){
      description = "";
      price = 0.0;
      dailyMenu = [];
    }
    else{
      description = restaurant.dailymenu[0];
      price = double.parse(restaurant.dailymenu[1]);
      for(int i = 2; i < restaurant.dailymenu.length; i++){
        dailyMenu.add(restaurant.dailymenu.elementAt(i));
      }
    }
  }

  List<Widget> _initList(){
    List<Widget> items = [];
    items.add(Text("Añade una descripción"));
    items.add(SizedBox(height: 30,));
    items.add(TextFormField(
      maxLength: 300,
      maxLines: 4,
      controller: TextEditingController()..text = description , onChanged: (v) {
      description = v;
    },));
    items.add(SizedBox(height: 30,));
    items.add(Text("Añade un precio"));
    items.add(SizedBox(height: 30,));
    items.add(TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 7,
      controller: TextEditingController()..text =price.toString() , onChanged: (v) {
      price = double.parse(v);
    },));
    items.add(SizedBox(height: 30,));
    items.add(Text("Crea el menú"));
    items.add(SizedBox(height: 30,));
    for(int i = 0; i < dailyMenu.length; i++){
      if(_isNumeric(dailyMenu[i])){
        for(MenuEntry entry in restaurant.menu){
          if(entry.id == dailyMenu[i]){
            items.add(Card(
              child: Row(
                children: <Widget>[
                  Image.network(entry.image ?? StaticStrings.defaultEntry, height: 50, width: 50,),
                  SizedBox(width: 10,),
                  Container(width: 270, child: Text(entry.name, style: TextStyle(fontSize: 16),)),
                  IconButton(icon: Icon(Icons.delete, color: Colors.black,), onPressed: (){
                    setState(() {
                      dailyMenu.removeAt(i);
                    });
                  },)
                ],
              )
            ));
            items.add(SizedBox(height: 10,));
          }
        }
      }
      else{
        items.add(Row(
          children: <Widget>[
            Flexible(
                child: TextFormField(keyboardType: TextInputType.text, controller: TextEditingController()..text = dailyMenu[i], onChanged: (v) {
                  dailyMenu[i] = v;
                },)),
            IconButton(icon: Icon(Icons.delete), onPressed: (){
                setState(() {
                  dailyMenu.removeAt(i);
                });
             }
            )
          ],
        ));
        items.add(SizedBox(height: 10,));
        items.add(Row(children: <Widget>[IconButton(icon: Icon(Icons.add_circle_outline, size: 30,), onPressed: (){
          showModalBottomSheet(context: context, builder: (BuildContext bc){
            return ListView(
              children: restaurant.menu.map((entry) {
                return Card(
                  child: ListTile(
                    title: Text(entry.name),
                    leading: Image.network(entry.image ?? StaticStrings.defaultEntry),
                    subtitle: Row(children: <Widget>[
                      Text(" ${entry.description}"),
                    ],),
                    onTap: (){
                      dailyMenu.insert(i+1, entry.id);
                      Navigator.pop(context);
                    },
                    trailing: Icon(Icons.add_circle_outline),
                  ),
                );
              }).toList(),
            );
          }).then((value){setState(() {});});
          },), Text("Añadir plato")],));
        items.add(SizedBox(height: 10,));
      }
    }

    items.add(Row(children: <Widget>[IconButton(icon: Icon(Icons.add_circle_outline, size: 30,), onPressed: (){
        dailyMenu.add("New");
        setState(() {});
      },), Text("Añadir seccion")],));

    return items;
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    if(!init) {
      _copyMenu();
      init = true;
    }
    return Scaffold(
      body: ListView(
        children: _initList()
      ),
    );
  }
}
