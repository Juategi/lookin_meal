import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/edit_images.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

class EditRestaurant extends StatefulWidget {
  @override
  _EditRestaurantState createState() => _EditRestaurantState();
}


class _EditRestaurantState extends State<EditRestaurant> {
  final _formKey = GlobalKey<FormState>();
  String name, address, phone, email, web;
  List<String> types, delivery;
  Map<String, List<int>> schedule;
  Restaurant restaurant;
  bool loading, init;

  @override
  void initState() {
    init = false;
    loading = false;
    schedule = {'1': new List<int>()..add(-1)..add(-1)..add(-1)..add(-1), '2': new List<int>()..add(-1)..add(-1)..add(-1)..add(-1), '3': new List<int>()..add(-1)..add(-1)..add(-1)..add(-1), '4': new List<int>()..add(-1)..add(-1)..add(-1)..add(-1), '5': new List<int>()..add(-1)..add(-1)..add(-1)..add(-1), '6': new List<int>()..add(-1)..add(-1)..add(-1)..add(-1), '0': new List<int>()..add(-1)..add(-1)..add(-1)..add(-1)};
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    if(!init){
      name = restaurant.name;
      phone = restaurant.phone;
      web = restaurant.website;
      address = restaurant.address;
      email = restaurant.email;
      types = restaurant.types;
      delivery = restaurant.delivery;
      if(delivery == null){
        delivery = ["-", "-", "-", "-"];
      }
      init = true;
    }
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.h,
          child: Row( mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50.h,
                width: 260.w,
                child: loading? CircularLoading() : RaisedButton(
                  elevation: 0,
                  color: Color.fromRGBO(255, 110, 117, 0.9),
                  child: Text("Guardar", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18)),),
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      for(int i = 0; i < delivery.length; i++){
                        if(delivery[i] == "" || delivery[i] == " "){
                          delivery[i] = "-";
                        }
                        delivery[i] = delivery[i].trim();
                      }
                      await DBService().updateRestaurantData(restaurant.restaurant_id, name, phone, web, address, email, types, schedule, delivery);
                      restaurant.name = name;
                      restaurant.phone = phone;
                      restaurant.website = web;
                      restaurant.address = address;
                      restaurant.email = email;
                      restaurant.types = types;
                      restaurant.schedule = schedule;
                      restaurant.delivery = delivery;
                      Navigator.pop(context);
                    }
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
                Align( alignment: AlignmentDirectional.topCenter, child: Text("Editar restaurante", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
              ],
            ),
          ),
          Expanded(
            child: ListView(children: <Widget>[
              Container(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),child:
                Form(
                  key: _formKey,
                  child: Column( crossAxisAlignment:CrossAxisAlignment.start, children: <Widget>[
                    SizedBox(height: 20,),
                    Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(15)),),
                    SizedBox(height: 10,),
                    TextFormField(
                      onChanged: (value){
                        name = value;
                      },
                      controller: TextEditingController()..text = restaurant.name,
                      validator: (val) => val.length < 4 || val.length > 120 ? "Mínimo 4 carácteres y menos de 120" : null,
                      decoration: textInputDeco.copyWith(hintText: "Nombre del restaurant"),
                    ),
                    SizedBox(height: 20,),
                    Text("Email", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(15)),),
                    SizedBox(height: 10,),
                    TextFormField(
                      onChanged: (value){
                        email = value;
                      },
                      controller: TextEditingController()..text = restaurant.email,
                      validator: (val) => !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? "Introduce un email válido" : null,
                      decoration: textInputDeco.copyWith(hintText: "Email"),
                    ),
                    SizedBox(height: 20,),
                    Text("Web", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(15)),),
                    SizedBox(height: 10,),
                    TextFormField(
                      onChanged: (value){
                        web = value;
                      },
                      controller: TextEditingController()..text = restaurant.website,
                      validator: (val) => val.length < 4 || val.length > 149 ? "Mínimo 4 carácteres y menos de 150" : null,
                      decoration: textInputDeco.copyWith(hintText: "Web del restaurant"),
                    ),
                    SizedBox(height: 20,),
                    Text("Teléfono", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(15)),),
                    SizedBox(height: 10,),
                    TextFormField(
                      onChanged: (value){
                        phone = value;
                      },
                      controller: TextEditingController()..text = restaurant.phone,
                      validator: (val) => val.length < 6 || val.length > 49 ? "Mínimo 6 carácteres y menos de 50" : null,
                      decoration: textInputDeco.copyWith(hintText: "Teléfono del restaurant"),
                    ),
                    SizedBox(height: 20,),
                    Text("Dirección", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(15)),),
                    SizedBox(height: 10,),
                    TextFormField(
                      onChanged: (value){
                        address = value;
                      },
                      controller: TextEditingController()..text = restaurant.address,
                      validator: (val) => val.length < 4 || val.length > 149 ? "Mínimo 4 carácteres y menos de 150" : null,
                      decoration: textInputDeco.copyWith(hintText: "Dirección del restaurant"),
                    ),
                    SizedBox(height: 20,),
                    Text("A domicilio", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(15)),),
                    SizedBox(height: 20,),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/glovo.png").image),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                        ),
                        SizedBox(width: 20,),
                        Flexible(
                          child: TextFormField(
                            onChanged: (value){
                              delivery[0] = value;
                            },
                            controller: TextEditingController()..text = restaurant.delivery == null? "" : restaurant.delivery[0] ,
                            decoration: textInputDeco,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/ubereats.png").image),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                        ),
                        SizedBox(width: 20,),
                        Flexible(
                          child: TextFormField(
                            onChanged: (value){
                              delivery[1] = value;
                            },
                            controller: TextEditingController()..text = restaurant.delivery == null? "" : restaurant.delivery[1] ,
                            decoration: textInputDeco,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/justeat.png").image),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                        ),
                        SizedBox(width: 20,),
                        Flexible(
                          child: TextFormField(
                            onChanged: (value){
                              delivery[2] = value;
                            },
                            controller: TextEditingController()..text = restaurant.delivery == null? "" : restaurant.delivery[2] ,
                            decoration: textInputDeco,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/deliveroo.png").image),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                        ),
                        SizedBox(width: 20,),
                        Flexible(
                          child: TextFormField(
                            onChanged: (value){
                              delivery[3] = value;
                            },
                            controller: TextEditingController()..text = restaurant.delivery == null? "" : restaurant.delivery[3] ,
                            decoration: textInputDeco,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text("Horario", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(15)),),
                    SizedBox(height: 20,),
                    Text("Lunes:"),
                    SizedBox(height: 5,),
                    Row(children: _initRow(1),),
                    SizedBox(height: 25,),
                    Text("Martes:"),
                    SizedBox(height: 5,),
                    Row(children: _initRow(2),),
                    SizedBox(height: 25,),
                    Text("Miercoles:"),
                    SizedBox(height: 5,),
                    Row(children: _initRow(3),),
                    SizedBox(height: 25,),
                    Text("Jueves:"),
                    SizedBox(height: 5,),
                    Row(children: _initRow(4),),
                    SizedBox(height: 25,),
                    Text("Viernes:"),
                    SizedBox(height: 5,),
                    Row(children: _initRow(5),),
                    SizedBox(height: 25,),
                    Text("Sábado:"),
                    SizedBox(height: 5,),
                    Row(children: _initRow(6),),
                    SizedBox(height: 25,),
                    Text("Domingo:"),
                    SizedBox(height: 5,),
                    Row(children: _initRow(0),),
                    SizedBox(height: 25,),
                  ],),
                ),),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Container(child: MultiSelect(
                  //autovalidate: false,
                  titleText: "Tipo de restaurante",
                  /*validator: (value) {
                            if (value == null) {
                              return 'Please select one or more option(s)';
                            }
                            else
                              return "";
                          },*/
                  //errorText: 'Please select one or more option(s)',
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
                  initialValue: restaurant.types,
                  maxLength: 20,
                  change: (value) {
                    types = List<String>.from(value);
                  },
                ),),
              ),
              SizedBox(height: 40,),

            ],),
          ),
        ],
      )
    );
  }

  List<Widget> _initRow(int i){
    List<Widget> items = List<Widget>();
    if(restaurant.schedule[i.toString()].length == 2){
      restaurant.schedule[i.toString()].add(-1);
      restaurant.schedule[i.toString()].add(-1);
    }
    else if(restaurant.schedule[i.toString()].length == 0){
      restaurant.schedule[i.toString()].add(-1);
      restaurant.schedule[i.toString()].add(-1);
      restaurant.schedule[i.toString()].add(-1);
      restaurant.schedule[i.toString()].add(-1);
    }

    for(int j = 0; j < 4; j++){
      schedule[i.toString()][j] = restaurant.schedule[i.toString()][j];
      items.add(
        Container( width: 66,
          child: TextFormField(
            onChanged: (value){
              if(value == "")
                schedule[i.toString()][j] = -1;
              else
                schedule[i.toString()][j] = int.parse(value);
              print(schedule);
            },
            initialValue: restaurant.schedule[i.toString()][j] == -1? null : restaurant.schedule[i.toString()][j].toString(),
            decoration: textInputDeco.copyWith(hintText: "00"),
            keyboardType: TextInputType.number,
          ),
        ),
      );
      if(j == 0 || j == 2)
        items.add(Text("   -   "));
      else if(j == 1)
        items.add(SizedBox( width: 20,));
    }
    return items;
  }
}
