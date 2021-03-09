import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/profile/rating_history.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'favorites.dart';

class CheckProfile extends StatefulWidget {
  @override
  _CheckProfileState createState() => _CheckProfileState();
}

class _CheckProfileState extends State<CheckProfile> {
  User user;
  bool init = true;

  Future loadInfo() async{
    user.lists = await DBServiceUser.dbServiceUser.getLists();
    user.ratings = await DBServiceEntry.dbServiceEntry.getAllRating(user.uid);
    user.history = await DBServiceEntry.dbServiceEntry.getRatingsHistory(user.uid, user.ratings.map((r) => r.entry_id).toList(), 0, 15);
    user.numFollowers = await DBServiceUser.dbServiceUser.getNumFollowers(user.uid);
    user.numFollowing = await DBServiceUser.dbServiceUser.getNumFollowing(user.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;
    if(init){
      loadInfo();
      init = false;
    }
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 260.h,
            //color: Colors.blue,
            child: Stack(
              children: [
                Container(
                  height: 130.h,
                  width: 411.w,
                  color: Color.fromRGBO(255, 110, 117, 0.60),
                ),
                Column(
                  children: [
                    SizedBox(height: 30.h,),
                    Container(
                      height: 220.h,
                      width: 220.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Container(
                          height: 160.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                          ),
                          child: Center(
                            child: Container(
                              height: 143.h,
                              width: 143.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey
                              ),
                              child: Center(
                                child: Container(
                                  height: 136.h,
                                  width: 136.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: Image.network(user.picture).image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 90.h,
                  right: 10.w,
                  child: Container(
                    width: 190.w,
                    child:Text(user.username, maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(23),),)),
                  ),
                ),
                Positioned(
                  top: 140.h,
                  right: 10.w,
                  child: Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 160.w,
                        child:Text(user.name, maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                      ),
                      Flag(
                        user.country,
                        height: 30.h,
                        width: 30.w,
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 175.h,
                  right: 20.w,
                  child: Container(
                    width: 180.w,
                    child:Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Text("770 T", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                        //Spacer(),
                        Text(user.ratings == null ? "0" :user.ratings.length.toString(), maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                        SizedBox(width: 5.w,),
                        Icon(Icons.star, size: ScreenUtil().setSp(28), color: Colors.yellow,)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
                children: [
                  Text(user.numFollowers.toString(), maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(19),),)),
                  Text(" followers", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                  Spacer(),
                  Text(user.numFollowing.toString(), maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(19),),)),
                  Text(" following", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
                ]
            ),
          ),
          SizedBox(height: 20.h,),
          GestureDetector(
            onTap: ()async{
              if(DBServiceUser.userF.following.contains(user.uid)) {
                DBServiceUser.userF.following.remove(user.uid);
                setState(() {
                });
                await DBServiceUser.dbServiceUser.deleteFollower(DBServiceUser.userF.uid, user.uid);
              }
              else {
                DBServiceUser.userF.following.add(user.uid);
                setState(() {
                });
                await DBServiceUser.dbServiceUser.addFollower(user.uid);
              }
              user.numFollowers = await DBServiceUser.dbServiceUser.getNumFollowers(user.uid);
              setState(() {
              });
            },
            child: Center(
              child: Container(
                width: 185.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: DBServiceUser.userF.following.contains(user.uid) ? Colors.redAccent: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(1, 1), // changes position of shadow
                  ),],
                ),
                child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DBServiceUser.userF.following.contains(user.uid) ? Container() : Icon(Icons.add_rounded, size: ScreenUtil().setSp(32), color: Colors.white,),
                    Column(
                      children: [
                        SizedBox(height: 4.h,),
                        Text(DBServiceUser.userF.following.contains(user.uid) ? "Stop following" : "   Follow", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(23),),)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              width: 381.w,
              height: user.about == null ? 1 : 130.h,
              child:Text(user.about ?? "", maxLines: 5, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(19),),)),
            ),
          ),
          Center(
            child: Text("Favorite Lists", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(20),),))
          ),
          SizedBox(height: 15.h,),
          Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: user.lists == null? null: (){
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: "/favslists", arguments: ['R', user]),
                    screen: FavoriteLists(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  //Navigator.pushNamed(context, "/favslists", arguments: 'R');
                },
                child: Container(
                  height: 50.h,
                  width: 150.w,
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
                  child:Center(child: Text("Restaurants", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(19),),))),
                ),
              ),
              GestureDetector(
                onTap: user.lists == null? null: (){
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: "/favslists", arguments: ['E', user]),
                    screen: FavoriteLists(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  //Navigator.pushNamed(context, "/favslists", arguments: 'E');
                },
                child: Container(
                  height: 50.h,
                  width: 150.w,
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
                  child:Center(child: Text("Dishes", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(19),),))),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h,),
          GestureDetector(
            onTap:(){
              CommonData.pop[4] = true;
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: "/ratinghistory", arguments: user),
                screen: RatingHistory(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
              //Navigator.pushNamed(context, "/ratinghistory");
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  SvgPicture.asset("assets/ratings.svg", width: 37.w, height: 37.h,),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Rating history", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
