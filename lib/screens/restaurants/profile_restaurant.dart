import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/translate.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/daily.dart';
import 'package:lookinmeal/screens/restaurants/edit_images.dart';
import 'package:lookinmeal/screens/restaurants/info.dart';
import 'package:lookinmeal/screens/restaurants/menu.dart';
import 'package:lookinmeal/screens/restaurants/top_dishes_tile.dart';
import 'package:lookinmeal/services/currency_converter.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/services/translator.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';

class ProfileRestaurant extends StatefulWidget {
  @override
  _ProfileRestaurantState createState() => _ProfileRestaurantState();
}

class _ProfileRestaurantState extends State<ProfileRestaurant> {
	Restaurant restaurant;
	bool first = true;
	bool loading = false;
	String language;
	void _loadMenu()async{
		restaurant.menu = await DBService().getMenu(restaurant.restaurant_id);
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
		int three = 0;
		if(restaurant.menu.length > 0) {
			for(MenuEntry entry in restaurant.menu){
				if(entry.numReviews > 0){
					three++;
				}
			}
			if(three >= 6){
				for(MenuEntry entry in _getTop(6)){
					list.add(Provider<Restaurant>.value(
							value: restaurant, child: Provider<MenuEntry>.value(value: entry, child: TopDishesTile())));
				}
			}
			else{
				for(MenuEntry entry in _getTop(3)){
					if(entry != null)
						list.add(Provider<Restaurant>.value(
								value: restaurant, child: Provider<MenuEntry>.value(value: entry, child: TopDishesTile()))
						);
				}
			}
		}
		return list;
	}

	int _lines(){
		int three = 0;
		for(MenuEntry entry in restaurant.menu){
			if(entry.numReviews > 0){
				three++;
			}
		}
		return three;
	}

	List<MenuEntry> _getTop(int index){
		int max = 0;
		for(MenuEntry entry in restaurant.menu){
			if(entry.numReviews > max && entry.hide){
				max = entry.numReviews;
			}
		}
		restaurant.menu.sort((e1, e2) =>(e2.rating*0.5 + (e2.numReviews*5/max)*0.5 - (e1.hide ? 9999999 : 0)).compareTo((e1.rating*0.5 + (e1.numReviews*5/max)*0.5 - (e2.hide ? 9999999 : 0))));
		if(index == 3){
			return restaurant.menu.sublist(0,3);
		}
		else{
			return restaurant.menu.sublist(0,6);
		}
	}

	Future backToOriginal() async{
		for(MenuEntry entry in restaurant.menu){
			for(Translate tl in restaurant.original){
				if(tl.id == entry.id){
					entry.name = tl.name;
					entry.description = tl.description;
					break;
				}
			}
		}
		setState(() {
			language = "Original";
		});
	}

	bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
		if (info.ifRouteChanged(context)) return false;
		if(language != "Original"){
			backToOriginal();
		}
		return false;
	}

	@override
  void initState() {
    language = "Original";
		BackButtonInterceptor.add(myInterceptor, context: context);
    super.initState();
  }

	@override
  void dispose() {
		for(MenuEntry entry in restaurant.menu){
			entry.removeListener(() { });
		}
		BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  List<DropdownMenuItem> _loadItems(){
		List<DropdownMenuItem> items = DBService.userF.lists.where((FavoriteList list) => list.type == 'R').map((list) =>
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
								Icon(list.items.contains(restaurant.restaurant_id) ? Icons.favorite_outlined : Icons.favorite_outline, size: ScreenUtil().setSp(40),color: Color.fromRGBO(255, 65, 112, 1)),
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
  	restaurant = ModalRoute.of(context).settings.arguments;
		_timer();
		if(first){
			if(restaurant.original == null){
				restaurant.original = [];
			}
			for(MenuEntry entry in restaurant.menu){
				entry.addListener(() { setState(() {
				});});
				if(restaurant.original.length != restaurant.menu.length){
					Translate original = Translate(id: entry.id, name: entry.name, description: entry.description);
					restaurant.original.add(original);
				}
			}
			first = false;
		}
  	//if(restaurant.menu == null)
  		//_loadMenu();
		User user = DBService.userF;
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
			//backgroundColor: CommonData.backgroundColor,
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
									/*IconButton(
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

									),*/
									DropdownButton<FavoriteList>(
											icon: Icon(user.lists.firstWhere((list) => list.type == 'R' && list.items.contains(restaurant.restaurant_id), orElse: () => null) != null ? Icons.favorite_outlined : Icons.favorite_outline, size: ScreenUtil().setSp(45),color: Color.fromRGBO(255, 65, 112, 1)),
											items: _loadItems(),
											onChanged: (list)async{
												if(list.id == null){
													await Navigator.pushNamed(context, "/createlist", arguments: 'R');
												}
												else{
													if(!list.items.contains(restaurant.restaurant_id)){
														if(list.items.length < CommonData.maxElementsList) {
															list.items.add(restaurant.restaurant_id);
															Alerts.toast("${restaurant.name} added to ${list.name}");
														}
														else{
															Alerts.toast("${list.name} full");
														}
													}
													else{
														list.items.remove(restaurant.restaurant_id);
														Alerts.toast("${restaurant.name} removed from ${list.name}");
													}
													await DBService.dbService.updateList(list);
												}
												setState(() {
												});
											},
										),
										SizedBox(width: 20.w,),
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
											backToOriginal();
											Navigator.pushNamed(context, "/admin", arguments: restaurant);
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
										Row(
										  children: [
												restaurant.types.length == 0 ? Container() : Container(
														height: 25.h,
														width: 25.w,
														decoration: BoxDecoration(
																image: DecorationImage(
																		image: Image.asset("assets/food/${CommonData.typesImage[restaurant.types[0]]}.png").image))
												),
										    SizedBox(width: 5.w,),
										    Container(width: 180.w, child: Text(restaurant.types.length > 1 ? "${restaurant.types[0]}, ${restaurant.types[1]}" : restaurant.types.length > 0 ? "${restaurant.types[0]}" : "", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
										  ],
										),
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
										StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: Functions.getRating(restaurant), size: ScreenUtil().setSp(15),),
										Text("${Functions.getVotes(restaurant)} votes", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
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
					restaurant.menu.length != 0 ? Container(
						height: 42.h,
						width: 411.w,
						decoration: BoxDecoration(
							color: Color.fromRGBO(255, 110, 117, 0.9),
						),
						child:Text("Top dishes", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
					) : //Container(height: 780.h, child: RestaurantInfo()),
					Column(
						children: [
							SizedBox(height: 40.h,),
							Container(width: 300.w, height: 190.h, child: Text("¡Parece que no hay menu, haz una foto a la carta y nosotros nos encargaremos de subirla!", maxLines: 5, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(28),),))),
							SizedBox(height: 30.h,),
							GestureDetector(
								onTap: ()async{
									//await StorageService().uploadNanonets(context, restaurant.restaurant_id);
								},
							  child: Container(
							  	height: 80.h,
							  	width: 80.w,
							  	/*decoration: BoxDecoration(
							  		borderRadius: BorderRadius.all(Radius.circular(40)),
							  		border: Border.all(width: 5, color: Color.fromRGBO(255, 110, 117, 0.9), style: BorderStyle.solid),
							  	),*/
							  	child: Container(
							  			height: 40.h,
							  			width: 40.w,
							  			child: SvgPicture.asset("assets/menu.svg", color: Color.fromRGBO(255, 110, 117, 0.9), fit: BoxFit.contain,)
							  	),
							  ),
							)
						],
					),
					restaurant.menu.length != 0 ? Padding(
					  padding: EdgeInsets.all(8.0),
					  child: Container(
					  	height: _lines() >= 6 ? 260.h : 130.h,
					  	child: _lines() >= 6?  Column(
								children: <Widget>[
									Row(
										children: _loadTop().sublist(0,3),
									),
									SizedBox(height: 5.h,),
									Row(
										children: _loadTop().sublist(3,6),
									)
								],
							) :
							Row(
								children: _loadTop(),
							),
					  ),
					) : Container(),
					restaurant.menu.length != 0 ? Container(
						height: 42.h,
						width: 411.w,
						decoration: BoxDecoration(
							color: Color.fromRGBO(255, 110, 117, 0.9),
						),
						child: Row(
							children: <Widget>[
								SizedBox(width: 10.w,),
								Icon(Icons.translate, color: Colors.white, size: ScreenUtil().setSp(19),),
								SizedBox(width: 8.w,),
								DropdownButton(
									value: language,
									elevation: 1,
									dropdownColor: Color.fromRGBO(255, 110, 117, 0.9),
									items: [
										DropdownMenuItem(
											child: Row(
												children: <Widget>[
													Text("Original", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),))
												],
											),
											value: "Original",
										),
										DropdownMenuItem(
											child: Row(
												children: <Widget>[
													Text("English", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),))
												],
											),
											value: "English",
										),
										DropdownMenuItem(
											child: Row(
												children: <Widget>[
													Text("Spanish", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),))
												],
											),
											value: "Spanish",
										),
										DropdownMenuItem(
											child: Row(
												children: <Widget>[
													Text("French", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),))
												],
											),
											value: "French",
										),
										DropdownMenuItem(
											child: Row(
												children: <Widget>[
													Text("German", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),))
												],
											),
											value: "German",
										),
										DropdownMenuItem(
											child: Row(
												children: <Widget>[
													Text("Italian", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),))
												],
											),
											value: "Italian",
										),
									],
									onChanged: (selected) async{
										setState(() {
											language = selected;
											loading = true;
										});
										await Translator.doTranslation(selected, restaurant);
										setState(() {
											loading = false;
										});
									},
								),
								SizedBox(width: 10.w,),
								loading? Container(height: 20.h, width: 20.w, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2,)) : Container(width: 20.w, height: 20.h,),
								Expanded(child: Align( alignment: AlignmentDirectional.topCenter, child: Text("Menu", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)))),
								SizedBox(width: 130.w,),

							],
						),
					) : Container(),
					restaurant.menu.length != 0 ? Menu(restaurant: restaurant) : Container(),
					restaurant.dailymenu != null? Container(
						height: 42.h,
						width: 411.w,
						decoration: BoxDecoration(
							color: Color.fromRGBO(255, 110, 117, 0.9),
						),
						child: Row(
							children: <Widget>[
								Expanded(child: Align( alignment: AlignmentDirectional.topCenter, child: Text("Daily Menu", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)))),
								//Spacer(),

							],
						),
					): Container(),
					restaurant.dailymenu != null ? DailyMenu(restaurant: restaurant, currency: restaurant.currency) : Container(),
      	],
      ),
    );
  }



}
