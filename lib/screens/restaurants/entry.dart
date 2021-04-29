import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/database/statisticDB.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/order.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/profile/favorites.dart';
import 'package:lookinmeal/screens/restaurants/comments.dart';
import 'package:lookinmeal/screens/restaurants/orders/order_screen.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/realtime_orders.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class EntryRating extends StatefulWidget {
  @override
  _EntryRatingState createState() => _EntryRatingState();
}

class _EntryRatingState extends State<EntryRating> {
  MenuEntry entry;
  Restaurant restaurant;
  double rate, oldRate;
  bool hasRate;
  bool indicator = false;
  bool init = true;
  bool order;
  num amount = 1;
  Rating actual;
  String comment = "";
  String note = "";
  final formatter = new DateFormat('yyyy-MM-dd');

  List<DropdownMenuItem> _loadItems(){
    List<DropdownMenuItem> items = DBServiceUser.userF.lists.where((FavoriteList list) => list.type == 'E').map((list) =>
        DropdownMenuItem<FavoriteList>(
            value: list,
            child: Row( mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(list.image).image
                      )
                  ),
                ),
                SizedBox(width: 13.w,),
                Container(width: 120.w, child: Text(list.name, maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18),),))),
                Icon(list.items.contains(entry.id) ? Icons.favorite_outlined : Icons.favorite_outline, size: ScreenUtil().setSp(40),color: Color.fromRGBO(255, 65, 112, 1)),
              ],
            )
        )).toList();
    items.add(DropdownMenuItem<FavoriteList>(
        value: FavoriteList(),
        child: Row( mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              child: Icon(Icons.add, size: ScreenUtil().setSp(45),color: Colors.black),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              ),
            ),
          ],
        )
    ));
    return items;
  }


  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    try {
      restaurant = Provider.of<Restaurant>(context);
    }catch(e){
    }
    order = Provider.of<bool>(context);
    entry = Provider.of<MenuEntry>(context);
    if(init){
      rate = 0.0;
      hasRate = false;
      for(Rating r in DBServiceUser.userF.ratings){
        if(r.entry_id == entry.id){
          rate = r.rating;
          oldRate = rate;
          comment = r.comment;
          hasRate = true;
          actual = r;
        }
      }
      init = false;
    }
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //resizeToAvoidBottomPadding: true,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40.h,),
              Container(
                  height: entry.image == null || entry.image == "" ? 130.h : order ? 260.h  :  342.h,
                  width: entry.image == null || entry.image == "" ? 130.w : order ? 260.w : 342.w,
                  decoration: entry.image == null || entry.image == "" ? null : BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1),
                    image: entry.image == null || entry.image == ""? null : DecorationImage(
                      image: Image.network(
                          entry.image).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column( mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      restaurant != null ? Row( mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          order ? Container() : GestureDetector(
                            onTap:(){
                              DBServiceRestaurant.dbServiceRestaurant.updateRecently(restaurant);
                              pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: "/restaurant", arguments: restaurant),
                                screen: ProfileRestaurant(),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.slideUp,
                              ).then((value) => setState(() {}));
                              //Navigator.pushNamed(context, "/restaurant",arguments: restaurant).then((value) => setState(() {}));
                            },
                            child: Container(
                                height: 45.h,
                                width: 45.w,
                                child: SvgPicture.asset("assets/menu.svg", color: Color.fromRGBO(255, 110, 117, 0.9), fit: BoxFit.contain,)
                            ),
                          ),
                          SizedBox(width: 50.w,),
                          order ? Container() : DropdownButton<FavoriteList>(
                            icon: Icon(DBServiceUser.userF.lists.firstWhere((list) => list.type == 'E' && list.items.contains(entry.id), orElse: () => null) != null ? Icons.favorite_outlined : Icons.favorite_outline, size: ScreenUtil().setSp(45),color: Color.fromRGBO(255, 65, 112, 1)),
                            items: _loadItems(),
                            underline: Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            onChanged: (list)async{
                              if(list.id == null){
                                await pushNewScreenWithRouteSettings(
                                  context,
                                  settings: RouteSettings(name: "/createlist", arguments: 'E'),
                                  screen: CreateList(),
                                  withNavBar: true,
                                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                                );
                                //await Navigator.pushNamed(context, "/createlist", arguments: 'E');
                              }
                              else{
                                if(!list.items.contains(entry.id)){
                                  if(list.items.length < CommonData.maxElementsList) {
                                    list.items.add(entry.id);
                                    Alerts.toast("${entry.name} ${tr.translate("addedto")} ${list.name}");
                                  }
                                  else{
                                    Alerts.toast("${list.name} ${tr.translate("full")}");
                                  }
                                }
                                else{
                                  list.items.remove(entry.id);
                                  Alerts.toast("${entry.name} ${tr.translate("removedfrom")} ${list.name}");
                                }
                                await DBServiceUser.dbServiceUser.updateList(list);
                              }
                              setState(() {
                              });
                            },
                          ),
                        ],
                      ) : Container(),
                      SizedBox(height: entry.image == null || entry.image == "" ? 30.h : 235.h,),
                      Row(
                        children: [
                          entry.price == 0.0 ? Container():Row( mainAxisAlignment: entry.image == null || entry.image == ""?  MainAxisAlignment.center : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                                child: Container(
                                  width: 100.w,
                                  height: 33.h,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 110, 117, 0.9),
                                      borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  child: Align( alignment: Alignment.center, child: Text("${entry.price} ${restaurant.currency}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(22),),))),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 190.w,),
                          entry.allergens.length == 0 ? Container() : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: GestureDetector(
                              child: Container(
                                  height: 45.h,
                                  width: 45.w,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: Image.asset("assets/allergens/cacahuetes.png").image))
                              ),
                              onTap: (){
                                showModalBottomSheet(context: context, isScrollControlled: true,  builder: (BuildContext bc){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                                    child: Column(
                                      children: <Widget>[
                                        Text(tr.translate("allergens"), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: ScreenUtil().setSp(22),),),
                                        SizedBox(height: 10.h,),
                                        Center(
                                          child: Container(
                                            height: 450.h,
                                            //width: 300.w,
                                            child: Wrap(
                                              direction: Axis.vertical,
                                              children: CommonData.allergens.map((allergen) => Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                    child: Container(
                                                        height: 40.h,
                                                        width: 40.w,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                colorFilter: entry.allergens.contains(allergen)? ColorFilter.srgbToLinearGamma() : ColorFilter.linearToSrgbGamma(),
                                                                image: Image.asset("assets/allergens/$allergen.png").image))
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w,),
                                                  Text("${allergen[0].toUpperCase()}${allergen.substring(1)}", style: TextStyle(fontWeight: entry.allergens.contains(allergen)? FontWeight.bold :FontWeight.normal, color: entry.allergens.contains(allergen)? Colors.black :  Colors.grey[500], fontSize: ScreenUtil().setSp(13),),),
                                                ],
                                              )).toList(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
              ),
              SizedBox(height: 10.h,),
              Container(width: 360.w,child: Text("${entry.name}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.7), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),))),
              SizedBox(height: 10.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(height: entry.description == "" ? 0 : 100.h,child: Text("${entry.description}", maxLines: 4, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
              ),
              SizedBox(height: 10.h,),
              !order ? Container()  :
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tr.translate("amount"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.9), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
                      SizedBox(width: 20.w,),
                      DropdownButton(items: List<int>.generate(30, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child:
                      Text(n.toString(), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(22),),)),
                      )).toList(), onChanged: (s){
                        setState(() {
                          amount = s;
                        });
                      }, value: amount,),
                    ],
                  ),
              SizedBox(height: !order ? 0 :  10.h,),
              !order ? Container() : Text(tr.translate("addnote"), maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.9), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(15),),)),
              Container(
                //color: Color.fromRGBO(255, 110, 117, 0.1),
                height: 120.h,
                width: 342.w,
                child: TextField(
                  keyboardType: TextInputType.text,
                  maxLength: 250,
                  maxLines: 8,
                  decoration: textInputDeco,
                  controller: order ? (TextEditingController()..text = note..selection = TextSelection.fromPosition(TextPosition(offset: note.length)))  :  (TextEditingController()..text = comment..selection = TextSelection.fromPosition(TextPosition(offset: comment.length))) ,
                  onChanged: (v) {
                    if(order)
                      note = v;
                    else
                      comment = v;
                },),
              ),
              //SizedBox(height: 5.h,),
              Center(
                child: order ? GestureDetector(
                  onTap: (){
                    RealTimeOrders().createOrderData(restaurant.restaurant_id, Order(
                      send: false,
                      check: false,
                      entry_id: entry.id,
                      amount: amount,
                      note: note,
                    ));
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 110, 117, 0.9),
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    child: Center(child: Text(tr.translate("add"), maxLines: 1,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white,
                          letterSpacing: .3,
                          fontWeight: FontWeight.normal,
                          fontSize: ScreenUtil().setSp(22),),))),
                  ),
                ) : SmoothStarRating(
                  allowHalfRating: true,
                  rating: rate,
                  color: Color.fromRGBO(250, 201, 53, 1),
                  borderColor: Color.fromRGBO(250, 201, 53, 1),
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  size: ScreenUtil().setSp(45),
                  onRated: (v) async{
                    rate = v;
                    indicator = true;
                    setState(() {});
                    if(hasRate){
                      actual.rating = rate;
                      actual.date = formatter.format(DateTime.now());
                      actual.comment = comment;
                      await DBServiceEntry.dbServiceEntry.deleteRate(DBServiceUser.userF.uid, entry.id);
                      DBServiceEntry.dbServiceEntry.addRate(DBServiceUser.userF.uid, entry.id, rate, comment);
                      double aux = (entry.rating*entry.numReviews + rate - oldRate)/(entry.numReviews);
                      //entry.rating = double.parse(aux.toStringAsFixed(2));
                      entry.rate = double.parse(aux.toStringAsFixed(2));
                      print("______________");
                      print(entry.rating);
                      Alerts.toast(tr.translate("ratingsaved"));
                      Navigator.pop(context);
                    }
                    else{
                      DBServiceUser.userF.ratings.add(Rating(
                          entry_id: entry.id,
                          rating: rate,
                          date: formatter.format(DateTime.now()),
                          comment: comment
                      ));
                      DBServiceUser.userF.history[entry.id] = restaurant;
                      DBServiceEntry.dbServiceEntry.addRate(DBServiceUser.userF.uid, entry.id, rate, comment);
                      double aux = (entry.rating*entry.numReviews + rate)/(entry.numReviews+1);
                      //entry.rating = double.parse(aux.toStringAsFixed(2));
                      //entry.numReviews += 1;
                      entry.rate = double.parse(aux.toStringAsFixed(2));
                      entry.reviews = entry.numReviews + 1;
                      Alerts.toast(tr.translate("ratingsaved"));
                      Navigator.pop(context);
                    }
                    DBServiceStatistic.dbServiceStatistic.addRate(restaurant.restaurant_id, entry.id, comment != "");
                  },
                ),
              ),
              SizedBox(height: 5.h,),
              GestureDetector(
                onTap: (){
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: "/comments", arguments: entry),
                    screen: Comments(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                  );
                  //Navigator.pushNamed(context, "/comments", arguments: entry);
                },
                child: Container(
                  child: Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tr.translate("viewcomments"), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45, fontSize: ScreenUtil().setSp(22),),),
                      SizedBox(width: 7.w,),
                      Icon(Icons.comment, size: ScreenUtil().setSp(32),color: Colors.black45),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h,),
            ],
          ),
        ),
      ),
    );
  }
}
