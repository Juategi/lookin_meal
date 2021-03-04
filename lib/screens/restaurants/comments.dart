import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/profile/check_profile.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  MenuEntry entry;
  Map<Rating, User> ratings;
  bool init = true;

  List<Widget> _loadItems(){
    List<Widget> items = [];
    //items.add(null);
    return items;
  }

  void _timer() {
    if(ratings == null) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        setState(() {
          print("Loading..");
        });
        _timer();
      });
    }
  }

  Future _update() async{
    ratings = await DBServiceEntry.dbServiceEntry.getEntryRatings(entry.id);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    entry = ModalRoute.of(context).settings.arguments;
    if(init){
      _update();
      _timer();
      init = false;
    }
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 80.h,
              width: 411.w,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 110, 117, 0.9),
              ),
              child:Column(
                children: [
                  Text(entry.name, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(30),),)),
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: entry.rating, size: ScreenUtil().setSp(20),),
                      SizedBox(width: 10.w,),
                      Text("${entry.numReviews} votes", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),)),
                    ],
                  )
                ],
              ),
            ),
            ratings == null ? Loading() : Expanded(
              child: ListView(
                children: ratings.keys.map((rating) {
                  if(rating.comment != null && rating.comment.length > 0)
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      child: GestureDetector(
                        onTap: (){
                          pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: "/checkprofile", arguments: ratings[rating]),
                            screen: CheckProfile(),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.slideUp,
                          );
                        },
                        child: Container(height: 108.h, width: 300.w,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(height: 67.h, width: 67.w,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(
                                                1, 1), // changes position of shadow
                                          ),
                                          ],
                                          image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: new NetworkImage(
                                                  ratings[rating].picture)
                                          )
                                      )
                                  ),
                                  SizedBox(height: 3.h,),
                                  Container(height: 37.h,
                                      width: 67.w,
                                      child: Text(ratings[rating].name, maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.niramit(
                                            textStyle: TextStyle(color: Colors.black,
                                              letterSpacing: .3,
                                              fontWeight: FontWeight.bold,
                                              fontSize: ScreenUtil().setSp(14),),))),
                                ],
                              ),
                              SizedBox(width: 20.w,),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StarRating(color: Color.fromRGBO(250, 201, 53, 1),
                                    rating: rating.rating,
                                    size: ScreenUtil().setSp(14),),
                                  SizedBox(height: 3.h,),
                                  Container(height: 80.h,
                                      width: 277.w,
                                      child: Text(rating.comment, maxLines: 3,
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.niramit(
                                            textStyle: TextStyle(color: Colors.black87,
                                              letterSpacing: .3,
                                              fontWeight: FontWeight.normal,
                                              fontSize: ScreenUtil().setSp(16),),))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                }
                ).toList()
              ),
            ),
          ],
        ),
      ),
    );
  }
}
