import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/entry.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';

class SearchRestaurantTile extends StatefulWidget {
  @override
  _SearchRestaurantTileState createState() => _SearchRestaurantTileState();
}

class _SearchRestaurantTileState extends State<SearchRestaurantTile> {
  Restaurant restaurant;
  List<MenuEntry> top;
  bool init = true;

  List<MenuEntry> _getTop(){
    int max = 0;
    for(MenuEntry entry in restaurant.menu){
      if(entry.numReviews > max){
        max = entry.numReviews;
      }
    }
    restaurant.menu.sort((e1, e2) =>(e2.rating*0.5 + (e2.numReviews*5/max)*0.5).compareTo((e1.rating*0.5 + (e1.numReviews*5/max)*0.5)));
    return restaurant.menu.sublist(0,3);
  }

  @override
  Widget build(BuildContext context) {
    restaurant = Provider.of<Restaurant>(context);
    if(init){
      top = _getTop();
      init = false;
    }
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "/restaurant",arguments: restaurant).then((value) => setState(() {}));
      },
      child: Container(
        width: 390.w,
        height: 295.h,
        child: Column(
          children: [
            Container(
              height: 130.h,
              width: 390.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network(
                      restaurant.images.first).image,
                  fit: BoxFit.cover,
                ),
              ),
              child: Row( mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon:  Icon(DBService.userF.favorites.contains(restaurant) ? Icons.favorite : Icons.favorite_border, color: DBService.userF.favorites.contains(restaurant) ? Color.fromRGBO(255, 110, 117, 1) : Color.fromRGBO(255, 110, 117, 1),),
                    iconSize: ScreenUtil().setSp(32),
                    onPressed: ()async{
                      if(DBService.userF.favorites.contains(restaurant)) {
                        DBService.userF.favorites.remove(restaurant);
                        DBService.dbService.deleteFromUserFavorites(DBService.userF.uid, restaurant);
                      }
                      else {
                        DBService.userF.favorites.add(restaurant);
                        DBService.dbService.addToUserFavorites(DBService.userF.uid, restaurant);
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h,),
            Row( crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 5.w,),
                Container(width: 214.w, child: Text(restaurant.name,  maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                //SizedBox(width: 1.w,),
                Column(
                  children: <Widget>[
                    SizedBox(height: 4.h,),
                    StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: Functions.getRating(restaurant), size: ScreenUtil().setSp(16),),
                  ],
                ),
                SizedBox(width: 10.w,),
                Column(
                  children: <Widget>[
                    SizedBox(height: 2.h,),
                    Text("${Functions.getVotes(restaurant)} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            Row(
              children: <Widget>[
                SizedBox(width: 5.w,),
                Container(width: 214.w, child: Text(restaurant.types.length > 1 ? "${restaurant.types[0]}, ${restaurant.types[1]}" : "${restaurant.types[0]}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                SizedBox(width: 66.w,),
                Container(
                  child: SvgPicture.asset("assets/markerMini.svg", height: 25.h, width: 25.w,),
                ),
                //Icon(Icons.location_on, color: Colors.black, size: ScreenUtil().setSp(16),),
                Text("${restaurant.distance.toString()} km", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))
              ],
            ),
            SizedBox(height: 10.h,),
            Container(
              height: 93.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: top.map((entry) =>
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: GestureDetector(
                      onTap: () async{
                        await showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
                          return Provider<Restaurant>.value(value: restaurant, child: Provider<MenuEntry>.value(value: entry, child: EntryRating()));
                        }).then((value){setState(() {});});
                      },
                      child: Card(
                        elevation: 2,
                        child: Container(
                          width: 210.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 2.w),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 49.h,
                                      width: 115.w,
                                      child: Text(entry.name,  maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),)),
                                    ),
                                    Row( mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 50.w,),
                                        StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: entry.rating, size: ScreenUtil().setSp(9),),
                                      ],
                                    ),
                                    SizedBox(height: 6.h,),
                                    Row( mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 49.w,
                                          height: 16.h,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(255, 110, 117, 0.9),
                                              borderRadius: BorderRadius.all(Radius.circular(12))
                                          ),
                                          child: Align( alignment: Alignment.center, child: Text("${entry.price} €", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),))),
                                        ),
                                        SizedBox(width: 20.w,),
                                        Text("${entry.numReviews} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 85.h,
                                width: 85.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: Image.network(
                                        entry.image).image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchEntryTile extends StatefulWidget {
  @override
  _SearchEntryTileState createState() => _SearchEntryTileState();
}

class _SearchEntryTileState extends State<SearchEntryTile> {
  Restaurant restaurant;
  MenuEntry entry;
  @override
  Widget build(BuildContext context) {
    restaurant = Provider.of<Restaurant>(context);
    entry = Provider.of<MenuEntry>(context);
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return GestureDetector(
      onTap: () async{
        await showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
          return Provider<Restaurant>.value(value: restaurant, child: Provider<MenuEntry>.value(value: entry, child: EntryRating()));
        }).then((value){setState(() {});});
      },
      child: Container(
        width: 390.w,
        height: 136.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(2, 1),
          ),],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 2.w),
              child: Column(
                children: [
                  Container(
                    height: 47.h,
                    width: 222.w,
                    child: Text(entry.name,  maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                  ),
                  Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: entry.rating, size: ScreenUtil().setSp(16),),
                      SizedBox(width: 10.w,),
                      Text("${entry.numReviews} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                      SizedBox(width: 68.w,),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 44.h,
                        width: 131.w,
                        child: Text(restaurant.name,  maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                      ),
                      Column(
                        children: [
                          /*Container(
                            width: 60.w,
                            height: 23.h,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 110, 117, 0.9),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Align( alignment: Alignment.center, child: Text("${entry.price} €", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(15),),))),
                          ),*/
                          SizedBox(height: 30.h,),
                          Row(
                            children: [
                              Container(
                                child: SvgPicture.asset("assets/markerMini.svg", height: 20.h, width: 20.w,),
                              ),
                              Text("${restaurant.distance.toString()} km", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(13),),))
                            ],
                          )
                        ],
                      ),
                      SizedBox(width: 20.w,),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 136.h,
              width: 136.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network(
                      entry.image).image,
                  fit: BoxFit.cover,
                ),
              ),
              child: entry.price == 0.0 ? Container() : Column( mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                        child: Container(
                          width: 60.w,
                          height: 23.h,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 110, 117, 0.9),
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: Align( alignment: Alignment.center, child: Text("${entry.price} €", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(15),),))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
