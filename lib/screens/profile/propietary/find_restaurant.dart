import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/requestDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/search.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'dart:math';

class FindRestaurant extends StatefulWidget {
  @override
  _FindRestaurantState createState() => _FindRestaurantState();
}

class _FindRestaurantState extends State<FindRestaurant> {
  bool isSearching = false;
  String error = "";
  String query = "";
  List<Restaurant> results;

  Future _search() async{
    results = await SearchService().query(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude, 100000, 0, [], query, "Sort by relevance");
  }

  @override
  Widget build(BuildContext context) {

    AppLocalizations tr = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CommonData.backgroundColor,
          elevation: 0,
          toolbarHeight: 80.h,
          leading: Container(),
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 15.h, right: 10.w, left: 10.w),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: 390.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                                query = val;
                                setState(() {
                                  error = "";
                                });
                              },
                              onTap: (){
                                if(isSearching){
                                  setState(() {
                                    isSearching = false;
                                  });
                                }
                              },
                              maxLines: 1,
                              maxLength: 20,
                              autofocus: false,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              decoration: InputDecoration(
                                  hintText: tr.translate("presssearch"),
                                  hintStyle: TextStyle(color: Colors.black45),
                                  counterText: "",
                                  border: InputBorder.none
                              ),
                            )
                          ),
                          IconButton(icon: Icon(Icons.search), iconSize: ScreenUtil().setSp(30), onPressed: ()async{
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            setState(() {
                              isSearching = true;
                            });
                            await _search();
                            setState(() {
                              isSearching = false;
                            });
                          },)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: results == null? Container() : isSearching? Loading() : ListView(
          children: results.map((restaurant) =>
              GestureDetector(
                onTap: (){
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(arguments: restaurant),
                    screen: ConfirmationMenu(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  child: Container(
                    width: 390.w,
                    height: 220.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(1, 1), // changes position of shadow
                      ),],
                    ),
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
                                Text("${Functions.getVotes(restaurant)} ${tr.translate("votes")}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 5.w,),
                            restaurant.types.length == 0 ? Container() : Container(
                                height: 15.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: Image.asset("assets/food/${CommonData.typesImage[restaurant.types[0]]}.png").image))
                            ),
                            SizedBox(width: 5.w,),
                            restaurant.types.length == 0? Container(width: 214.w) : Container(width: 214.w, child: Text(restaurant.types.length > 1 ? "${tr.translate(restaurant.types[0])}, ${tr.translate(restaurant.types[1])}" : "${tr.translate(restaurant.types[0])}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))),
                            SizedBox(width: 55.w,),
                            Container(
                              child: SvgPicture.asset("assets/markerMini.svg", height: 25.h, width: 25.w,),
                            ),
                            //Icon(Icons.location_on, color: Colors.black, size: ScreenUtil().setSp(16),),
                            Text("${restaurant.distance.toString()} km", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ).toList(),
        ),
      ),
    );
  }
}

class ConfirmationMenu extends StatefulWidget {
  @override
  _ConfirmationMenuState createState() => _ConfirmationMenuState();
}

class _ConfirmationMenuState extends State<ConfirmationMenu> {
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;

    AppLocalizations tr = AppLocalizations.of(context);
    return Scaffold(
      body: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h,),
          Text(tr.translate("selectmethod"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
          SizedBox(height: 80.h,),
          restaurant.email == null || restaurant.email == "" ? Container() : GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(arguments:[restaurant, "email"]),
                screen: ConfirmationCode(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.email, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text(tr.translate("confirmationemail"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                ],
              ),
            ),
          ),
          restaurant.email == null || restaurant.email == "" ? Container() : Container(width: 330.w, child: Text(restaurant.email, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
          restaurant.email == null || restaurant.email == "" ? Container() : SizedBox(height: 50.h,),
          restaurant.phone == null || restaurant.phone == "" ? Container() : GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(arguments: [restaurant, "sms"]),
                screen: ConfirmationCode(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.message_outlined, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text(tr.translate("confirmationsms"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                ],
              ),
            ),
          ),
          restaurant.phone == null || restaurant.phone == "" ? Container() : Container(width: 330.w, child: Text(restaurant.phone, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
          restaurant.phone == null || restaurant.phone == "" ? Container() : SizedBox(height: 50.h,),
          GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(arguments: restaurant),
                screen: IdRequest(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.warning_sharp, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text(tr.translate("noemailsms"), maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmationCode extends StatefulWidget {
  @override
  _ConfirmationCodeState createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  Restaurant restaurant;
  bool init = true;
  bool sent = false;
  int localcode;
  int code;
  String mode;
  String relation = "Dueño";
  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    List aux = ModalRoute.of(context).settings.arguments;
    restaurant = aux.first;
    mode = aux.last;
    if(init){
      localcode = Random().nextInt(99999);
      if(mode == "email")
        DBServiceRequest.dbServiceRequest.sendConfirmationCode(localcode, restaurant.email); //cambiar a email del restaurante
      else if(mode == "sms")
        DBServiceRequest.dbServiceRequest.sendConfirmationSms(localcode, restaurant.phone); //cambiar a email del restaurante
      init = false;
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: !sent ? Column( crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(tr.translate("introducecode"), maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
              SizedBox(height: 80.h,),
              Center(
                child: TextField(
                  onChanged: (val){
                    code = int.parse(val);
                  },
                  maxLines: 1,
                  maxLength: 6,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  decoration: textInputDeco.copyWith(hintText: tr.translate("codehere")),
                ),
              ),
              SizedBox(height: 10.h,),
              GestureDetector(
                onTap: (){
                  if(mode == "email") {
                    DBServiceRequest.dbServiceRequest.reSendConfirmationCode(
                        localcode, restaurant.email);
                    Alerts.toast(tr.translate("codeemail"));
                  }
                  else if(mode == "sms"){
                    DBServiceRequest.dbServiceRequest.reSendConfirmationSms(
                        localcode, restaurant.phone);
                    Alerts.toast(tr.translate("codesms"));
                  }
                },
                  child: Text(tr.translate("resend"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.redAccent, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(18),),))),
              SizedBox(height: 40.h,),
              Container(width: 200.w, child: Text(tr.translate("relation"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
              SizedBox(height: 10.h,),
              DropdownButton<String>(
                items: CommonData.typesRelation.map((type) => DropdownMenuItem<String>(
                    value: type,
                    child: Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(width: 140.w, child: Text(tr.translate(type), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
                      ],
                    )
                )).toList(),
                underline: Padding(
                  padding: EdgeInsets.all(5),
                ),
                value: relation,
                onChanged: (type) async{
                  setState(() {
                    relation = type;
                  });
                },
              ),
              SizedBox(height: 50.h,),
              GestureDetector(
                onTap: () async{
                  FocusScope.of(context).unfocus();
                  bool result = await DBServiceRequest.dbServiceRequest.confirmCodes(code, localcode);
                  if(!result){
                    Alerts.toast(tr.translate("wrongcode").toUpperCase());
                  }
                  else{
                    bool result = await DBServiceRequest.dbServiceRequest.createRequest(restaurant.restaurant_id, DBServiceUser.userF.uid, relation, mode, "", "");
                    if(result){
                      setState(() {
                        sent = true;
                      });
                    }
                    else
                      Alerts.dialog(tr.translate("alreadyreq"), context);
                  }
                },
                child: Container(
                    width: 170.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 110, 117, 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(child: Text(tr.translate("send"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18),),)))
                ),
              ),
            ],
          ) : Column(
            children: [
              SizedBox(height: 50.h,),
              Text(tr.translate("thanksreview"), maxLines: 5, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
            ],
          ),
        ),
      ),
    );
  }
}

class IdRequest extends StatefulWidget {
  @override
  _IdRequestState createState() => _IdRequestState();
}

class _IdRequestState extends State<IdRequest> {
  Restaurant restaurant;
  bool init = true;
  bool sent = false;
  String idfront, idback;
  String relation = "Dueño";
  final StorageService _storageService = StorageService();
  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;

    AppLocalizations tr = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: !sent ? Column( crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(tr.translate("idphoto"), maxLines: 3, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
              SizedBox(height: 50.h,),
              GestureDetector(
                onTap: () async{
                  idfront = await _storageService.uploadImage(context, "ids");
                  if(idfront  != null){
                    setState((){
                    });
                  }
                },
                child: Container(
                  width: 240.w,
                  height: 130.h,
                  decoration: idfront == null? null: BoxDecoration(
                    image: DecorationImage(
                      image: Image.network(idfront).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt, size: ScreenUtil().setSp(55), color: Color.fromRGBO(255, 110, 117, 0.7),),
                        Text(tr.translate("front"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.7), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                      ],
                    )
                  ),
                ),
              ),
              SizedBox(height: 50.h,),
              GestureDetector(
                onTap: () async{
                  idback = await _storageService.uploadImage(context, "ids");
                  if(idback != null){
                    setState((){
                    });
                  }
                },
                child: Container(
                  width: 240.w,
                  height: 130.h,
                  decoration: idback == null? null: BoxDecoration(
                    image: DecorationImage(
                      image: Image.network(idback).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt, size: ScreenUtil().setSp(55), color: Color.fromRGBO(255, 110, 117, 0.7),),
                          Text(tr.translate("back"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 0.7), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                        ],
                      )
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              Container(width: 200.w, child: Text(tr.translate("relation"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
              SizedBox(height: 10.h,),
              DropdownButton<String>(
                items: CommonData.typesRelation.map((type) => DropdownMenuItem<String>(
                    value: type,
                    child: Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(width: 140.w, child: Text(tr.translate(type), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
                      ],
                    )
                )).toList(),
                underline: Padding(
                  padding: EdgeInsets.all(5),
                ),
                value: relation,
                onChanged: (type) async{
                  setState(() {
                    relation = type;
                  });
                },
              ),
              SizedBox(height: 50.h,),
              GestureDetector(
                onTap: () async{
                  if(idfront == null || idback == null){
                    Alerts.dialog(tr.translate("plsid"), context);
                    return;
                  }
                  bool result = await DBServiceRequest.dbServiceRequest.createRequest(restaurant.restaurant_id, DBServiceUser.userF.uid, relation, 'id', idfront, idback);
                  if(result){
                    setState(() {
                      sent = true;
                    });
                  }
                  else
                    Alerts.dialog(tr.translate("alreadyreq"), context);
                },
                child: Container(
                    width: 170.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 110, 117, 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(child: Text(tr.translate("send"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18),),)))
                ),
              ),
            ],
          ) : Column(
            children: [
              SizedBox(height: 50.h,),
              Text(tr.translate("thanksreview"), maxLines: 5, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
            ],
          ),
        ),
      ),
    );
  }
}
