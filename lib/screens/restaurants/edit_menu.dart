import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/strings.dart';


class EditMenu extends StatefulWidget {
  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  List<MenuEntry> menu;
  List<String> sections;
  List<int> ids;
  Restaurant restaurant;
  bool init = false;
  bool indicator = false;
  final StorageService _storageService = StorageService();

  void _copyLists(){
    menu = List<MenuEntry>();
    sections = List<String>();
    ids = List<int>();
    if(restaurant.sections == null){
      restaurant.sections = List<String>();
      restaurant.menu = List<MenuEntry>();
    }
    else{
      for (String section in restaurant.sections) {
        sections.add(section);
        for (MenuEntry entry in restaurant.menu) {
          if (entry.section == section) {
            List<String> allergens = [];
            for(String allergen in entry.allergens){
              allergens.add(allergen);
            }
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
                description: entry.description,
                allergens: allergens
            ));
            ids.add(int.parse(entry.id));
          }
        }
      }
    }
    ids.sort();
  }
  List<Widget> _initMenu(){
    menu.sort((f,s)=> f.pos.compareTo(s.pos));
    List<Widget> entries = new List<Widget>();
    entries.add(Text("Nota: dejar precio a 0 o 0.0 para que el plato no tenga precio", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),)));
    entries.add(SizedBox(height: 30.h,));
    for (int i = 0; i < sections.length; i++) {
      String section = sections.elementAt(i);
      entries.add(Container(
        color: Color.fromRGBO(255, 110, 117, 0.2),
        child: Row(children: <Widget>[
          Flexible(
              child: TextFormField(keyboardType: TextInputType.text, controller: TextEditingController()..text = section, onChanged: (v) {
                sections[i] = v;
                for(MenuEntry entry in menu){
                  if(entry.section == section) {
                    entry.section = v;
                  }
                }
                section = v;
            },)),
          IconButton(icon: Icon(Icons.delete), onPressed: (){
            bool flag = false;
            for(MenuEntry entry in menu){
              if(entry.section == section){
                Alerts.dialog('You can not delete a section with entries', context);
                flag = true;
                break;
              }
            }
            if(!flag){
              sections.remove(section);
              setState(() {});
            }
          },),
        ],),
      ));
      entries.add(SizedBox(height: 30.h,));
      for (MenuEntry entry in menu) {
        if (entry.section == section) {
          if(entry.price == null)
            entry.price = 0.0;
          entries.add(Container(
            height: 150.h,
            child: Card(
              elevation: 1,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                SizedBox(width: 5.w,),
                Expanded(child:
                  Container(width: 300.w,
                    child: TextFormField(
                  controller: TextEditingController()..text = entry.name..selection = TextSelection.fromPosition(TextPosition(offset: entry.name.length)), maxLines: 5, maxLength: 150, onChanged: (v) {entry.name = v;},))),
                  SizedBox(width: 10.w,),
                Container( width: 50.w, child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController()..text = entry.price.toString()..selection = TextSelection.fromPosition(TextPosition(offset: entry.price.toString().length)) , maxLength: 6, onChanged: (v) {
                     entry.price = double.parse(v);
                },)),
                FlatButton(onPressed: () async{
                  String image = await _storageService.uploadImage(context,"meals");
                  if(image != null){
                    entry.image = image;
                    setState((){
                    });
                  }
                },
                  child: Container(padding: EdgeInsets.only(
                      left: 30.0.w, bottom: 52.0.h, right: 30.0.w),
                    decoration: BoxDecoration(image: DecorationImage(
                      image:  Image.network(entry.image == null || entry.image == "" ? StaticStrings.defaultEntry : entry.image).image,),),),),
                Column( mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        height: 26.h,
                        width: 26.w,
                        decoration: BoxDecoration(image: DecorationImage(
                          image: Image.asset("assets/allergens/cacahuetes.png").image))
                      ),
                      onTap: (){
                        showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
                          return StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
                                child: ListView(
                                  children: <Widget>[
                                    Text("Alérgenos", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: ScreenUtil().setSp(25),),),
                                    SizedBox(height: 30.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/cacahuetes.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("cacahuetes"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("cacahuetes"))
                                                  entry.allergens.add("cacahuetes");
                                                else
                                                  entry.allergens.remove("cacahuetes");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Cacahuetes", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/altramuces.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("altramuces"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("altramuces"))
                                                  entry.allergens.add("altramuces");
                                                else
                                                  entry.allergens.remove("altramuces");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Altramuces", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/apio.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("apio"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("apio"))
                                                  entry.allergens.add("apio");
                                                else
                                                  entry.allergens.remove("apio");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Apio", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/crustaceos.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("crustaceos"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("crustaceos"))
                                                  entry.allergens.add("crustaceos");
                                                else
                                                  entry.allergens.remove("crustaceos");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Crustaceos", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/frutoscascara.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("frutoscascara"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("frutoscascara"))
                                                  entry.allergens.add("frutoscascara");
                                                else
                                                  entry.allergens.remove("frutoscascara");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Frutos con cascara", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/gluten.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("gluten"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("gluten"))
                                                  entry.allergens.add("gluten");
                                                else
                                                  entry.allergens.remove("gluten");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Gluten", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/huevos.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("huevos"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("huevos"))
                                                  entry.allergens.add("huevos");
                                                else
                                                  entry.allergens.remove("huevos");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Huevos", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/leche.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("leche"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("leche"))
                                                  entry.allergens.add("leche");
                                                else
                                                  entry.allergens.remove("leche");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Leche", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/moluscos.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("moluscos"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("moluscos"))
                                                  entry.allergens.add("moluscos");
                                                else
                                                  entry.allergens.remove("moluscos");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Moluscos", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/mostaza.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("mostaza"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("mostaza"))
                                                  entry.allergens.add("mostaza");
                                                else
                                                  entry.allergens.remove("mostaza");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Mostaza", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/pescado.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("pescado"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("pescado"))
                                                  entry.allergens.add("pescado");
                                                else
                                                  entry.allergens.remove("pescado");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Pescado", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/sesamo.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("sesamo"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("sesamo"))
                                                  entry.allergens.add("sesamo");
                                                else
                                                  entry.allergens.remove("sesamo");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Sesamo", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/soja.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("soja"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("soja"))
                                                  entry.allergens.add("soja");
                                                else
                                                  entry.allergens.remove("soja");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Soja", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset("assets/allergens/sulfitos.png").image))
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: entry.allergens.contains("sulfitos"),
                                            onChanged: (f) {
                                              setState(() {
                                                print(f);
                                                if (!entry.allergens.contains("sulfitos"))
                                                  entry.allergens.add("sulfitos");
                                                else
                                                  entry.allergens.remove("sulfitos");
                                                print(entry.allergens);
                                              });
                                            },
                                            title: Text("Sulfitos", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(20),),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                          );
                        });
                      },
                    ),
                    IconButton(icon: Icon(Icons.description), onPressed: (){
                      String desc = entry.description;
                      print(entry.description);
                      showModalBottomSheet(context: context, builder: (BuildContext bc){
                        return Container(
                          height: 500.h,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.h,),
                              Text("Añade una descripción al plato", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54, fontSize: ScreenUtil().setSp(20),),),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextField(
                                  controller: TextEditingController()..text = desc, maxLines: 6, maxLength: 300, onChanged: (v) {desc = v;},),
                              ),
                              SizedBox(height: 100.h,),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.check, size: ScreenUtil().setSp(50),),
                                    iconSize: ScreenUtil().setSp(73),
                                    onPressed: ()async{
                                      entry.description = desc;
                                      Navigator.pop(context);
                                    },
                                  ),
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.ban, size: ScreenUtil().setSp(50),),
                                    iconSize: ScreenUtil().setSp(73),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],)
                            ],
                          ),
                        );
                      }).then((value){setState(() {});});
                    },),
                  ],
                ),
                IconButton(icon: Icon(Icons.delete), onPressed: (){
                  menu.remove(entry);
                  setState(() {});
                },),
              ],),
            ),
          ));
        }
      }
      entries.add(Row(children: <Widget>[
        IconButton(icon: Icon(Icons.add_circle_outline), onPressed: (){ //HAY QUE CREAR UN ID UNICO TEMPORAL
          if(ids.length == 0){
            menu.add(MenuEntry(
                id: (1).toString(),
                section: section,
                restaurant_id: restaurant.restaurant_id,
                name: "New",
                price: 0,
                rating: 0,
                numReviews: 0,
                pos: menu.length == 0? 0 :  menu.last.pos + 1,
                description: " ",
                allergens: []
            ));
            ids.add(1);
          }
          else{
            menu.add(MenuEntry(
                id: (ids.last + 1).toString(),
                section: section,
                restaurant_id: restaurant.restaurant_id,
                name: "New",
                price: 0,
                rating: 0,
                numReviews: 0,
                pos: menu.length == 0? 0 :  menu.last.pos + 1,
                description: " ",
                allergens: []
            ));
            ids.add(ids.last + 1);
          }
          setState(() {});
        },),
        Text("Añadir plato", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))
      ],));
      entries.add(SizedBox(height: 30.h,));
    }
    entries.add(Row(children: <Widget>[IconButton(icon: Icon(Icons.add_circle_outline, size: ScreenUtil().setSp(30),), onPressed: (){
      sections.add("New");
      setState(() {});
      },), Text("Añadir seccion", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(20),),))],));

    this.setState((){});
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    restaurant = ModalRoute.of(context).settings.arguments;
    if(!init){
      _copyLists();
      init = true;
    }
    return Scaffold(
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
                Align( alignment: AlignmentDirectional.topCenter, child: Text("Editar carta", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: ListView(children: _initMenu()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50.h,
                width: 160.w,
                child: RaisedButton(elevation: 0,
                  color: Color.fromRGBO(255, 110, 117, 0.9),
                  child: Text("Editar orden", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18)),),
                  onPressed: () async{
                  dynamic result = await Navigator.pushNamed(context, "/editorder",arguments:[sections,menu]);
                  if(result != null){
                    result = List.from(result);
                    sections = result.first;
                    menu = result.last;
                  }
                  setState(() {});
                }, ),
              ),
              SizedBox(width: 30.w,),
              Container(
                height: 50.h,
                width: 160.w,
                child: RaisedButton(elevation: 0,
                  color: Color.fromRGBO(255, 110, 117, 0.9),
                  child: Text("Guardar", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18)),),
                  onPressed: ()async{
                  List temp = sections.toSet().toList();
                  if(temp.length < sections.length){
                    Alerts.dialog('You can not have sections with the same name', context);
                    return;
                  }
                  for(String section in sections){
                    if(int.tryParse(section) != null){
                      Alerts.dialog('You can not have sections with just numbers', context);
                      return;
                    }
                  }
                  indicator = true;
                  setState(() {
                  });
                  for(MenuEntry entry in menu){
                    entry.price = entry.price.toDouble();
                    //print("${entry.section} / ${entry.name} / ${entry.price}/ ${entry.allergens}");
                  }
                  await DBService().uploadMenu(sections, menu, restaurant);
                  Alerts.toast("Menu saved");
                  setState(() {
                  });
                  Navigator.pop(context);
                },),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
