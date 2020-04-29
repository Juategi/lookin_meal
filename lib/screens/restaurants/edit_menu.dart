import 'package:flutter/material.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/loading.dart';

class EditMenu extends StatefulWidget {
  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  List<MenuEntry> menu;
  List<String> sections;
  Restaurant restaurant;

  List<Widget> _initList(){
    List<Widget> entries = new List<Widget>();
    for(String section in restaurant.sections){
      entries.add(Row(children: <Widget>[
        Flexible(child: TextFormField(initialValue: section, onChanged: (v){section = v;}, )),
        IconButton(icon: Icon(Icons.delete)),
      ],));
      for(MenuEntry entry in restaurant.menu){
        if(entry.section == section)
        entries.add(Row(children: <Widget>[
          Flexible(child: TextFormField(initialValue: entry.name, onChanged: (v){}, )),
          Flexible(child: TextFormField(initialValue: entry.price.toString(), onChanged: (v){section = v;}, )),
          FlatButton(onPressed: (){}, child: Container(constraints: BoxConstraints.expand(height: 10.0,), padding: EdgeInsets.only(left: 6.0, bottom: 2.0, right: 6.0),decoration: BoxDecoration(image: DecorationImage(image: Image.network(entry.image?? "https://sevilla.abc.es/gurme/wp-content/uploads/sites/24/2012/01/comida-rapida-casera.jpg").image, fit: BoxFit.cover,),),),),
          IconButton(icon: Icon(Icons.delete)),
        ],));
      }
    }
    this.setState((){});
    return entries;
  }


  @override
  Widget build(BuildContext context) {
    menu = List<MenuEntry>();
    sections = List<String>();
    restaurant = ModalRoute.of(context).settings.arguments;
    List<Widget> list = _initList();
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: list),
    );

  }
}
