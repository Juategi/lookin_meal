import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/screens/profile/ratings_tile.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:provider/provider.dart';

class RatingHistory extends StatefulWidget {
  @override
  _RatingHistoryState createState() => _RatingHistoryState();
}

class _RatingHistoryState extends State<RatingHistory> {
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
          Expanded(child: ListView(
            children: DBService.userF.ratings.map((r) =>
                Provider.value(value: DBService.userF.recently.first, child: Provider.value(value: r,
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
