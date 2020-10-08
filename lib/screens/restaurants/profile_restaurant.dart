import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/translate.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/daily.dart';
import 'package:lookinmeal/screens/restaurants/edit_images.dart';
import 'package:lookinmeal/screens/restaurants/menu.dart';
import 'package:lookinmeal/screens/restaurants/top_dishes_tile.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/translator.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
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
	bool first = true;
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
					list.add(Provider<MenuEntry>.value(value: entry, child: TopDishesTile()));
				}
			}
			else{
				for(MenuEntry entry in _getTop(3)){
					if(entry != null)
						list.add(Provider<MenuEntry>.value(value: entry, child: TopDishesTile())
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
			if(entry.numReviews > max){
				max = entry.numReviews;
			}
		}
		restaurant.menu.sort((e1, e2) =>(e2.rating*0.5 + (e2.numReviews*5/max)*0.5).compareTo((e1.rating*0.5 + (e1.numReviews*5/max)*0.5)));
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
											showModalBottomSheet(context: context, isScrollControlled: true,  builder: (BuildContext bc){
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
					),
					Container(
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
											Alerts.toast("El idioma de la carta se actualizará en breve...");
											language = selected;
										});
										switch (selected){
											case "English":
												if(restaurant.english == null){
													restaurant.english = [];
													for(MenuEntry entry in restaurant.menu){
														String name, description;
														if(language == "Original"){
															name = await Translator.translate('en', entry.name);
															description = await Translator.translate('en', entry.description);
														}
														else{
															Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
															name = await Translator.translate('en', tr.name);
															description = await Translator.translate('en', tr.description);
														}
														Translate translation = Translate(id: entry.id, name: name, description: description);
														restaurant.english.add(translation);
														entry.name = name;
														entry.description = description;
													}
												}
												else{
													for(MenuEntry entry in restaurant.menu){
														for(Translate tl in restaurant.english){
															if(tl.id == entry.id){
																entry.name = tl.name;
																entry.description = tl.description;
																break;
															}
														}
													}
												}
												break;
											case "Spanish":
												if(restaurant.spanish == null){
													restaurant.spanish = [];
													for(MenuEntry entry in restaurant.menu){
														String name, description;
														if(language == "Original"){
															name = await Translator.translate('es', entry.name);
															description = await Translator.translate('es', entry.description);
														}
														else{
															Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
															name = await Translator.translate('es', tr.name);
															description = await Translator.translate('es', tr.description);
														}
														Translate translation = Translate(id: entry.id, name: name, description: description);
														restaurant.spanish.add(translation);
														entry.name = name;
														entry.description = description;
													}
												}
												else{
													for(MenuEntry entry in restaurant.menu){
														for(Translate tl in restaurant.spanish){
															if(tl.id == entry.id){
																entry.name = tl.name;
																entry.description = tl.description;
																break;
															}
														}
													}
												}
												break;
											case "French":
												if(restaurant.french == null){
													restaurant.french = [];
													for(MenuEntry entry in restaurant.menu){
														String name, description;
														if(language == "Original"){
															name = await Translator.translate('fr', entry.name);
															description = await Translator.translate('fr', entry.description);
														}
														else{
															Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
															name = await Translator.translate('fr', tr.name);
															description = await Translator.translate('fr', tr.description);
														}
														Translate translation = Translate(id: entry.id, name: name, description: description);
														restaurant.french.add(translation);
														entry.name = name;
														entry.description = description;
													}
												}
												else{
													for(MenuEntry entry in restaurant.menu){
														for(Translate tl in restaurant.french){
															if(tl.id == entry.id){
																entry.name = tl.name;
																entry.description = tl.description;
																break;
															}
														}
													}
												}
												break;
											case "German":
												if(restaurant.german == null){
													restaurant.german = [];
													for(MenuEntry entry in restaurant.menu){
														String name, description;
														if(language == "Original"){
															name = await Translator.translate('de', entry.name);
															description = await Translator.translate('de', entry.description);
														}
														else{
															Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
															name = await Translator.translate('de', tr.name);
															description = await Translator.translate('de', tr.description);
														}
														Translate translation = Translate(id: entry.id, name: name, description: description);
														restaurant.german.add(translation);
														entry.name = name;
														entry.description = description;
													}
												}
												else{
													for(MenuEntry entry in restaurant.menu){
														for(Translate tl in restaurant.german){
															if(tl.id == entry.id){
																entry.name = tl.name;
																entry.description = tl.description;
																break;
															}
														}
													}
												}
												break;
											case "Italian":
												if(restaurant.italian == null){
													restaurant.italian = [];
													for(MenuEntry entry in restaurant.menu){
														String name, description;
														if(language == "Original"){
															name = await Translator.translate('it', entry.name);
															description = await Translator.translate('it', entry.description);
														}
														else{
															Translate tr = restaurant.original.firstWhere((element) => element.id == entry.id);
															name = await Translator.translate('it', tr.name);
															description = await Translator.translate('it', tr.description);
														}
														Translate translation = Translate(id: entry.id, name: name, description: description);
														restaurant.italian.add(translation);
														entry.name = name;
														entry.description = description;
													}
												}
												else{
													for(MenuEntry entry in restaurant.menu){
														for(Translate tl in restaurant.italian){
															if(tl.id == entry.id){
																entry.name = tl.name;
																entry.description = tl.description;
																break;
															}
														}
													}
												}
												break;
											case "Original":
													for(MenuEntry entry in restaurant.menu){
														for(Translate tl in restaurant.original){
															if(tl.id == entry.id){
																entry.name = tl.name;
																entry.description = tl.description;
																break;
															}
														}
													}
												break;
										}
										setState(() {
										});
									},
								),
								Expanded(child: Align( alignment: AlignmentDirectional.topCenter, child: Text("Menu", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)))),
								SizedBox(width: 70.w,),
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
											backToOriginal();
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
