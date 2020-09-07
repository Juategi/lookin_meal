import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/screens/restaurants/entry.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MenuTile extends StatefulWidget {
  @override
  _MenuTileState createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  MenuEntry entry;
  @override
  Widget build(BuildContext context) {
    entry = Provider.of<MenuEntry>(context);
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Card(
          elevation: 0.5,
          child: Container(
            width: 365.w,
            height: 75.h,
            //color: Colors.white,
            child: Row(
              children: <Widget>[
                Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(entry.name, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                    ),
                    SizedBox(height: 15.h,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.w,),
                        //SmoothStarRating(rating: entry.rating, spacing: -3, isReadOnly: true, allowHalfRating: true, color: Color.fromRGBO(250, 201, 53, 1), borderColor: Color.fromRGBO(250, 201, 53, 1), size: ScreenUtil().setSp(21),),
                        StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: entry.rating, size: ScreenUtil().setSp(15),),
                        SizedBox(width: 10.w,),
                        Text("${entry.numReviews} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                        SizedBox(width: 34.w,),
                        Container(
                          width: 70.w,
                          height: 25.h,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 110, 117, 0.9),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: Text("${entry.price}", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(width: 10.w,),
                entry.image == null || entry.image == ""? Container() : Container(
                    height: 75.h,
                    width: 75.w,
                    decoration: entry.image == null || entry.image == "" ? null: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1)
                    ),
                    child: Image.network(entry.image, fit: BoxFit.cover, )
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
          return EntryRating(entry, DBService.userF);
        }).then((value){setState(() {});});
      },
    );
  }
}
