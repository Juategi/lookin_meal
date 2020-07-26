import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:provider/provider.dart';

class Stars extends StatefulWidget {
  Position myPos;
  String locality;
  Stars({this.myPos,this.locality});
  @override
  _StarsState createState() => _StarsState(myPos: myPos, locality: locality);
}

class _StarsState extends State<Stars> {
  User user;
  List<bool> _selections = List.generate(2, (index) => false);
  Map<MenuEntry, Restaurant> map;
  bool isRestaurant = true;
  Position myPos;
  String locality;
  String error = "";
  _StarsState({this.myPos,this.locality});

  Future<List<Restaurant>> _search(String query) async{
    List<Restaurant> list = await SearchService().query(myPos.latitude, myPos.longitude, locality, query);
    if(list.length == 0)
      error = "No results";
    else
      error = "";
    return list;
  }

  Future<List<MenuEntry>> _searchEntry(String query) async{
    map = await SearchService().queryEntry(myPos.latitude, myPos.longitude, locality, query);
    if(map.length == 0)
      error = "No results";
    else
      error = "";
    return map.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Scaffold(
      //appBar: AppBar(backgroundColor: ThemeData().scaffoldBackgroundColor,),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 40,
            child: Container(
              height: 600,
              width: 390,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: isRestaurant? SearchBar(
                  emptyWidget: Text(error),
                  cancellationWidget: Text(" Cancel "),
                  debounceDuration: Duration(milliseconds: 800),
                  loader: Center(child: SpinKitChasingDots(color: Colors.brown, size: 50.0,),),
                  minimumChars: 1,
                  onSearch: _search ,
                  onItemFound: (Restaurant restaurant, int index){
                    return Card(
                      child: ListTile(
                          title: Text(restaurant.name),
                          subtitle: Text(" 📍 ${restaurant.distance} Km"),
                          leading: Image.network(restaurant.images.first, width: 100, height: 100,),
                          trailing: Icon(Icons.arrow_right),
                          onTap: () {
                            List<Object> args = List<Object>();
                            Pool.addRestaurants([restaurant]);
                            restaurant = Pool.getSubList([restaurant]).first;
                            args.add(restaurant);
                            args.add(user);
                            Navigator.pushNamed(context, "/restaurant",arguments: args);
                          }
                      ),
                    );
                  }
                ):
                SearchBar(
                    emptyWidget: Text(error),
                    cancellationWidget: Text(" Cancel "),
                    debounceDuration: Duration(milliseconds: 800),
                    loader: Center(child: SpinKitChasingDots(color: Colors.brown, size: 50.0,),),
                    minimumChars: 1,
                    onSearch: _searchEntry ,
                    onItemFound: (MenuEntry entry, int index){
                      return Card(
                        child: ListTile(
                            title: Text("${entry.name} ${entry.rating}"),
                            subtitle: Text(" 📍 ${map[entry].distance} Km     ${entry.price}€"),
                            leading: Image.network(entry.image, width: 100, height: 100,),
                            trailing: Icon(Icons.arrow_right),
                            onTap: () {
                              List<Object> args = List<Object>();
                              Pool.addRestaurants([map[entry]]);
                              map[entry] = Pool.getSubList([map[entry]]).first;
                              args.add(map[entry]);
                              args.add(user);
                              Navigator.pushNamed(context, "/restaurant",arguments: args);
                            }
                        ),
                      );
                    }
                )
                ,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 90,
            child: Row(
              children: <Widget>[
                ToggleButtons(
                  focusColor: Colors.black,
                  selectedColor: Colors.blue,
                  selectedBorderColor: Colors.blue,
                  fillColor: Colors.blue,
                  constraints: BoxConstraints.tight(Size(100,40)),
                  isSelected: _selections,
                  onPressed: (int index){
                    setState(() {
                      if(index == 0){
                        isRestaurant = true;
                      }
                      else
                        isRestaurant = false;
                    });
                  },
                  children: <Widget>[
                    Text("Restaurante", style: TextStyle(color: isRestaurant ? Colors.blue : Colors.black),),
                    Text("Plato", style: TextStyle(color: !isRestaurant ? Colors.blue : Colors.black))
                  ],),
                SizedBox(width: 30,),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){
                    if(isRestaurant)
                      Navigator.pushNamed(context, "/options");
                    else
                      Navigator.pushNamed(context, "/entryoptions");
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


/*ToggleButtons(
            focusColor: Colors.black,
            selectedColor: Colors.blue,
            selectedBorderColor: Colors.blue,
            fillColor: Colors.blue,
            constraints: BoxConstraints.tight(Size(100,40)),
            isSelected: _selections,
            onPressed: (int index){
              setState(() {
                if(index == 0){
                  restaurant = true;
                }
                else
                  restaurant = false;
              });
              print(restaurant);
            },
            children: <Widget>[
              Text("Restaurante", style: TextStyle(color: restaurant ? Colors.blue : Colors.black),),
              Text("Plato", style: TextStyle(color: !restaurant ? Colors.blue : Colors.black))
            ],),*/