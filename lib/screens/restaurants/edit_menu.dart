import 'package:flutter/material.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';

class EditMenu extends StatefulWidget {
  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  List<MenuEntry> menu;
  List<String> sections;
  Restaurant restaurant;
  bool init = false;

  void _initList(){
    menu = List<MenuEntry>();
    sections = List<String>();
    if(restaurant.sections == null){
      restaurant.sections = List<String>();
      restaurant.menu = List<MenuEntry>();
    }
    else{
      for (String section in restaurant.sections) {
        sections.add(section);
        for (MenuEntry entry in restaurant.menu) {
          if (entry.section == section) {
            menu.add(MenuEntry(
                id: entry.id,
                name: entry.name,
                rating: entry.rating,
                restaurant_id: entry.restaurant_id,
                price: entry.price,
                numReviews: entry.numReviews,
                section: entry.section,
                image: entry.image
            ));
          }
        }
      }
    }
  }

  List<Widget> _initMenu(){
    List<Widget> entries = new List<Widget>();
    for (String section in sections) {
      entries.add(Container(
        child: Row(children: <Widget>[
          Flexible(
              child: TextFormField(initialValue: section, onChanged: (v) {
                section = v;
              },)),
          IconButton(icon: Icon(Icons.delete), onPressed: (){
            bool flag = false;
            for(MenuEntry entry in menu){
              if(entry.section == section){
                //error hay entries debajo
                flag = true;
                break;
              }
            }
            if(!flag){
              sections.remove(section);
              setState(() {});
            }
          },),
        ],),
      ));
      entries.add(SizedBox(height: 30,));
      for (MenuEntry entry in menu) {
        if (entry.section == section) {
          entries.add(Container(
            child: Card(
              child: Row(children: <Widget>[
                Flexible(child: TextFormField(
                  initialValue: entry.name, onChanged: (v) {entry.name = v;},)),
                Flexible(child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: entry.price.toString(), onChanged: (v) {
                  entry.price = double.parse(v);
                },)),
                FlatButton(onPressed: () {},
                  child: Container(padding: EdgeInsets.only(
                      left: 36.0, bottom: 52.0, right: 36.0),
                    decoration: BoxDecoration(image: DecorationImage(
                      image: Image
                          .network(entry.image ??
                          "https://sevilla.abc.es/gurme/wp-content/uploads/sites/24/2012/01/comida-rapida-casera.jpg")
                          .image,),),),),
                IconButton(icon: Icon(Icons.delete), onPressed: (){
                  menu.remove(entry);
                  setState(() {});
                },),
              ],),
            ),
          ));
        }
      }
      entries.add(Row(children: <Widget>[
        IconButton(icon: Icon(Icons.add_circle_outline), onPressed: (){
          menu.add(MenuEntry(
            section: section,
            restaurant_id: restaurant.restaurant_id,
            name: "New",
            price: 0,
          ));
          setState(() {});
        },),
        Text("Añadir plato")
      ],));
      entries.add(SizedBox(height: 30,));
    }
    entries.add(Row(children: <Widget>[IconButton(icon: Icon(Icons.add_circle_outline, size: 30,), onPressed: (){
      sections.add("New");
      setState(() {});
      },), Text("Añadir seccion")],));
    entries.add(RaisedButton(child: Text("Save"),));
    this.setState((){});
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    if(!init){
      _initList();
      init = true;
    }
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: _initMenu()),
    );

  }
}
