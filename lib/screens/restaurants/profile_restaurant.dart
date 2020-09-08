import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/daily.dart';
import 'package:lookinmeal/screens/restaurants/edit_images.dart';
import 'package:lookinmeal/screens/restaurants/menu.dart';
import 'package:lookinmeal/screens/restaurants/top_dishes_tile.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProfileRestaurant extends StatefulWidget {
  @override
  _ProfileRestaurantState createState() => _ProfileRestaurantState();
}

class _ProfileRestaurantState extends State<ProfileRestaurant> {
	Restaurant restaurant;

	void _loadMenu()async{
		restaurant.menu = await DBService().getMenu(restaurant.restaurant_id);
		for(MenuEntry entry in restaurant.menu){
			entry.addListener(() { setState(() {
			});});
		}
	}

	void _timer() {
		if(restaurant.menu == null) {
			Future.delayed(Duration(seconds: 2)).then((_) {
				setState(() {
					print("Loading menu...");
				});
				_timer();
			});
		}
	}

	List<Widget> _loadTop(){
		List<Widget> list = [];
		for(int i = 0; i < 3; i++){
			list.add(Provider<MenuEntry>.value(value: restaurant.menu[i], child: TopDishesTile()));
			list.add(Provider<MenuEntry>.value(value: restaurant.menu[i], child: TopDishesTile()));
		}
		return list;
	}

  @override
  Widget build(BuildContext context) {
  	restaurant = ModalRoute.of(context).settings.arguments;
		_timer();
  	if(restaurant.menu == null)
  		_loadMenu();
		User user = DBService.userF;
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: ListView(
      	children: <Widget>[
      		GestureDetector(
      		  child: Container(
							height: 230,
							width: 400,
							decoration: BoxDecoration(
								image: DecorationImage(
									image: NetworkImage(restaurant.images.elementAt(0)),
									fit: BoxFit.cover,
								),
							),
							child: Row( mainAxisAlignment: MainAxisAlignment.end,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									IconButton(
										icon: Icon(Icons.mode_edit),
										iconSize: ScreenUtil().setSp(40),
										color: Color.fromRGBO(255, 65, 112, 1),
										onPressed: ()async{
											showModalBottomSheet(context: context, builder: (BuildContext bc){
												return EditImages(restaurant: restaurant,);
											}).then((value){setState(() {});});
										},
									),
									IconButton(
										icon: user.favorites.contains(restaurant) ? Icon(Icons.favorite) :Icon(Icons.favorite_border),
										iconSize: ScreenUtil().setSp(45),
										color: Color.fromRGBO(255, 65, 112, 1),
										onPressed: ()async{
											if(user.favorites.contains(restaurant)) {
												user.favorites.remove(restaurant);
												DBService.dbService.deleteFromUserFavorites(user.uid, restaurant);
											}
											else {
												user.favorites.add(restaurant);
												DBService.dbService.addToUserFavorites(user.uid, restaurant);
											}
											setState(() {});
										},

									),
								],
							),
						),
						onTap: () => Navigator.pushNamed(context, "/gallery", arguments: restaurant),
      		),
					Container(
						height: 42.h,
						width: 411.w,
						decoration: BoxDecoration(
							color: Color.fromRGBO(255, 110, 117, 0.9),
						),
						child: Row(
							children: <Widget>[
								Expanded(child: Align( alignment: AlignmentDirectional.topCenter, child: Text(restaurant.name, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)))),
								//Spacer(),
								Align(
									alignment: AlignmentDirectional.topCenter,
									child: GestureDetector(
										child: Container(
											child: SvgPicture.asset("assets/admin.svg"),
											height: 35.h,
											width: 35.w,
										),
										onTap: ()async{
											Navigator.pushNamed(context, "/editrestaurant",arguments: restaurant).then((value) => setState(() {}));
										},
									),
								),
							],
						),
					),
					Padding(
						padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
						child: Row(
							children: <Widget>[
								Column(crossAxisAlignment: CrossAxisAlignment.start,
									children: <Widget>[
										Container(width: 210.w, child: Text(restaurant.types.length > 1 ? "${restaurant.types[0]}, ${restaurant.types[1]}" : "${restaurant.types[0]}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
										Row(
											children: <Widget>[
												Container(
													child: SvgPicture.asset("assets/markerMini.svg"),
													height: 42.h,
													width: 32.w,
												),
												//Icon(Icons.location_on, color: Colors.black, size: ScreenUtil().setSp(16),),
												Text("${restaurant.distance.toString()} km", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))
											],
										)
									],
								),
								Column( crossAxisAlignment:  CrossAxisAlignment.end,
									children: <Widget>[
										StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: restaurant.rating, size: ScreenUtil().setSp(15),),
										Text("${restaurant.numrevta} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
										SizedBox(height: 10.h,),
										GestureDetector(
										  child: Container(
										  	height: 27.h,
										  	width: 161.w,
										  	decoration: BoxDecoration(
										  			borderRadius: BorderRadius.all(Radius.circular(10)),
										  			color: Color.fromRGBO(0, 0, 0, 0.1)
										  	),
										  	child: Row(
										  		children: <Widget>[
										  			SizedBox(width: 15.w,),
										  			Text('Restaurant info ', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(16),),)),
										  			Icon(Icons.info_outline, size: ScreenUtil().setSp(18),)
										  		],
										  	),
										  ),
											onTap: () => Navigator.pushNamed(context, "/info", arguments: restaurant),
										),
									],
								)
							],
						),
					),
					Container(
						height: 42.h,
						width: 411.w,
						decoration: BoxDecoration(
							color: Color.fromRGBO(255, 110, 117, 0.9),
						),
						child:Text("Top dishes", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
					),
					Padding(
					  padding: EdgeInsets.all(8.0),
					  child: Container(
					  	height: 260.h,
					  	child: IgnorePointer(child: GridView.count(crossAxisCount: 3, children: _loadTop(),))
					  ),
					),
					Container(
						height: 42.h,
						width: 411.w,
						decoration: BoxDecoration(
							color: Color.fromRGBO(255, 110, 117, 0.9),
						),
						child: Row(
							children: <Widget>[
								Expanded(child: Align( alignment: AlignmentDirectional.topCenter, child: Text("Menu", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)))),
								//Spacer(),
								Align(
									alignment: AlignmentDirectional.topCenter,
									child: GestureDetector(
										child: Container(
											child: SvgPicture.asset("assets/admin.svg"),
											height: 35.h,
											width: 35.w,
										),
										onTap: ()async{
											Navigator.pushNamed(context, "/editmenu",arguments: restaurant).then((value) => setState(() {}));
										},
									),
								),
							],
						),
					),
					restaurant.menu == null? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),) : Menu(restaurant: restaurant, currency: restaurant.currency),
					Container(
						height: 42.h,
						width: 411.w,
						decoration: BoxDecoration(
							color: Color.fromRGBO(255, 110, 117, 0.9),
						),
						child: Row(
							children: <Widget>[
								Expanded(child: Align( alignment: AlignmentDirectional.topCenter, child: Text("Daily Menu", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)))),
								//Spacer(),
								Align(
									alignment: AlignmentDirectional.topCenter,
									child: GestureDetector(
										child: Container(
											child: SvgPicture.asset("assets/admin.svg"),
											height: 35.h,
											width: 35.w,
										),
										onTap: ()async{
											Navigator.pushNamed(context, "/editdaily",arguments: restaurant).then((value) => setState(() {}));
										},
									),
								),
							],
						),
					),
					restaurant.menu == null? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),) : DailyMenu(restaurant: restaurant, currency: restaurant.currency),
      	],
      ),
    );
  }
}
