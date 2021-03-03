import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/entry.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/screens/restaurants/restaurant_tile.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
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
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: "/favslists", arguments: 'R'),
                  screen: FavoriteLists(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
                //Navigator.pushNamed(context, "/favslists", arguments: 'R');
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
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: "/favslists", arguments: 'E'),
                  screen: FavoriteLists(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
                //Navigator.pushNamed(context, "/favslists", arguments: 'E');
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
    items.addAll(DBServiceUser.userF.lists.map((list) => list.type != type? Container() : Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: GestureDetector(
        onTap: (){
          pushNewScreenWithRouteSettings(
            context,
            settings: RouteSettings(name: "/displaylist", arguments: type + list.id),
            screen: ListDisplay(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
          //Navigator.pushNamed(context, "/displaylist", arguments: type + list.id);
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
                  SizedBox(height: 15.h,),
                  GestureDetector(
                      onTap: () async{
                        bool delete = await Alerts.confirmation("Are you sure you want to delete this list?", context);
                        if(delete){
                          await DBServiceUser.dbServiceUser.deleteList(list.id);
                          DBServiceUser.userF.lists.remove(list);
                          setState(() {
                          });
                        }
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
    if(DBServiceUser.userF.lists.where((list) => list.type == type).length < 15)
      items.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: GestureDetector(
          onTap: ()async{
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: "/createlist", arguments: type),
              screen: CreateList(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            ).then((value) => setState(() {}));
           //await Navigator.pushNamed(context, "/createlist", arguments: type);setState(() {});
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
    return SafeArea(
      child: Scaffold(
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
    return SafeArea(
      child: Scaffold(
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
                maxLength: 40,
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
                  FavoriteList list = await DBServiceUser.dbServiceUser.createList(DBServiceUser.userF.uid, name, StaticStrings.defaultEntry, type);
                  DBServiceUser.userF.lists.add(list);
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
  Map<String, Restaurant> entries;
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
    List<String> aux = [];
    if(type == 'R'){
      restaurants = [];
      for(String id in list.items){
        Restaurant restaurant = Pool.getRestaurant(id);
        if(restaurant != null) {
          restaurants.add(restaurant);
        }
        else{
          aux.add(id);
        }
      }
      restaurants.addAll(await DBServiceRestaurant.dbServiceRestaurant.getRestaurantsById(aux, GeolocationService.myPos.latitude, GeolocationService.myPos.longitude));
      setState(() {
      });
    }
    else{
      entries = await DBServiceEntry.dbServiceEntry.getEntriesById(list.items);
      print(entries);
    }
  }


  @override
  Widget build(BuildContext context) {
    String aux = ModalRoute.of(context).settings.arguments;
    type = aux.substring(0,1);
    id = aux.substring(1);
    list = DBServiceUser.userF.lists.singleWhere((element) => element.id == id);
    if(init){
      _timer();
      _updateLists();
      init = false;
    }
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
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
            (type == 'R' && restaurants == null) || (type == 'E' && entries == null) ? Center(child: Loading()) : Expanded(
              child: type == 'R' ? Container(
                width: 300.w,
                child: ListView(
                    shrinkWrap: true,
                    children: restaurants.map((restaurant) =>
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                          child: GestureDetector(
                            onTap: (){
                              DBServiceRestaurant.dbServiceRestaurant.updateRecently(restaurant);
                              pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: "/restaurant", arguments: restaurant),
                                screen: ProfileRestaurant(),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              ).then((value) => setState(() {}));
                              //Navigator.pushNamed(context, "/restaurant",arguments: restaurant).then((value) => setState(() {}));
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
                                            bool delete = await Alerts.confirmation("Are you sure you want to delete this restaurant?", context);
                                            if(delete){
                                              list.items.remove(restaurant.restaurant_id);
                                              restaurants.remove(restaurant);
                                              Alerts.toast("${restaurant.name} removed from ${list.name}");
                                              await DBServiceUser.dbServiceUser.updateList(list);
                                              setState(() {
                                              });
                                            }
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
                                      restaurant.types.length == 0 ? Container() : Container(
                                          height: 15.h,
                                          width: 15.w,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: Image.asset("assets/food/${CommonData.typesImage[restaurant.types[0]]}.png").image))
                                      ),
                                      SizedBox(width: 5.w,),
                                      Container(width: 155.w, child: Text(restaurant.types.length > 1 ? "${restaurant.types[0]}, ${restaurant.types[1]}" : "${restaurant.types[0]}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),))),
                                      SizedBox(width: 35.w,),
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
                        )
                ).toList()
                ),
              ) : Container(
                width: 200.w,
                child: ListView(
                  children: entries.keys.map((entryId) {
                    MenuEntry entry = entries[entryId].menu.singleWhere((element) => element.id == entryId);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      child: GestureDetector(
                          onTap: () async{
                            await showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
                              return Provider<Restaurant>.value(value: entries[entryId], child: Provider<MenuEntry>.value(value: entry, child: EntryRating()));
                            }).then((value){setState(() {});});
                          },
                          child: Container(
                            height: 170.h,
                            width: 200.w,
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
                                  width: 200.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(image: Image.network(entry.image == null || entry.image == "" ? StaticStrings.defaultEntry : entry.image, fit: BoxFit.cover).image)
                                  ),
                                  child: entry.price == 0.0 ? Container() : Column( mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 5.w),
                                        child: Column( mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row( mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                IconButton(
                                                  icon:  Icon(Icons.delete, color: Colors.black,),
                                                  iconSize: ScreenUtil().setSp(32),
                                                  onPressed: ()async{
                                                    bool delete = await Alerts.confirmation("Are you sure you want to delete this dish?", context);
                                                    if(delete){
                                                      list.items.remove(entry.id);
                                                      entries.remove(entryId);
                                                      Alerts.toast("${entry.name} removed from ${list.name}");
                                                      await DBServiceUser.dbServiceUser.updateList(list);
                                                      setState(() {
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            //SizedBox(height: 50.h,)
                                            Row( mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: 58.w,
                                                  height: 20.h,
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(255, 110, 117, 0.9),
                                                      borderRadius: BorderRadius.all(Radius.circular(12))
                                                  ),
                                                  child: Align( alignment: Alignment.center, child: Text("${entry.price} ${entries[entryId].currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                                  child: Container(width: 190.w, height: 28.h, child: Text("${entry.name}", maxLines: 2, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3,  fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(11),),))),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                                  child: Row( crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          //SmoothStarRating(rating: entry.rating, spacing: -3, isReadOnly: true, allowHalfRating: true, color: Color.fromRGBO(250, 201, 53, 1), borderColor: Color.fromRGBO(250, 201, 53, 1), size: ScreenUtil().setSp(10),),
                                          StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: entry.rating, size: ScreenUtil().setSp(7),),
                                          Text("${entry.numReviews} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(9),),)),
                                        ],
                                      ),
                                      SizedBox(width: 5.w,),
                                      Container(width: 120.w, height: 28.h, child: Text(entries[entryId].name, maxLines: 2, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(11),),))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ),
                    );
                  }).toList(),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}




