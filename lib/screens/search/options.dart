import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/search/parameters.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:provider/provider.dart';

class SearchOptions extends StatefulWidget {
  @override
  _SearchOptionsState createState() => _SearchOptionsState();
}

class _SearchOptionsState extends State<SearchOptions> {
  List<bool> _selections = List.generate(2, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("Seleccionar tipos"),
          SizedBox(height: 10,),
          Container(child: MultiSelect(
            titleText: "Tipo de restaurante",
            dataSource: [
              {"value": "Café"},
              {"value": "Afghan"},
              {"value": "Afghani"},
              {"value": "African"},
              {"value": "American"},
              {"value": "Argentinean"},
              {"value": "Armenian"},
              {"value": "Asian"},
              {"value": "Asian Fusion"},
              {"value": "Australian"},
              {"value": "Austrian"},
              {"value": "Bagels"},
              {"value": "Bahamian"},
              {"value": "Bakery"},
              {"value": "Balti"},
              {"value": "Bangladeshi"},
              {"value": "Bar"},
              {"value": "Barbeque"},
              {"value": "Basque"},
              {"value": "Belgian"},
              {"value": "Bistro"},
              {"value": "Brasserie"},
              {"value": "Brazilian"},
              {"value": "Brew Pub"},
              {"value": "British"},
              {"value": "Burmese"},
              {"value": "Cajun & Creole"},
              {"value": "Californian"},
              {"value": "Cambodian"},
              {"value": "Canadian"},
              {"value": "Caribbean"},
              {"value": "Central American"},
              {"value": "Central European"},
              {"value": "Chicken Wings"},
              {"value": "Chilean"},
              {"value": "Chinese"},
              {"value": "Chowder"},
              {"value": "Coffee Shop"},
              {"value": "Colombian"},
              {"value": "Contemporary"},
              {"value": "Continental"},
              {"value": "Costa Rican"},
              {"value": "Creperie"},
              {"value": "Croatian"},
              {"value": "Cuban"},
              {"value": "Czech"},
              {"value": "Danish"},
              {"value": "Delicatessen"},
              {"value": "Dessert"},
              {"value": "Dim Sum"},
              {"value": "Diner"},
              {"value": "Donuts"},
              {"value": "Dutch"},
              {"value": "Eastern European"},
              {"value": "Eclectic"},
              {"value": "Ecuadorean"},
              {"value": "Egyptian"},
              {"value": "English"},
              {"value": "Ethiopian"},
              {"value": "European"},
              {"value": "Family Fare"},
              {"value": "Fast Food"},
              {"value": "Filipino"},
              {"value": "Fish & Chips"},
              {"value": "Fondue"},
              {"value": "French"},
              {"value": "Fusion"},
              {"value": "Gastropub"},
              {"value": "German"},
              {"value": "Greek"},
              {"value": "Grill"},
              {"value": "Guatemalan"},
              {"value": "Gluten Free Options"},
              {"value": "Halal"},
              {"value": "Hamburgers"},
              {"value": "Hawaiian"},
              {"value": "Healthy"},
              {"value": "Hot Dogs"},
              {"value": "Hunan"},
              {"value": "Hungarian"},
              {"value": "Ice Cream"},
              {"value": "Indian"},
              {"value": "Indonesian"},
              {"value": "International"},
              {"value": "Irish"},
              {"value": "Israeli"},
              {"value": "Italian"},
              {"value": "Jamaican"},
              {"value": "Japanese"},
              {"value": "Korean"},
              {"value": "Kosher"},
              {"value": "Latin"},
              {"value": "Latvian"},
              {"value": "Lebanese"},
              {"value": "Malaysian"},
              {"value": "Mediterranean"},
              {"value": "Mexican"},
              {"value": "Middle Eastern"},
              {"value": "Mongolian"},
              {"value": "Moroccan"},
              {"value": "Native American"},
              {"value": "Nepali"},
              {"value": "New Zealand"},
              {"value": "Nonya"},
              {"value": "Noodle"},
              {"value": "Noodle Shop"},
              {"value": "Norwegian"},
              {"value": "Organic"},
              {"value": "Oyster Bar"},
              {"value": "Pacific Rim"},
              {"value": "Pakistani"},
              {"value": "Pan-Asian"},
              {"value": "Pasta"},
              {"value": "Peruvian"},
              {"value": "Philippine"},
              {"value": "Pizza"},
              {"value": "Pizza & Pasta"},
              {"value": "Polish"},
              {"value": "Polynesian"},
              {"value": "Portuguese"},
              {"value": "Pub"},
              {"value": "Puerto Rican"},
              {"value": "Romanian"},
              {"value": "Russian"},
              {"value": "Salvadoran"},
              {"value": "Sandwiches"},
              {"value": "Scandinavian"},
              {"value": "Scottish"},
              {"value": "Seafood"},
              {"value": "Singaporean"},
              {"value": "Slovenian"},
              {"value": "Soups"},
              {"value": "South American"},
              {"value": "Southwestern"},
              {"value": "Spanish"},
              {"value": "Sri Lankan"},
              {"value": "Steakhouse"},
              {"value": "Street Food"},
              {"value": "Sushi"},
              {"value": "Swedish"},
              {"value": "Swiss"},
              {"value": "Szechuan"},
              {"value": "Taiwanese"},
              {"value": "Tapas"},
              {"value": "Tea Room"},
              {"value": "Thai"},
              {"value": "Tibetan"},
              {"value": "Tunisian"},
              {"value": "Turkish"},
              {"value": "Ukrainian"},
              {"value": "Vegan Options"},
              {"value": "Vegetarian Friendly"},
              {"value": "Venezuelan"},
              {"value": "Vietnamese"},
              {"value": "Welsh"},
              {"value": "Wine Bar"},
              {"value": "Winery"},
              {"value": "Yugoslavian"},
            ],
            textField: 'value',
            valueField: 'value',
            filterable: true,
            required: true,
            value: null,
            initialValue: Parameters.types,
            maxLength: 20,
            change: (value) {
              if(value == null){
                Parameters.types = null;
              }
              else
              Parameters.types = List<String>.from(value);
            },
          ),),
          SizedBox(height: 50,),
          Text("Ordenar por:"),
          SizedBox(height: 10,),
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
                  Parameters.valoration = false;
                }
                else
                  Parameters.valoration = true;
              });
              print(Parameters.valoration);
            },
            children: <Widget>[
              Text("Menor distancia", style: TextStyle(color: !Parameters.valoration ? Colors.blue : Colors.black),),
              Text("Mejor nota", style: TextStyle(color: Parameters.valoration ? Colors.blue : Colors.black))
            ],),
        ],
      ),
    );
  }
}

class SearchEntry extends StatefulWidget {
  @override
  _SearchEntryState createState() => _SearchEntryState();
}

class _SearchEntryState extends State<SearchEntry> {
  List<bool> _selections = List.generate(2, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("Precio máximo: ${Parameters.price} €"),
          SizedBox(height: 20,),
          Slider(
            value: Parameters.price,
            max: 100,
            min: 0,
            divisions: 10,
            label: "${Parameters.price} €",
            onChanged: (value) {
              setState(() {
                Parameters.price = value;
              });
            },
          ),
          SizedBox(height: 50,),
          Text("Ordenar por:"),
          SizedBox(height: 10,),
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
                  Parameters.valoration = false;
                }
                else
                  Parameters.valoration = true;
              });
              print(Parameters.valoration);
            },
            children: <Widget>[
              Text("Menor precio", style: TextStyle(color: !Parameters.valoration ? Colors.blue : Colors.black),),
              Text("Mejor nota", style: TextStyle(color: Parameters.valoration ? Colors.blue : Colors.black))
            ],),
        ],
      ),
    );
  }
}

