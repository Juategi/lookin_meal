import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/screens/profile/ratings_tile.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';
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
    if(DBService.userF.history == null) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        setState(() {
          print("Loading..");
        });
        _timer();
      });
    }
  }

  void _update(int offset, int limit)async{
    if(DBService.userF.history == null){
      DBService.userF.history = await DBService.dbService.getRatingsHistory(DBService.userF.uid, DBService.userF.ratings.map((r) => r.entry_id).toList(), offset, limit);
    }
    else{
      DBService.userF.history.addAll(await DBService.dbService.getRatingsHistory(DBService.userF.uid, DBService.userF.ratings.map((r) => r.entry_id).toList(), offset, limit));
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
   items.addAll(DBService.userF.history.keys.map((r) =>
       Provider.value(value: DBService.userF.history[r], child: Provider.value(value: DBService.userF.ratings.firstWhere((rating) => rating.entry_id == r),
         child: Padding(
           padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
           child: RatingTile(),
         ),
       ))).toList());
   items.add(SizedBox(height: 30.h,));
   items.add(loading? Loading() : DBService.userF.ratings.length == DBService.userF.history.keys.length ? Container() : Padding(
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
          DBService.userF.history == null? Loading() : Expanded(child: ListView(
            children: getListItems(),
          ))
        ],
      ),
    );
  }
}
