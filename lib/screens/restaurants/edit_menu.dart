import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/strings.dart';

class EditMenu extends StatefulWidget {
  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  List<MenuEntry> menu;
  List<String> sections;
  Restaurant restaurant;
  bool init = false;
  final StorageService _storageService = StorageService();

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
    print(sections);
    List<Widget> entries = new List<Widget>();
    entries.add(Text("Nota: dejar precio a 0 o 0.0 para que el plato no tenga precio"));
    for (int i = 0; i < sections.length; i++) {
      String section = sections.elementAt(i);
      entries.add(Container(
        child: Row(children: <Widget>[
          Flexible(
              child: TextFormField(controller: TextEditingController()..text = section, onChanged: (v) {
                sections[i] = v;
                for(MenuEntry entry in menu){
                  if(entry.section == section) {
                    entry.section = v;
                  }
                }
                section = v;
              },)),
          IconButton(icon: Icon(Icons.delete), onPressed: (){
            bool flag = false;
            for(MenuEntry entry in menu){
              if(entry.section == section){
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Alert'),
                        content: Text('You can not delete a section with entries'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                );
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
          if(entry.price == null)
            entry.price = 0.0;
          entries.add(Container(
            child: Card(
              child: Row(children: <Widget>[
                Flexible(child: TextFormField(
                  controller: TextEditingController()..text = entry.name, onChanged: (v) {entry.name = v;},)),
                Flexible(child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController()..text = entry.price.toString() , onChanged: (v) {
                     entry.price = double.parse(v);
                },)),
                FlatButton(onPressed: () async{
                  String image = await _storageService.entryImagePicker(context);
                  if(image != null){
                    entry.image = image;
                    setState((){
                    });
                  }
                },
                  child: Container(padding: EdgeInsets.only(
                      left: 36.0, bottom: 52.0, right: 36.0),
                    decoration: BoxDecoration(image: DecorationImage(
                      image:  Image
                          .network(entry.image ??
                          StaticStrings.defaultEntry)
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
            rating: 0,
            numReviews: 0
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
    entries.add(RaisedButton(child: Text("Save"),onPressed: ()async{
      //Guardar menu y recogerlo de nuevo de la BD para actualizar info
      for(MenuEntry entry in menu){
        if(entry.price == 0.0)
          entry.price = null;
        else
          entry.price = entry.price.toDouble();
        print("${entry.section} / ${entry.name} / ${entry.price}");
      }
      await DBService().uploadMenu(sections, menu, restaurant);
      Navigator.pop(context);
    },));
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
