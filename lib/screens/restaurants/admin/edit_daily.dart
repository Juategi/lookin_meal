import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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
    dailyMenu = [];
    if(restaurant.dailymenu == null){
      description = "";
      price = 0.0;
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
    items.add(Text("Añade una descripción", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)));
    items.add(SizedBox(height: 30.h,));
    items.add(Container(
      color: Color.fromRGBO(255, 110, 117, 0.1),
      child: TextFormField(
        maxLength: 300,
        maxLines: 4,
        controller: TextEditingController()..text = description..selection = TextSelection.fromPosition(TextPosition(offset: description.length)),  onChanged: (v) {
        description = v;
      },),
    ));
    items.add(SizedBox(height: 30.h,));
    items.add(Text("Añade un precio", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)));
    items.add(SizedBox(height: 30.h,));
    items.add(Container(
      color: Color.fromRGBO(255, 110, 117, 0.1),
      child: TextFormField(
        keyboardType: TextInputType.number,
        maxLength: 7,
        controller: TextEditingController()..text = price.toString()..selection = TextSelection.fromPosition(TextPosition(offset: price.toString().length)) , onChanged: (v) {
        price = double.parse(v);
      },),
    ));
    items.add(SizedBox(height: 30.h,));
    items.add(Text("Crea el menú", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)));
    items.add(SizedBox(height: 30.h,));
    for(int i = 0; i < dailyMenu.length; i++){
      if(_isNumeric(dailyMenu[i])){
        for(MenuEntry entry in restaurant.menu){
          if(entry.id == dailyMenu[i]){
            items.add(Card(
              child: Row(
                children: <Widget>[
                  Image.network(entry.image ?? StaticStrings.defaultEntry, height: 50.h, width: 50.w,),
                  SizedBox(width: 10.w,),
                  Container(width: 256.w, child: Text(entry.name, style: TextStyle(fontSize: ScreenUtil().setSp(16)),)),
                  IconButton(icon: Icon(Icons.delete, color: Colors.black,), onPressed: (){
                    setState(() {
                      dailyMenu.removeAt(i);
                    });
                  },)
                ],
              )
            ));
            items.add(SizedBox(height: 10.h,));
          }
        }
      }
      else{
        items.add(Container(
          color: Color.fromRGBO(255, 110, 117, 0.2),
          child: Row(
            children: <Widget>[
              Flexible(
                  child: TextFormField(keyboardType: TextInputType.text, controller: TextEditingController()..text = dailyMenu[i]..selection = TextSelection.fromPosition(TextPosition(offset: dailyMenu[i].length)), onChanged: (v) {
                    dailyMenu[i] = v;
                  },)),
              IconButton(icon: Icon(Icons.delete), onPressed: (){
                  setState(() {
                    dailyMenu.removeAt(i);
                  });
               }
              )
            ],
          ),
        ));
        items.add(SizedBox(height: 10,));
        items.add(Row(children: <Widget>[IconButton(icon: Icon(Icons.add_circle_outline, size: 30,), onPressed: (){
          pushNewScreenWithRouteSettings(
            context,
            settings: RouteSettings(arguments: [restaurant, dailyMenu, i]),
            screen: SearchDishDaily(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
          },), Text("Añadir plato", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))
        ],));
        items.add(SizedBox(height: 10,));
      }
    }

    items.add(Row(children: <Widget>[IconButton(icon: Icon(Icons.add_circle_outline, size: 30,), onPressed: (){
        dailyMenu.add("New");
        setState(() {});
      },),Text("Añadir seccion", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),))
    ],));

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
    print(restaurant.dailymenu);
    return SafeArea(
      child: Scaffold(
        //backgroundColor: CommonData.backgroundColor,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Column(
            children: <Widget>[
              SizedBox(height: 32.h),
              Container(
                height: 42.h,
                width: 411.w,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 110, 117, 0.9),
                ),
                child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align( alignment: AlignmentDirectional.topCenter, child: Text("Editar menú del dia", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                  child: ListView(
                    children: _initList()
                  ),
                ),
              ),
            ],
          ),
        ),
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
                    child: Text("Guardar", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18)),),
                    onPressed: ()async{
                      restaurant.dailymenu = [];
                      restaurant.dailymenu.add(description);
                      restaurant.dailymenu.add(price.toString());
                      restaurant.dailymenu.addAll(dailyMenu);
                      await DBServiceEntry.dbServiceEntry.updateDailyMenu(restaurant.restaurant_id, restaurant.dailymenu);
                      Alerts.toast("Menu saved");
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchDishDaily extends StatefulWidget {
  @override
  _SearchDishDailyState createState() => _SearchDishDailyState();
}

class _SearchDishDailyState extends State<SearchDishDaily> {
  Restaurant restaurant;
  int i;
  List<String> dailyMenu;
  List<MenuEntry> search;
  bool init = true;
  @override
  Widget build(BuildContext context) {
    List<Object> aux = ModalRoute.of(context).settings.arguments;
    restaurant = aux.first;
    dailyMenu = aux[1];
    i = aux.last;
    if(init){
      search  = restaurant.menu;
      init = false;
    }
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: ListView(
          children: [
            Container(
              height: 70.h,
              child: TextField(
                  onChanged: (value){
                    setState(() {
                      search = restaurant.menu.where((entry) => entry.name.toLowerCase().contains(value.toLowerCase())).toList();
                    });
                  },
                  decoration: InputDecoration(
                      filled: true,
                      hintText: "Search..",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(20)
                      )
                  )
              ),
            ),
            Container(
              height: 620.h,
              child: ListView(
                children: search.map((entry) {
                  return Card(
                    child: ListTile(
                      title: Text(entry.name),
                      leading: Image.network(entry.image ?? StaticStrings.defaultEntry),
                      subtitle: Text("${entry.description}", maxLines: 1, ),
                      onTap: (){
                        dailyMenu.insert(i+1, entry.id);
                        Navigator.pop(context);
                      },
                      trailing: Icon(Icons.add_circle_outline),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],),
      ),
      ),
    );
  }
}
