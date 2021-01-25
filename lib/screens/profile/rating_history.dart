import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/entryDB.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/profile/ratings_tile.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';

class RatingHistory extends StatefulWidget {
  @override
  _RatingHistoryState createState() => _RatingHistoryState();
}

class _RatingHistoryState extends State<RatingHistory> {
  bool loading = false;
  int offset = 0;
  int limit = 15; 
  void _timer() {
    if(DBServiceUser.userF.history == null) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        setState(() {
          print("Loading..");
        });
        _timer();
      });
    }
  }

  void _update(int offset, int limit)async{
    if(DBServiceUser.userF.history == null){
      DBServiceUser.userF.history = await DBServiceEntry.dbServiceEntry.getRatingsHistory(DBServiceUser.userF.uid, DBServiceUser.userF.ratings.map((r) => r.entry_id).toList(), offset, limit);
    }
    else{
      DBServiceUser.userF.history.addAll(await DBServiceEntry.dbServiceEntry.getRatingsHistory(DBServiceUser.userF.uid, DBServiceUser.userF.ratings.map((r) => r.entry_id).toList(), offset, limit));
    }
  }

  @override
  void initState() {
    super.initState();
    _update(offset, limit);
    _timer();
  }

  List<Widget> getListItems(){
   List<Widget> items = [];
   List<String> aux = DBServiceUser.userF.history.keys.toList();
   aux.sort((a,b) => Functions.compareDates(DBServiceUser.userF.ratings.firstWhere((r) => r.entry_id == b).date, DBServiceUser.userF.ratings.firstWhere((r) => r.entry_id == a).date));
   items.addAll(aux.map((r) =>
       Provider.value(value: DBServiceUser.userF.history[r], child: Provider.value(value: DBServiceUser.userF.ratings.firstWhere((rating) => rating.entry_id == r),
         child: Padding(
           padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
           child: RatingTile(),
         ),
       ))).toList());
   items.add(SizedBox(height: 30.h,));
   items.add(loading? Loading() : DBServiceUser.userF.ratings.length == DBServiceUser.userF.history.keys.length ? Container() : Padding(
     padding: EdgeInsets.symmetric(horizontal: 12.w),
     child: GestureDetector(
       onTap: () async{
         setState(() {
           loading = true;
         });
         offset += 15;
         await _update(offset, limit);
         setState(() {
           loading = false;
         });
       },
       child: Container(
         height: 50.h,
         width: 50.w,
         color: Color.fromRGBO(255, 110, 117, 0.9),
         child: Center(child: Text("Show more", maxLines: 1,
             textAlign: TextAlign.center,
             style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white,
               letterSpacing: .3,
               fontWeight: FontWeight.normal,
               fontSize: ScreenUtil().setSp(22),),))),
       ),
     ),
   ));
   return items;
  }

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
            child:Text("Rating History", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
          ),
          SizedBox(height: 10.h,),
          DBServiceUser.userF.history == null? Loading() : Expanded(child: ListView(
            children: getListItems(),
          ))
        ],
      ),
    );
  }
}
