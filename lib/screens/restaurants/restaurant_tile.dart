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
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RestaurantTile extends StatefulWidget {
  @override
  _RestaurantTileState createState() => _RestaurantTileState();
}

class _RestaurantTileState extends State<RestaurantTile> {
  Restaurant restaurant;
  User user;
  @override
  Widget build(BuildContext context) {
    restaurant = Provider.of<Restaurant>(context);
    user = DBService.userF;
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, "/restaurant",arguments: restaurant);
        },
        child: Container(
          color: Colors.white,
          width: 240.w,
          height: 110.h,
          child: Column(
            children: <Widget>[
              Container(
                height: 103.h,
                width: 240.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.network(
                        restaurant.images.first).image,
                    fit: BoxFit.fill,
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
              Row( crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 5.w,),
                  Container(width: 145.w, child: Text(restaurant.name,  maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(12),),))),
                  //SizedBox(width: 1.w,),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 4.h,),
                      SmoothStarRating(rating: restaurant.rating, spacing: -3, isReadOnly: true, allowHalfRating: true, color: Color.fromRGBO(250, 201, 53, 1), borderColor: Color.fromRGBO(250, 201, 53, 1), size: ScreenUtil().setSp(12),),
                    ],
                  ),
                  SizedBox(width: 3.w,),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 4.h,),
                      Text("${restaurant.numrevta} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(8),),)),
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
        ),
      ),
    );
  }
}

//Navigator.pushNamed(context, "/restaurant",arguments: restaurant);