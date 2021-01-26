import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'file:///C:/D/lookin_meal/lib/screens/restaurants/admin/edit_images.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
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
  String name, address, phone, email, web, currency;
  List<String> types, delivery;
  Map<String, List<String>> schedule;
  Restaurant restaurant;
  bool loading, init;
  List<List<Widget>> scheduleTree = [];

  @override
  void initState() {
    init = false;
    loading = false;
    schedule = {'1': new List<String>()..add("-1")..add("-1")..add("-1")..add("-1"), '2': new List<String>()..add("-1")..add("-1")..add("-1")..add("-1"), '3': new List<String>()..add("-1")..add("-1")..add("-1")..add("-1"), '4': new List<String>()..add("-1")..add("-1")..add("-1")..add("-1"), '5': new List<String>()..add("-1")..add("-1")..add("-1")..add("-1"), '6': new List<String>()..add("-1")..add("-1")..add("-1")..add("-1"), '0': new List<String>()..add("-1")..add("-1")..add("-1")..add("-1")};
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
      currency = restaurant.currency;
      for(int i = 0; i <=6; i++){
        scheduleTree.add(_initRow(i));
      }
      if(delivery == null){
        delivery = ["-", "-", "-", "-"];
      }
      init = true;
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
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
                          delivery[i] = delivery[i].trim();
                        }
                        await DBServiceRestaurant.dbServiceRestaurant.updateRestaurantData(restaurant.restaurant_id, name, phone, web, address, email, types, schedule, delivery, currency);
                        restaurant.currency = currency;
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
                        controller: TextEditingController()..text = name..selection = TextSelection.fromPosition(TextPosition(offset: name.length)),
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
                        controller: TextEditingController()..text = email..selection = TextSelection.fromPosition(TextPosition(offset: email.length)),
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
                        controller: TextEditingController()..text = web..selection = TextSelection.fromPosition(TextPosition(offset: web.length)),
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
                        controller: TextEditingController()..text = phone..selection = TextSelection.fromPosition(TextPosition(offset: phone.length)),
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
                        controller: TextEditingController()..text = address..selection = TextSelection.fromPosition(TextPosition(offset: address.length)),
                        validator: (val) => val.length < 4 || val.length > 149 ? "Mínimo 4 carácteres y menos de 150" : null,
                        decoration: textInputDeco.copyWith(hintText: "Dirección del restaurant"),
                      ),
                      SizedBox(height: 20,),
                      Text("Moneda", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(15)),),
                      SizedBox(height: 10,),
                      DropdownButton(
                        value: currency,
                        elevation: 1,
                        items: [
                          DropdownMenuItem(
                            child: Row(
                              children: <Widget>[
                                Text("€", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                                SizedBox(width: 50.w,)
                              ],
                            ),
                            value: "€",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: <Widget>[
                                Text("\$", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                                SizedBox(width: 50.w,)
                              ],
                            ),
                            value: "\$",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: <Widget>[
                                Text("£", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                                SizedBox(width: 50.w,)
                              ],
                            ),
                            value: "£",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: <Widget>[
                                Text("¥", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                                SizedBox(width: 50.w,)
                              ],
                            ),
                            value: "¥",
                          ),
                        ],
                        onChanged: (selected) async{
                          setState(() {
                            currency = selected;
                          });
                        },
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
                              controller: TextEditingController()..text = delivery == null? "" : delivery[0]..selection = TextSelection.fromPosition(TextPosition(offset: delivery[0].length)) ,
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
                              controller: TextEditingController()..text = delivery == null? "" : delivery[1]..selection = TextSelection.fromPosition(TextPosition(offset: delivery[1].length)) ,
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
                              controller: TextEditingController()..text = delivery == null? "" : delivery[2]..selection = TextSelection.fromPosition(TextPosition(offset: delivery[2].length)) ,
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
                              controller: TextEditingController()..text = delivery == null? "" :delivery[3]..selection = TextSelection.fromPosition(TextPosition(offset: delivery[3].length)) ,
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
                      Row(children: scheduleTree[1],),
                      SizedBox(height: 25,),
                      Text("Martes:"),
                      SizedBox(height: 5,),
                      Row(children: scheduleTree[2],),
                      SizedBox(height: 25,),
                      Text("Miercoles:"),
                      SizedBox(height: 5,),
                      Row(children: scheduleTree[3],),
                      SizedBox(height: 25,),
                      Text("Jueves:"),
                      SizedBox(height: 5,),
                      Row(children: scheduleTree[4],),
                      SizedBox(height: 25,),
                      Text("Viernes:"),
                      SizedBox(height: 5,),
                      Row(children: scheduleTree[5]),
                      SizedBox(height: 25,),
                      Text("Sábado:"),
                      SizedBox(height: 5,),
                      Row(children: scheduleTree[6]),
                      SizedBox(height: 25,),
                      Text("Domingo:"),
                      SizedBox(height: 5,),
                      Row(children: scheduleTree[0]),
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
                    dataSource: CommonData.types,
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
      ),
    );
  }

  List<Widget> _initRow(int i){
    List<Widget> items = List<Widget>();
    if(restaurant.schedule[i.toString()].length == 2){
      restaurant.schedule[i.toString()].add("-1");
      restaurant.schedule[i.toString()].add("-1");
    }
    else if(restaurant.schedule[i.toString()].length == 0){
      restaurant.schedule[i.toString()].add("-1");
      restaurant.schedule[i.toString()].add("-1");
      restaurant.schedule[i.toString()].add("-1");
      restaurant.schedule[i.toString()].add("-1");
    }

    for(int j = 0; j < 4; j++){
      schedule[i.toString()][j] = restaurant.schedule[i.toString()][j].replaceAll("[", "").replaceAll("]", "").trim();
      print(schedule[i.toString()][j] );
      items.add(
        Container( width: 66,
          child: TextFormField(
            onChanged: (value){
              if(value == "")
                schedule[i.toString()][j] = "-1";
              else {
                if(value.length == 1){
                  schedule[i.toString()][j] = "0" + value;
                }
                else
                  schedule[i.toString()][j] = value;
              }
              print(schedule);
            },
            initialValue: restaurant.schedule[i.toString()][j].replaceAll("[", "").replaceAll("]", "").trim() == "-1"? null : restaurant.schedule[i.toString()][j].replaceAll("[", "").replaceAll("]", "").trim(),
            decoration: textInputDeco.copyWith(hintText: "0000"),
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
