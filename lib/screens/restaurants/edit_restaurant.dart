import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

class EditRestaurant extends StatefulWidget {
  @override
  _EditRestaurantState createState() => _EditRestaurantState();
}


class _EditRestaurantState extends State<EditRestaurant> {
  final _formKey = GlobalKey<FormState>();
  String name, address, phone, email, web;
  List<String> images, types;
  Map<String, List<int>> schedule;
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: <Widget>[
        Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),child:
          Form(
            key: _formKey,
            child: Column(children: <Widget>[
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 290),
                child: Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 13),),
              ),
              SizedBox(height: 10,),
              TextFormField(
                onChanged: (value){
                  setState(() => name = value);
                },
                controller: TextEditingController()..text = restaurant.name,
                validator: (val) => val.length < 4 || val.length > 120 ? "Mínimo 4 carácteres y menos de 120" : null,
                decoration: textInputDeco.copyWith(hintText: "Nombre del restaurant"),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 305),
                child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 13),),
              ),
              SizedBox(height: 10,),
              TextFormField(
                onChanged: (value){
                  setState(() => email = value);
                },
                controller: TextEditingController()..text = restaurant.email,
                validator: (val) => !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? "Introduce un email válido" : null,
                decoration: textInputDeco.copyWith(hintText: "Email"),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 310),
                child: Text("Web", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 13),),
              ),
              SizedBox(height: 10,),
              TextFormField(
                onChanged: (value){
                  setState(() => web = value);
                },
                controller: TextEditingController()..text = restaurant.website,
                validator: (val) => val.length < 4 || val.length > 149 ? "Mínimo 4 carácteres y menos de 150" : null,
                decoration: textInputDeco.copyWith(hintText: "Web del restaurant"),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 290),
                child: Text("Teléfono", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 13),),
              ),
              SizedBox(height: 10,),
              TextFormField(
                onChanged: (value){
                  setState(() => phone = value);
                },
                controller: TextEditingController()..text = restaurant.phone,
                validator: (val) => val.length < 6 || val.length > 49 ? "Mínimo 6 carácteres y menos de 50" : null,
                decoration: textInputDeco.copyWith(hintText: "Teléfono del restaurant"),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 280),
                child: Text("Dirección", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 13),),
              ),
              SizedBox(height: 10,),
              TextFormField(
                onChanged: (value){
                  setState(() => address = value);
                },
                controller: TextEditingController()..text = restaurant.address,
                validator: (val) => val.length < 4 || val.length > 149 ? "Mínimo 4 carácteres y menos de 150" : null,
                decoration: textInputDeco.copyWith(hintText: "Dirección del restaurant"),
              ),
              SizedBox(height: 20,),
              Container(child: MultiSelect(
                  autovalidate: false,
                  titleText: "Tipo de restaurante",
                  validator: (value) {
                    if (value == null) {
                      return 'Please select one or more option(s)';
                    }
                    else
                      return value;
                  },
                  errorText: 'Please select one or more option(s)',
                  dataSource: [
                    {
                      "display": "Australia",
                      "value": 1,
                    },
                    {
                      "display": "Canada",
                      "value": 2,
                    },
                    {
                      "display": "India",
                      "value": 3,
                    },
                    {
                      "display": "United States",
                      "value": 4,
                    }
                  ],
                  textField: 'display',
                  valueField: 'value',
                  filterable: true,
                  required: true,
                  value: null,
                  initialValue: [1,3],
                  maxLength: 20,
                  change: (value) {
                    print('The value is $value');
                  },
              ),),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 280),
                child: Text("Horario", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 13),),
              ),
            ],),
          ),)
      ],)
    );
  }
}

/*
          Expanded(child:
          GridView.count(
              crossAxisCount: 5,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              children: restaurant.images.map((String url) {
                return GridTile(
                    child: FlatButton(
                      onPressed: (){},
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                          constraints: BoxConstraints.expand(
                              height: 130.0,
                              width: 130.0
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: Image.network(url).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                right: 25,
                                bottom: 3.0,
                                child: Icon(Icons.delete, size: 20, color: Colors.black45,),
                              ),
                            ],
                          )
                      ),
                    )
                );
              }).toList()),
        ),
 */