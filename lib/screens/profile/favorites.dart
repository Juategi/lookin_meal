import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:provider/provider.dart';

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
    items.add(Container(
      height: 113,
      width: 336,
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
          Container(
            height: 100.h,
            width: 100.w,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.network(StaticStrings.defaultEntry).image
              )
            ),
          ),
          SizedBox(width: 40.w,),
          Text("Favorites", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
        ],
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
