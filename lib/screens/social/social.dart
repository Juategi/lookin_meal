import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/profile/check_profile.dart';
import 'package:lookinmeal/screens/restaurants/entry.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  List<List> feed = [];
  String query = "";
  List<User> usersFeed, usersSearch;
  bool init = true;
  bool done = false;
  int offset = 0;

  Future _searchUsers() async{
    usersSearch = await DBServiceUser.dbServiceUser.searchUsers(query);
  }

  Future _loadUsers() async{
   usersFeed = await DBServiceUser.dbServiceUser.getUsersFeed();
  }

  Future _loadFeed() async{
    Iterable aux = await DBServiceRestaurant.dbServiceRestaurant.getFeed(DBServiceUser.userF.uid, offset);
    if(aux.length == 0){
      done = true;
      return;
    }
    feed.addAll(aux);
    offset += 10;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    //query = "";
    if(init){
      _loadFeed();
      _loadUsers();
      init = false;
    }
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(child:
      Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
         resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: feed == null? Loading() : Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: 390.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.all(Radius.circular(16))
                        ),
                        child: Padding(
                          padding:EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController()..text = query..selection = TextSelection.fromPosition(TextPosition(offset: query.length)),
                                  onChanged: (val){
                                      query = val.trim();
                                      if(query == "") {
                                        setState(() {});
                                      }
                                  },
                                  maxLines: 1,
                                  maxLength: 20,
                                  autofocus: false,
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: "Search an user..",
                                      hintStyle: TextStyle(color: Colors.black45),
                                      counterText: "",
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              IconButton(icon: Icon(Icons.search), iconSize: ScreenUtil().setSp(30), onPressed: ()async{
                                if(query != ""){
                                  await _searchUsers();
                                }
                                FocusScope.of(context).unfocus();
                                setState(() {
                                });
                              },)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h,),
                Text('Find out new people to follow near you', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.9), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(20),),)),
                SizedBox(height: 10.h,),
                Container(
                  height: 100.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: (query == "" ? usersFeed : usersSearch).map((user) =>
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            CommonData.pop[3] = true;
                            pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(
                                  name: "/checkprofile", arguments: user),
                              screen: CheckProfile(),
                              withNavBar: true,
                              pageTransitionAnimation: PageTransitionAnimation
                                  .slideUp,
                            );
                          },
                          child: Column(
                            children: [
                              Badge(
                                badgeContent: Icon(Icons.check_circle, color: Colors.blue,size: ScreenUtil().setSp(22),),
                                badgeColor: Colors.white,
                                elevation: 0,
                                showBadge: user.checked,
                                padding: EdgeInsets.all(4),
                                child: Container(height: 55.h, width: 55.w,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(1,
                                              1), // changes position of shadow
                                        ),
                                        ],
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                user.picture)
                                        )
                                    )
                                ),
                              ),
                              SizedBox(height: 10.h,),
                              Container(
                                width: 60.w,
                                child: Text(user.username, maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.niramit(
                                      textStyle: TextStyle(
                                        color: Color.fromRGBO(
                                            104, 97, 105, 0.9),
                                        letterSpacing: .3,
                                        fontWeight: FontWeight.w600,
                                        fontSize: ScreenUtil().setSp(
                                            13),),)),
                              )
                            ],
                          ),
                        ),
                    ).toList(),
                  ),
                ),
                Text('What are your friends eating? ', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.9), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(20),),)),
                SizedBox(height: 10.h,),
                Container(
                  height: 450.h,
                  child: ListView.builder(
                    itemCount: feed.length,
                    itemBuilder: (context, index) {
                      if (index == feed.length - 10 && feed.length != 150 && !done) {
                        _loadFeed();
                      }
                      if (index == feed.length) {
                        return Loading();
                      }
                      List sublist = feed[index];
                      User user = sublist.first;
                      MenuEntry entry = sublist[1];
                      Rating rating = sublist[2];
                      Restaurant restaurant = sublist.last;
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        child: Container(
                          width: 385.w,
                          height: 110.h,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  CommonData.pop[3] = true;
                                  pushNewScreenWithRouteSettings(
                                    context,
                                    settings: RouteSettings(
                                        name: "/checkprofile", arguments: user),
                                    screen: CheckProfile(),
                                    withNavBar: true,
                                    pageTransitionAnimation: PageTransitionAnimation
                                        .slideUp,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Badge(
                                      badgeContent: Icon(Icons.check_circle, color: Colors.blue,size: ScreenUtil().setSp(22),),
                                      badgeColor: Colors.white,
                                      elevation: 0,
                                      showBadge: user.checked,
                                      padding: EdgeInsets.all(4),
                                      child: Container(height: 55.h, width: 55.w,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 3,
                                                offset: Offset(1,
                                                    1), // changes position of shadow
                                              ),
                                              ],
                                              image: new DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: new NetworkImage(
                                                      user.picture)
                                              )
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 10.h,),
                                    Container(
                                      width: 60.w,
                                      child: Text(user.username, maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.niramit(
                                            textStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  104, 97, 105, 0.9),
                                              letterSpacing: .3,
                                              fontWeight: FontWeight.w600,
                                              fontSize: ScreenUtil().setSp(
                                                  13),),)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5.h,),
                                  Row(
                                    children: [
                                      StarRating(
                                        color: Color.fromRGBO(250, 201, 53, 1),
                                        rating: rating.rating,
                                        size: ScreenUtil().setSp(11),),
                                    ],
                                  ),
                                  Container(width: 75.w,
                                      child: Text(
                                          Functions.formatDate(rating.date),
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.niramit(
                                            textStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  104, 97, 105, 0.9),
                                              letterSpacing: .3,
                                              fontWeight: FontWeight.normal,
                                              fontSize: ScreenUtil().setSp(
                                                  11),),))),
                                  GestureDetector(
                                      onTap: () async {
                                        CommonData.pop[3] = true;
                                        await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext bc) {
                                              return Provider.value(value: false,
                                                  child: Provider<
                                                      Restaurant>.value(
                                                      value: restaurant,
                                                      child: Provider<
                                                          MenuEntry>.value(
                                                          value: entry,
                                                          child: EntryRating())));
                                            }).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Container(width: 75.w,
                                          child: Text(entry.name, maxLines: 3,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.niramit(
                                                textStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      104, 97, 105, 0.9),
                                                  letterSpacing: .3,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: ScreenUtil().setSp(
                                                      11),),)))),
                                  GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        CommonData.pop[3] = true;
                                        pushNewScreenWithRouteSettings(
                                          context,
                                          settings: RouteSettings(
                                              name: "/restaurant",
                                              arguments: restaurant),
                                          screen: ProfileRestaurant(),
                                          withNavBar: true,
                                          pageTransitionAnimation: PageTransitionAnimation
                                              .slideUp,
                                        );
                                      },
                                      child: Container(width: 75.w,
                                          child: Text(
                                              restaurant.name, maxLines: 2,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.niramit(
                                                textStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 110, 117, 0.9),
                                                  letterSpacing: .3,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: ScreenUtil().setSp(
                                                      11),),)))),
                                ],
                              ),
                              SizedBox(width: 6.w,),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 135.w,
                                    height: 100.h,
                                    child: Text(rating.comment, maxLines: 6,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.niramit(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                104, 97, 105, 0.9),
                                            letterSpacing: .3,
                                            fontWeight: FontWeight.normal,
                                            fontSize: ScreenUtil().setSp(12),),)),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5.w,),
                              Column(
                                children: [
                                  SizedBox(height: 4.h,),
                                  GestureDetector(
                                    onTap: () async {
                                      CommonData.pop[3] = true;
                                      await showModalBottomSheet(context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext bc) {
                                            return Provider.value(value: false,
                                                child: Provider<Restaurant>.value(
                                                    value: restaurant,
                                                    child: Provider<
                                                        MenuEntry>.value(
                                                        value: entry,
                                                        child: EntryRating())));
                                          }).then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                        width: 85.w,
                                        height: 85.h,
                                        decoration: new BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18)),
                                            image: entry.image == ""? null: new DecorationImage(
                                                fit: BoxFit.cover,
                                                image: new NetworkImage(
                                                    entry.image)
                                            )
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
