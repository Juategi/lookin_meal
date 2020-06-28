import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:reorderables/reorderables.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditImages extends StatefulWidget {
  Restaurant restaurant;
  EditImages({this.restaurant});
  @override
  _EditImagesState createState() => _EditImagesState(restaurant: restaurant);
}

class _EditImagesState extends State<EditImages> {
  _EditImagesState({this.restaurant});
  Restaurant restaurant;
  List<String> images;
  @override
  void initState() {
    images = List<String>();
    for(String image in restaurant.images){
      images.add(image);
      print(image);
    }

    super.initState();
  }
  List<Widget> _initItems(){
    List<Widget> items = images.map((String url) {
      return GridTile(
          child: FlatButton(
            onPressed: (){
              setState(() {
                images.remove(url);
              });
            },
            padding: EdgeInsets.all(0.0),
            child: Container(
                constraints: BoxConstraints.expand(
                    height: 90,
                    width: 90
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
                      right: 35,
                      bottom: 3.0,
                      child: Icon(Icons.delete, size: 22, color: Colors.black,),
                    ),
                  ],
                )
            ),
          )
      );
    }).toList();
    items.add(
      GridTile(
        child: IconButton(
          icon: Icon(Icons.add_circle_outline, color: Colors.grey[500],),
          iconSize: 73,
          onPressed: ()async{
            String image = await StorageService().uploadImage(context,"restaurants");
            if(image != null){
              setState((){
                images.add(image);
              });
            }
          },
        ),
      )
    );
    return items;
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(child:
        ReorderableWrap(
            spacing: 8.0,
            runSpacing: 4.0,
            padding: const EdgeInsets.all(8),
            onReorder: (a,b){
              setState(() {
                var tmp = images.removeAt(a);
                images.insert(b, tmp);
              });
            },
          children: _initItems()),
      ),
      //SizedBox(height: 20,),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        IconButton(
          icon: FaIcon(FontAwesomeIcons.check, size: 50,),
          iconSize: 73,
          onPressed: (){
            restaurant.images = images;
            Navigator.pop(context);
          },
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.ban, size: 50,),
          iconSize: 73,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],)
    ],);
  }
}