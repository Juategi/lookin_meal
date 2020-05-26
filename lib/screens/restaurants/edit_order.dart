import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/strings.dart';

class EditOrder extends StatefulWidget {
  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  List<MenuEntry> menu;
  List<String> sections;
  bool init = false;
  Restaurant restaurant;
  List<Widget> elements;

  void _copyLists(){
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
                image: entry.image,
                pos: entry.pos
            ));
          }
        }
      }
    }
  }

  List<Widget> _init(){
    List<Widget> entries = new List<Widget>();
    for(String section in sections){
      entries.add(Card(key: ValueKey(section) ,child: ListTile(title: Text(section,), leading: Text("Section"),),));
      for(MenuEntry entry in menu){
        if (entry.section == section) {
          entries.add(Card(key: ValueKey(entry.pos) ,child: ListTile(title: Text(entry.name),),));
        }
      }
    }
    return entries;
  }

  void _onReorder(int oldIndex, int newIndex){
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      String key = _keyToString(elements.elementAt(oldIndex).key);
      if(!sections.contains(key)){ //Its an entry
        if(newIndex == 0){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Alert'),
                  content: Text('You can not have an entry without section'),
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
          return;
        }
        else{
          Widget element = elements.removeAt(oldIndex);
          elements.insert(newIndex, element);
          for(int i = newIndex; i >= 0; i--){
            String section = _keyToString(elements.elementAt(i).key);
            if(sections.contains(section)){
              for(MenuEntry entry in menu){
                if(entry.pos == int.parse(key)){
                  entry.section = section;
                  _sortMenuPos(); // FALLA
                }
              }
            }
          }
        }
      }
      else{ //Its a section

      }
      for(MenuEntry entry in menu){
        print(entry.name);
        print(entry.section);
        print(entry.pos);
      }
    });
  }

  String _keyToString(Key key){
    return key.toString().replaceAll("[<", "").replaceAll(">]", "").replaceAll("'", "");
  }

  void _sortMenuPos(){
    for(int i = 0; i < elements.length; i++){
      int key = int.tryParse(_keyToString(elements.elementAt(i).key));
      if(key != null){
        MenuEntry entry = _fromKeyToMenuIndex(key);
        entry.pos = i;
      }
    }
  }

  MenuEntry _fromKeyToMenuIndex(int key){
    for(int i = 0; i < menu.length; i++){
      if(menu.elementAt(i).pos == key){ //la pos cambia entonces no se puede comparar a la key que es constante
        return menu.elementAt(i);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    if(!init){
      _copyLists();
      elements = _init();
      init = true;
    }
    return Scaffold(
      appBar: AppBar(),
      body: ReorderableListView(children: elements, onReorder: _onReorder),
    );
  }
}
