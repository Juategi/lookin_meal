import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RestaurantTile extends StatefulWidget {
  @override
  _RestaurantTileState createState() => _RestaurantTileState();
}

class _RestaurantTileState extends State<RestaurantTile> {
  Restaurant restaurant;
  User user;

  Future updateRecent() async{
    if(!user.recently.contains(restaurant)){
      if(user.recently.length == 5){
        user.recently.removeAt(0);
      }
      user.recently.add(restaurant);
      user.recent = user.recently;
      DBService.dbService.updateRecently();
    }
  }

  @override
  Widget build(BuildContext context) {
    restaurant = Provider.of<Restaurant>(context);
    user = DBService.userF;
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GestureDetector(
        onTap: (){
          updateRecent();
          Navigator.pushNamed(context, "/restaurant",arguments: restaurant);
        },
        child: Container(
          width: 240.w,
          height: 120.h,
          child: Column(
            children: <Widget>[
              Container(
                height: 103.h,
                width: 240.w,
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
                      icon:  Icon(user.favorites.contains(restaurant) ? Icons.favorite : Icons.favorite_border, color: user.favorites.contains(restaurant) ? Color.fromRGBO(255, 110, 117, 1) : Color.fromRGBO(255, 110, 117, 1),),
                      iconSize: ScreenUtil().setSp(32),
                      onPressed: ()async{
                        if(user.favorites.contains(restaurant)) {
                          user.favorites.remove(restaurant);
                          DBService.dbService.deleteFromUserFavorites(user.uid, restaurant);
                        }
                        else {
                          user.favorites.add(restaurant);
                          DBService.dbService.addToUserFavorites(user.uid, restaurant);
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
                  Container(width: 145.w, child: Text(restaurant.name,  maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(12),),))),
                  //SizedBox(width: 1.w,),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 4.h,),
                      StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: Functions.getRating(restaurant), size: ScreenUtil().setSp(8),),
                    ],
                  ),
                  SizedBox(width: 3.w,),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 2.h,),
                      Text("${Functions.getVotes(restaurant)} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(8),),)),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: <Widget>[
                  SizedBox(width: 5.w,),
                  Container(width: 150.w, child: Text(restaurant.types.length > 1 ? "${restaurant.types[0]}, ${restaurant.types[1]}" : "${restaurant.types[0]}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(10),),))),
                  SizedBox(width: 23.w,),
                  Container(
                    child: SvgPicture.asset("assets/markerMini.svg"),
                  ),
                  //Icon(Icons.location_on, color: Colors.black, size: ScreenUtil().setSp(16),),
                  Text("${restaurant.distance.toString()} km", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(10),),))
                ],
              ),
              SizedBox(height: 3.h,)
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(1, 1), // changes position of shadow
            ),]
          ),
        ),
      ),
    );
  }
}

//Navigator.pushNamed(context, "/restaurant",arguments: restaurant);