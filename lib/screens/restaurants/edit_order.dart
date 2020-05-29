import 'package:flutter/material.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/shared/alert.dart';

class EditOrder extends StatefulWidget {
  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  List<MenuEntry> menu,originalMenu;
  List<String> sections,originalSections;
  bool init = false;
  List<Widget> elements;

  void _copyLists(){
    menu = List<MenuEntry>();
    sections = List<String>();
    if(originalSections == null){
      originalSections = List<String>();
      originalMenu = List<MenuEntry>();
    }
    else{
      for (String section in originalSections) {
        sections.add(section);
        for (MenuEntry entry in originalMenu) {
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
      entries.add(Card(key: ValueKey(section) ,child: ListTile(title: Text(section,), leading: Text("Section"), trailing: Icon(Icons.menu),),));
      for(MenuEntry entry in menu){
        if (entry.section == section) {
          entries.add(Card(key: ValueKey(entry.id) ,child: ListTile(title: Text(entry.name), trailing: Icon(Icons.menu),),));
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
          Alerts.dialog('You can not have en entry without section', context);
          return;
        }
        else{
          Widget element = elements.removeAt(oldIndex);
          elements.insert(newIndex, element);
          for(int i = newIndex; i >= 0; i--){
            String section = _keyToString(elements.elementAt(i).key);
            if(sections.contains(section)){
              for(MenuEntry entry in menu){
                if(entry.id == key){
                  entry.section = section;
                  _sortMenuPos();
                }
              }
              break;
            }
          }
        }
      }
      else{ //Its a section
        if(newIndex == 1 && !sections.contains(elements.elementAt(0).key.toString())){
          Alerts.dialog('You can not have en entry without section', context);
        }
        else{
          String section;
          List<String> sectionsAux = List<String>();
          Widget element = elements.removeAt(oldIndex);
          elements.insert(newIndex, element);
          for(int i = 0; i < elements.length; i++){
            String key = _keyToString(elements.elementAt(i).key);
            if(sections.contains(key)){
              section = key;
              sectionsAux.add(section);
            }
            else{
              MenuEntry entry = _fromKeyToMenuIndex(key);
              entry.section = section;
            }
          }
          sections = sectionsAux;
        }
      }
      print("--------");
      for(MenuEntry entry in menu){
        print(entry.name);
        print(entry.section);
        print(entry.pos);
      }
      print(sections);
    });
  }

  String _keyToString(Key key){
    return key.toString().replaceAll("[<", "").replaceAll(">]", "").replaceAll("'", "");
  }

  void _sortMenuPos(){
    for(int i = 0; i < elements.length; i++){
      int key = int.tryParse(_keyToString(elements.elementAt(i).key));
      if(key != null){
        MenuEntry entry = _fromKeyToMenuIndex(key.toString());
        entry.pos = i;
      }
    }
  }

  MenuEntry _fromKeyToMenuIndex(String key){
    for(int i = 0; i < menu.length; i++){
      if(menu.elementAt(i).id == key){
        return menu.elementAt(i);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<Object> result = ModalRoute.of(context).settings.arguments;
    originalSections = result.first;
    originalMenu = result.last;
    if(!init){
      _copyLists();
      elements = _init();
      init = true;
    }
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(child: ReorderableListView(children: elements, onReorder: _onReorder)),
          RaisedButton(child: Text("Save"),onPressed: ()async{
            Navigator.pop(context, [sections, menu]);
          })
        ],
      ),
    );
  }
}
