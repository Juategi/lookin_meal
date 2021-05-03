import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';

class EditOrder extends StatefulWidget {
  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  List<MenuEntry> menu,originalMenu;
  List<String> sections,originalSections;
  bool init = false;
  List<Widget> elements;
  AppLocalizations tr;
  void _copyLists(){
    menu = [];
    sections = [];
    if(originalSections == null){
      originalSections = [];
      originalMenu = [];
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
                pos: entry.pos,
                allergens: entry.allergens,
                description: entry.description,
                hide: entry.hide
            ));
          }
        }
      }
    }
  }

  List<Widget> _init(){
    List<Widget> entries = [];
    for(String section in sections){
      entries.add(Card(color: Color.fromRGBO(255, 110, 117, 0.3), key: ValueKey(section) ,child: ListTile(title: Text(section,), trailing: Icon(Icons.menu),),));
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
          Alerts.dialog(tr.translate("entrynosection"), context);
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
          Alerts.dialog(tr.translate("entrynosection"), context);
        }
        else{
          String section;
          List<String> sectionsAux = [];
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
    tr = AppLocalizations.of(context);
    List<Object> result = ModalRoute.of(context).settings.arguments;
    originalSections = result.first;
    originalMenu = result.last;
    if(!init){
      _copyLists();
      elements = _init();
      init = true;
    }
    return SafeArea(
      child: Scaffold(
        //backgroundColor: CommonData.backgroundColor,
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 80.h,
            child: Row( mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50.h,
                  width: 260.w,
                  child: RaisedButton(
                    elevation: 0,
                    color: Color.fromRGBO(255, 110, 117, 0.9),
                    child: Text(tr.translate("save"), style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18)),),
                    onPressed: () async{
                      Navigator.pop(context, [sections, menu]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 32.h,),
            Container(
              height: 42.h,
              width: 411.w,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 110, 117, 0.9),
              ),
              child: Row( mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align( alignment: AlignmentDirectional.topCenter, child: Text(tr.translate("editorder"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
                ],
              ),
            ),
            SizedBox(height: 32.h,),
            Expanded(child: ReorderableListView(children: elements, onReorder: _onReorder)),
          ],
        ),
      ),
    );
  }
}
