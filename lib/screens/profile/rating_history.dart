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
  }

  @override
  void initState() {
    super.initState();
    _update(0,50);
    _timer();
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
            children: DBService.userF.history.keys.map((r) =>
                Provider.value(value: DBService.userF.history[r], child: Provider.value(value: DBService.userF.ratings.firstWhere((rating) => rating.entry_id == r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    child: RatingTile(),
                  ),
                ))
            ).toList(),
          ))
        ],
      ),
    );
  }
}
