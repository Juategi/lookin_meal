import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';
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
  bool loading;

  @override
  void initState() {
    loading = false;
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
                    height: 90.h,
                    width: 90.w
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
                      right: 35.w,
                      bottom: 3.0.h,
                      child: Icon(Icons.delete, size: ScreenUtil().setSp(22), color: Colors.black,),
                    ),
                  ],
                )
            ),
          )
      );
    }).toList();
    items.add(
      GridTile(
        child: images.length >= 30? Container(height: 0,): IconButton(
          icon: Icon(Icons.add_circle_outline, color: Colors.grey[500],),
          iconSize: ScreenUtil().setSp(73),
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
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Column(children: <Widget>[
      SizedBox(height: 45.h,),
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
      loading? CircularLoading() : Row(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        IconButton(
          icon: FaIcon(FontAwesomeIcons.check, size: ScreenUtil().setSp(50),),
          iconSize: ScreenUtil().setSp(73),
          onPressed: ()async{
            setState(() {
              loading = true;
            });
            restaurant.images = images;
            await DBServiceRestaurant.dbServiceRestaurant.updateRestaurantImages(restaurant.restaurant_id,restaurant.images);
            Alerts.toast("images updated!");
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
    ],);
  }
}