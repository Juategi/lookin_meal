import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/home/home.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/json_update.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:lookinmeal/shared/loading.dart';
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
  bool restaurant = true;
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
                child: SearchBar(
                  emptyWidget: Text(error),
                  cancellationWidget: Text(" Cancel "),
                  debounceDuration: Duration(milliseconds: 800),
                  loader: Center(child: SpinKitChasingDots(color: Colors.brown, size: 50.0,),),
                  minimumChars: 1,
                  onSearch: _search,
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
                  },
                ),
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
                  ],),
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