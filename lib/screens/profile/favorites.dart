import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/strings.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
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
              Navigator.pushNamed(context, "/favslists", arguments: 'R');
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
              Navigator.pushNamed(context, "/favslists", arguments: 'E');
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
    items.addAll(DBService.userF.lists.map((list) => list.type != type? Container() : Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
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
                SizedBox(height: 19.h,),
                Icon(Icons.delete_outline, size: ScreenUtil().setSp(45), color: Colors.black87)
              ],
            )
          ],
        ),
      ),
    )));
    items.add(Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: GestureDetector(
        onTap: ()async{
         await Navigator.pushNamed(context, "/createlist", arguments: type);
         setState(() {
         });
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
    return Scaffold(
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
    return Scaffold(
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
              maxLength: 60,
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
                FavoriteList list = await DBService.dbService.createList(DBService.userF.uid, name, StaticStrings.defaultEntry, type);
                DBService.userF.lists.add(list);
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
    );
  }
}
