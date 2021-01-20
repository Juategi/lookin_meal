import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/restaurant_tile.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 42.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.9),
            ),
            child:Text("Favorites", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
          ),
          SizedBox(height: 170.h,),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, "/favslists", arguments: 'R');
            },
            child: Container(
                height: 113,
                width: 336,
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(1, 1), // changes position of shadow
                    ),],
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new AssetImage("assets/rest_button.png")
                    )
                ),
              child:Center(child: Text("Restaurants", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(38),),))),
            ),
          ),
          SizedBox(height: 100.h,),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, "/favslists", arguments: 'E');
            },
            child: Container(
                height: 113,
                width: 336,
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(1, 1), // changes position of shadow
                    ),],
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new AssetImage("assets/platos_button.png")
                    )
                ),
              child:Center(child: Text("Dishes", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(38),),))),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteLists extends StatefulWidget {
  @override
  _FavoriteListsState createState() => _FavoriteListsState();
}

class _FavoriteListsState extends State<FavoriteLists> {
  String type;

  List<Widget> _loadLists(){
    List<Widget> items = [];
    items.addAll(DBService.userF.lists.map((list) => list.type != type? Container() : Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, "/displaylist", arguments: type + list.id);
        },
        child: Container(
          height: 113.h,
          width: 336.w,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(1, 1), // changes position of shadow
            ),],
          ),
          child: Row(
            children: [
              SizedBox(width: 1.w,),
              Container(
                height: 100.h,
                width: 100.w,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.network(list.image).image
                    )
                ),
              ),
              SizedBox(width: 10.w,),
              Container(height: 100.h, width: 200.w, child: Text(list.name, maxLines: 2, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
              Column(
                children: [
                  SizedBox(height: 2.h,),
                  Icon(Icons.share_outlined, size: ScreenUtil().setSp(45), color: Color.fromRGBO(255, 110, 117, 0.6),),
                  SizedBox(height: 19.h,),
                  DBService.userF.lists.first.id == list.id? Container() : GestureDetector(
                      onTap: () async{
                        await DBService.dbService.deleteList(list.id);
                        DBService.userF.lists.remove(list);
                        setState(() {
                        });
                      },
                      child: Icon(Icons.delete_outline, size: ScreenUtil().setSp(45), color: Colors.black87)
                  )
                ],
              )
            ],
          ),
        ),
      ),
    )));
    items.add(Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: GestureDetector(
        onTap: ()async{
         await Navigator.pushNamed(context, "/createlist", arguments: type);
         setState(() {
         });
        },
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            //borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(1, 1), // changes position of shadow
            ),],
          ),
          child: Icon(Icons.add, size: ScreenUtil().setSp(65),),
        ),
      ),
    ),);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    type = ModalRoute.of(context).settings.arguments;
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 42.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.9),
            ),
            child:Text("Favorite ${type == 'R'? 'restaurants' : 'dishes'}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ListView(
                children: _loadLists()
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CreateList extends StatefulWidget {
  @override
  _CreateListState createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  Icon _icon = Icon(Icons.image_outlined, size: ScreenUtil().setSp(120),);
  String iconImage;
  String type, name;
  @override
  Widget build(BuildContext context) {
    type = ModalRoute.of(context).settings.arguments;
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 42.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.9),
            ),
            child:Text("Favorite ${type == 'R'? 'restaurants' : 'dishes'}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
          ),
          SizedBox(height: 30.h,),
          Text("Add image", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(30),),)),
          SizedBox(height: 20.h,),
          GestureDetector(
            onTap: ()async{
                /*IconData icon = await FlutterIconPicker.showIconPicker(
                  context,
                  adaptiveDialog: true,
                  showTooltips: true,
                  showSearchBar: true,
                  iconPickerShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  iconPackMode: IconPack.fontAwesomeIcons,
                );
                //icon = 
                if (icon != null) {
                  _icon = Icon(icon, size: ScreenUtil().setSp(120),);
                  setState(() {});
                }
                iconImage = icon.codePoint.toString() + icon.fontFamily;
                 */
              },
              child: _icon
          ),
          SizedBox(height: 50.h,),
          Text("Name of the list", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(30),),)),
          SizedBox(height: 20.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextField(
              maxLines: 1,
              maxLength: 60,
              decoration: textInputDeco,
              onChanged: (v){
                name = v;
              },
            ),
          ),
          SizedBox(height: 20.h,),
          GestureDetector(
            onTap: ()async{
              if(name == null || name == ""){
                Alerts.toast("Write a name");
              }
              else{
                FavoriteList list = await DBService.dbService.createList(DBService.userF.uid, name, StaticStrings.defaultEntry, type);
                DBService.userF.lists.add(list);
                Navigator.pop(context);
              }
            },
            child: Container(
              height: 65.h,
              width: 150.w,
              decoration: new BoxDecoration(
                  color: Color.fromRGBO(255, 110, 117, 0.9),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Center(child: Text("Save", maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white,
                    letterSpacing: .3,
                    fontWeight: FontWeight.normal,
                    fontSize: ScreenUtil().setSp(22),),))),
            ),
          ),
        ],
      ),
    );
  }
}


class ListDisplay extends StatefulWidget {
  @override
  _ListDisplayState createState() => _ListDisplayState();
}

class _ListDisplayState extends State<ListDisplay> {
  String type, id;
  List<Restaurant> restaurants;
  List<MenuEntry> entries;
  FavoriteList list;
  bool init = true;

  void _timer() {
    if(type == 'R'){
      if(restaurants == null) {
        Future.delayed(Duration(seconds: 2)).then((_) {
          setState(() {
            print("Loading..");
          });
          _timer();
        });
      }
    }
    else{
      if(restaurants == null || entries == null) {
        Future.delayed(Duration(seconds: 2)).then((_) {
          setState(() {
            print("Loading..");
          });
          _timer();
        });
      }
    }
  }

  void _updateLists() async{
    if(type == 'R'){
      restaurants = await DBService.dbService.getRestaurantsById(list.items, GeolocationService.myPos.latitude, GeolocationService.myPos.longitude);
    }
  }


  Future updateRecent(Restaurant restaurant) async{
    for(Restaurant r in DBService.userF.recently){
      if(r.restaurant_id == restaurant.restaurant_id){
        return;
      }
    }
    if(DBService.userF.recently.length == 5){
      DBService.userF.recently.removeAt(0);
    }
    DBService.userF.recently.add(restaurant);
    DBService.userF.recent = DBService.userF.recently;
    DBService.dbService.updateRecently();
  }


  @override
  Widget build(BuildContext context) {
    String aux = ModalRoute.of(context).settings.arguments;
    type = aux.substring(0,1);
    id = aux.substring(1);
    list = DBService.userF.lists.singleWhere((element) => element.id == id);
    if(init){
      _timer();
      _updateLists();
      init = false;
    }
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 42.h,
            width: 411.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 110, 117, 0.9),
            ),
            child:Text("${list.name}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
          ),
          restaurants == null? Center(child: Loading()) : Expanded(
            child: Container(
              width: 300.w,
              child: ListView(
                  shrinkWrap: true,
                  children: restaurants.map((restaurant) =>
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: GestureDetector(
                            onTap: (){
                              updateRecent(restaurant);
                              Navigator.pushNamed(context, "/restaurant",arguments: restaurant).then((value) => setState(() {}));
                            },
                            child: Container(
                              width: 300.w,
                              height: 160.h,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                boxShadow: [BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(1, 1), // changes position of shadow
                                ),],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 103.h,
                                    width: 300.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: Image.network(
                                            restaurant.images.first).image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Row( mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        IconButton(
                                          icon:  Icon(Icons.delete, color: Colors.black,),
                                          iconSize: ScreenUtil().setSp(32),
                                          onPressed: ()async{
                                            list.items.remove(restaurant.restaurant_id);
                                            restaurants.remove(restaurant);
                                            Alerts.toast("${restaurant.name} removed from ${list.name}");
                                            await DBService.dbService.updateList(list);
                                            setState(() {
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1.h,),
                                  Row( crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5.w,),
                                      Container(width: 165.w, child: Text(restaurant.name,  maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(13),),))),
                                      //SizedBox(width: 1.w,),
                                      Column(
                                        children: <Widget>[
                                          SizedBox(height: 4.h,),
                                          StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: Functions.getRating(restaurant), size: ScreenUtil().setSp(10),),
                                        ],
                                      ),
                                      SizedBox(width: 3.w,),
                                      Column(
                                        children: <Widget>[
                                          SizedBox(height: 2.h,),
                                          Text("${Functions.getVotes(restaurant)} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(11),),)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 5.w,),
                                      Container(width: 165.w, child: Text(restaurant.types.length > 1 ? "${restaurant.types[0]}, ${restaurant.types[1]}" : "${restaurant.types[0]}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),))),
                                      SizedBox(width: 40.w,),
                                      Container(
                                        child: SvgPicture.asset("assets/markerMini.svg"),
                                      ),
                                      //Icon(Icons.location_on, color: Colors.black, size: ScreenUtil().setSp(16),),
                                      Text("${restaurant.distance.toString()} km", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(11),),))
                                    ],
                                  ),
                                  SizedBox(height: 2.h,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
              ).toList()
              ),
            ),
          )
        ],
      ),
    );
  }
}



