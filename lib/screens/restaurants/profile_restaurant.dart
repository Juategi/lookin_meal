import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'admin/premium.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/owner.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/translate.dart';
import 'package:lookinmeal/screens/profile/favorites.dart';
import 'package:lookinmeal/screens/restaurants/admin/admin.dart';
import 'package:lookinmeal/screens/restaurants/admin/manage_orders.dart';
import 'package:lookinmeal/screens/restaurants/daily.dart';
import 'package:lookinmeal/screens/restaurants/gallery.dart';
import 'package:lookinmeal/screens/restaurants/info.dart';
import 'package:lookinmeal/screens/restaurants/menu.dart';
import 'package:lookinmeal/screens/restaurants/reservations.dart';
import 'package:lookinmeal/screens/restaurants/reserve_table.dart';
import 'package:lookinmeal/screens/restaurants/top_dishes_tile.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/services/translator.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:permission/permission.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ProfileRestaurant extends StatefulWidget {
  @override
  _ProfileRestaurantState createState() => _ProfileRestaurantState();
}

class _ProfileRestaurantState extends State<ProfileRestaurant> {
	Restaurant restaurant;
	bool first = true;
	bool uploaded = false;
	bool loading = false;
	String language;
	List<Owner> owners;
	List<File> photos = [];
	String requestStatus = "";

	void _loadOwners()async{
		owners = await DBServiceUser.dbServiceUser.getOwners(restaurant.restaurant_id);
		setState(() {
		});
	}

	void _loadData() async{
		await DBServicePayment.dbServicePayment.getPremium(restaurant);
		await DBServicePayment.dbServicePayment.getSponsor(restaurant);
		setState(() {
		});
	}

	void _loadStatus() async{
		if(await 	DBServiceRestaurant.dbServiceRestaurant.checkRequestStatus(restaurant.restaurant_id)) {
			requestStatus = "¡Parece que ya has subido una carta del menu!";
			uploaded = true;
		}
		else
			requestStatus = "¡Parece que no hay menu, haz una foto a la carta y nosotros nos encargaremos de subirla!";
		setState(() {
		});
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
		List<DropdownMenuItem> items = DBServiceUser.userF.lists.where((FavoriteList list) => list.type == 'R').map((list) =>
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
  	print(restaurant.restaurant_id);
		if(first){
			_loadData();
			_loadOwners();
			if(restaurant.menu.length == 0)
				_loadStatus();
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
			for(int i = 0; i < 7; i++){
				try {
					Functions.parseSchedule(restaurant.schedule[i.toString()]);
				}catch(e){
					print(e);
				}
			}
			first = false;
		}
  	//if(restaurant.menu == null)
  		//_loadMenu();
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
			//backgroundColor: CommonData.backgroundColor,
        body: restaurant.premium  == null? Loading() : ListView(
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
											icon: Icon(DBServiceUser.userF.lists.firstWhere((list) => list.type == 'R' && list.items.contains(restaurant.restaurant_id), orElse: () => null) != null ? Icons.favorite_outlined : Icons.favorite_outline, size: ScreenUtil().setSp(45),color: Color.fromRGBO(255, 65, 112, 1)),
											items: _loadItems(),
											onChanged: (list)async{
												if(list.id == null){
													await pushNewScreenWithRouteSettings(
														context,
														settings: RouteSettings(name: "/createlist", arguments: 'R'),
														screen: CreateList(),
														withNavBar: true,
														pageTransitionAnimation: PageTransitionAnimation.slideUp,
													);
													//await Navigator.pushNamed(context, "/createlist", arguments: 'R');
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
													await DBServiceUser.dbServiceUser.updateList(list);
												}
												setState(() {
												});
											},
										),
										SizedBox(width: 20.w,),
								],
							),
						),
						onTap: () =>
								pushNewScreenWithRouteSettings(
									context,
									settings: RouteSettings(name: "/gallery", arguments: restaurant),
									screen: Gallery(),
									withNavBar: true,
									pageTransitionAnimation: PageTransitionAnimation.slideUp,
								),
								//Navigator.pushNamed(context, "/gallery", arguments: restaurant),
        		),
						//ADMIN
					//owners == null || owners.firstWhere((owner) => owner.user_id == DBServiceUser.userF.uid, orElse: () => null) == null ? Container() :
					Container(
						height: 105.h,
						width: 411.w,
						color: Colors.white54,
						child: Padding(
						  padding: EdgeInsets.symmetric(vertical: 10.h),
						  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
						  	children: [
						  		Align(
						  			alignment: AlignmentDirectional.topCenter,
						  			child: GestureDetector(
						  				child: Column(
						  				  children: [
						  				    Container(
															height: 55.h,
															width: 55.w,
															child: Icon(FontAwesomeIcons.calendarAlt, size:  ScreenUtil().setSp(55),)),
													Text("Reservations", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
												],
						  				),
						  				onTap: ()async{
						  					backToOriginal();
						  					if(restaurant.premiumtime == null)
													pushNewScreenWithRouteSettings(
														context,
														settings: RouteSettings( arguments: restaurant),
														screen: Premium(),
														withNavBar: true,
														pageTransitionAnimation: PageTransitionAnimation.slideUp,
													).then((value) => setState(() {}));
						  					else if(restaurant.premium || (!restaurant.premium && restaurant.premiumtime != null && Functions.compareDates(restaurant.premiumtime, DateTime.now().toString().substring(0,10)) <= 0)) {
													if(restaurant.schedule.toString() == "{1: [-1, -1], 2: [-1, -1], 3: [-1, -1], 4: [-1, -1], 5: [-1, -1], 6: [-1, -1], 0: [-1, -1]}")
														Alerts.dialog("Please create a schedule in Settings -> Edit Restaurant information", context);
													else
														pushNewScreenWithRouteSettings(
															context,
															settings: RouteSettings(
																	name: "/reservations", arguments: restaurant),
															screen: ReservationsChecker(),
															withNavBar: true,
															pageTransitionAnimation: PageTransitionAnimation
																	.slideUp,
														);
												}
						  					else
													pushNewScreenWithRouteSettings(
														context,
														settings: RouteSettings( arguments: restaurant),
														screen: Premium(),
														withNavBar: true,
														pageTransitionAnimation: PageTransitionAnimation.slideUp,
													).then((value) => setState(() {}));
						  					//Navigator.pushNamed(context, "/reservations", arguments: restaurant);
						  				},
						  			),
						  		),
						  		Align(
						  			alignment: AlignmentDirectional.topCenter,
						  			child: GestureDetector(
						  				child: Column(
						  				  children: [
						  				    Container(
						  				    	child: SvgPicture.asset("assets/pedido.svg",),
						  				    	height: 55.h,
						  				    	width: 55.w,
						  				    ),
													Text("Orders", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
												],
						  				),
						  				onTap: ()async{
												backToOriginal();
												if(restaurant.premiumtime == null)
													pushNewScreenWithRouteSettings(
														context,
														settings: RouteSettings( arguments: restaurant),
														screen: Premium(),
														withNavBar: true,
														pageTransitionAnimation: PageTransitionAnimation.slideUp,
													).then((value) => setState(() {}));
						  					else if(restaurant.premium || (!restaurant.premium && restaurant.premiumtime != null && Functions.compareDates(restaurant.premiumtime, DateTime.now().toString().substring(0,10)) <= 0))
													pushNewScreenWithRouteSettings(
														context,
														settings: RouteSettings(name: "/manageorder", arguments: restaurant),
														screen: ManageOrders(),
														withNavBar: true,
														pageTransitionAnimation: PageTransitionAnimation.slideUp,
													);
						  					else
													pushNewScreenWithRouteSettings(
														context,
														settings: RouteSettings( arguments: restaurant),
														screen: Premium(),
														withNavBar: true,
														pageTransitionAnimation: PageTransitionAnimation.slideUp,
													).then((value) => setState(() {}));
						  					//Navigator.pushNamed(context, "/manageorder", arguments: restaurant);
						  				},
						  			),
						  		),
									Align(
										alignment: AlignmentDirectional.topCenter,
										child: GestureDetector(
											child: Column(
											  children: [
											    Container(
															height: 55.h,
															width: 55.w,
															child: Icon(Icons.settings, size:  ScreenUtil().setSp(60),)),
													Text("Settings", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
												],
											),
											onTap: ()async{
												backToOriginal();
												pushNewScreenWithRouteSettings(
													context,
													settings: RouteSettings(name: "/admin", arguments: restaurant),
													screen: AdminPage(),
													withNavBar: true,
													pageTransitionAnimation: PageTransitionAnimation.slideUp,
												);
												//Navigator.pushNamed(context, "/admin", arguments: restaurant);
											},
										),
									),
						  	],
						  ),
						),
					),
					Container(
						height: 42.h,
						width: 411.w,
						decoration: BoxDecoration(
							color: Color.fromRGBO(255, 110, 117, 0.9),
						),
						child: Row( mainAxisAlignment: MainAxisAlignment.center,
							children: <Widget>[
								Text(restaurant.name, maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
								//Spacer(),
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
										    Container(width: 180.w, height: 25.h, child: Text(restaurant.types.length > 1 ? "${restaurant.types[0]}, ${restaurant.types[1]}" : restaurant.types.length > 0 ? "${restaurant.types[0]}" : "", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(17),),))),
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
										),
										restaurant.premium || (!restaurant.premium && restaurant.premiumtime != null && Functions.compareDates(restaurant.premiumtime, DateTime.now().toString().substring(0,10)) <= 0) ? GestureDetector(
											onTap: (){
												pushNewScreenWithRouteSettings(
													context,
													settings: RouteSettings(name: "/tablereservations", arguments: restaurant),
													screen: TableReservation(),
													withNavBar: true,
													pageTransitionAnimation: PageTransitionAnimation.slideUp,
												);
													//Navigator.pushNamed(context, "/tablereservations", arguments: restaurant);
											},
										  child: Row(
										  	children: <Widget>[
										  		SizedBox(width: 5.w,),
										  		Icon(FontAwesomeIcons.calendarAlt, color: Colors.black87, size: ScreenUtil().setSp(20),),
										  		SizedBox(width: 5.w,),
										  		Text("Reserve a table", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))
										  	],
										  ),
										) : Container()
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
											onTap: () =>	pushNewScreenWithRouteSettings(
													context,
													settings: RouteSettings(name: "/info", arguments: restaurant),
													screen: RestaurantInfo(),
													withNavBar: true,
													pageTransitionAnimation: PageTransitionAnimation.slideUp,
												)
													//Navigator.pushNamed(context, "/info", arguments: restaurant),
										),
									],
								)
							],
						),
					),
						SizedBox(height: 5.h,),
						Padding(
						  padding: EdgeInsets.symmetric(horizontal: 10.w),
						  child: Row(mainAxisAlignment: MainAxisAlignment.start,
						  	children: <Widget>[
						  		restaurant.delivery[0] == "" || restaurant.delivery[0] == "-" ? Container() : GestureDetector(
						  			child: Container(
						  				width: 57.w,
						  				height: 57.h,
						  				decoration: BoxDecoration(
						  						image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/glovo.png").image),
						  						borderRadius: BorderRadius.all(Radius.circular(16))
						  				),
						  			),
						  			onTap: () async{
						  				if (await canLaunch(restaurant.delivery[0])) {
						  					await launch(restaurant.delivery[0]);
						  				}
						  				else
						  					throw 'Could not open the web.';
						  			},
						  		),
						  		restaurant.delivery[1] == "" || restaurant.delivery[1] == "-"  ? Container() : GestureDetector(
						  			child: Container(
						  				width: 57.w,
						  				height: 57.h,
						  				decoration: BoxDecoration(
						  						image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/ubereats.png").image),
						  						borderRadius: BorderRadius.all(Radius.circular(16))
						  				),
						  			),
						  			onTap: () async{
						  				//await launch(restaurant.delivery[1].replaceAll('"', ''));
						  				if (await canLaunch(restaurant.delivery[1])) {
						  					await launch(restaurant.delivery[1]);
						  				}
						  				else {
						  					print(restaurant.delivery[1]);
						  					throw 'Could not open the web.';
						  				}
						  			},
						  		),
						  		restaurant.delivery[2] == "" || restaurant.delivery[2] == "-" ? Container() : GestureDetector(
						  			child: Container(
						  				width: 57.w,
						  				height: 57.h,
						  				decoration: BoxDecoration(
						  						image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/justeat.png").image),
						  						borderRadius: BorderRadius.all(Radius.circular(16))
						  				),
						  			),
						  			onTap: () async{
						  				if (await canLaunch(restaurant.delivery[2])) {
						  					await launch(restaurant.delivery[2]);
						  				}
						  				else
						  					throw 'Could not open the web.';
						  			},
						  		),
						  		restaurant.delivery[3] == "" || restaurant.delivery[3] == "-" ? Container() : GestureDetector(
						  			child: Container(
						  				width: 57.w,
						  				height: 57.h,
						  				decoration: BoxDecoration(
						  						image: DecorationImage(fit: BoxFit.cover, image: Image.asset("assets/deliveroo.png").image),
						  						borderRadius: BorderRadius.all(Radius.circular(16))
						  				),
						  			),
						  			onTap: () async{
						  				if (await canLaunch(restaurant.delivery[3])) {
						  					await launch(restaurant.delivery[3]);
						  				}
						  				else
						  					throw 'Could not open the web.';
						  			},
						  		),
						  	],
						  ),
						),
						SizedBox(height: 20.h,),
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
							photos.length == 0 ? Container(width: 300.w, height: 190.h, child: Text(requestStatus, maxLines: 6, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(28),),))) :
							Container(
								height: 90.h,
							  child: ListView(
							  	//mainAxisAlignment: MainAxisAlignment.center,
							  	scrollDirection: Axis.horizontal,
							  	children: photos.map((photo) =>
							  		Padding(
							  		  padding:  EdgeInsets.symmetric(horizontal: 10.w),
							  		  child: Container(
							  		  	width: 90.w,
							  		  	height: 90.h,
							  		  	decoration: BoxDecoration(
							  		  			image: DecorationImage(fit: BoxFit.cover, image: Image.file(photo).image),
							  		  			borderRadius: BorderRadius.all(Radius.circular(8)),
														border: Border.all(color: Colors.black)
							  		  	),
												child: GestureDetector(
													onTap: ()async{
														setState(() {
														  photos.remove(photo);
														});
													},
													child: Container(
														height: 40.h,
														width: 40.w,
														child: Icon(Icons.delete, color: Colors.black87, size: ScreenUtil().setSp(30),),
													),
												),
							  		  ),
							  		)
							  	).toList(),
							  ),
							),
							SizedBox(height: 30.h,),
							uploaded? Container() : Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
							  children: [
									photos.length >= 10 ? Container() : GestureDetector(
							    	onTap: ()async{
							    		File file = await StorageService().uploadNanonets(context, restaurant.restaurant_id);
							    		if(file != null){
							    			try{
													final photoMem = pw.MemoryImage(
														file.readAsBytesSync(),
													);
													photos.add(file);
												}catch(e){
													StorageService().sendNanonets(restaurant.restaurant_id, DBServiceUser.userF.uid, file.readAsBytesSync());
													setState(() {
														photos.clear();
														requestStatus = "¡Parece que ya has subido una carta del menu!";
													  uploaded = true;
													});
												}
											}
							    		setState(() {
							    		});
							    	},
							      child: Container(
							      	height: 80.h,
							      	width: 80.w,
							      	child: Container(
							      			height: 40.h,
							      			width: 40.w,
							      			//child: SvgPicture.asset("assets/menu.svg", color: Color.fromRGBO(255, 110, 117, 0.9), fit: BoxFit.contain,)
							    				child: Icon(Icons.linked_camera_rounded, color: Color.fromRGBO(255, 110, 117, 0.9), size: ScreenUtil().setSp(60),),
							      	),
							      ),
							    ),
									photos.length != 0 ? GestureDetector(
										onTap: ()async{
											final pdf = pw.Document();
											for(File photo in photos){
													final photoMem = pw.MemoryImage(
														photo.readAsBytesSync(),
													);
													pdf.addPage(pw.Page(
															pageFormat: PdfPageFormat.a4,
															build: (pw.Context context) {
																return pw.Center(
																		child: pw.Container(
																			decoration: pw.BoxDecoration(
																					image: pw.DecorationImage(
																							fit: pw.BoxFit.cover,
																							image: pw
																									.Image(photoMem)
																									.image)),
																		)
																);
															})
													);
											}
											StorageService().sendNanonets(restaurant.restaurant_id, DBServiceUser.userF.uid, await pdf.save());
											setState(() {
												photos.clear();
												requestStatus = "¡Parece que ya has subido una carta del menu!";
												uploaded = true;
											});
										},
										child: Container(
											height: 80.h,
											width: 80.w,
											child: Container(
												height: 40.h,
												width: 40.w,
												child: Icon(Icons.send, color: Color.fromRGBO(255, 110, 117, 0.9), size: ScreenUtil().setSp(60),),
											),
										),
									) : Container()
							  ],
							),
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
					restaurant.menu.length != 0 ? Provider.value(value: false, child: Provider.value(value: restaurant, child: Menu())) : Container(),
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
					restaurant.dailymenu != null ? DailyMenu(restaurant: restaurant, currency: restaurant.currency) : Container(height: 20.h,),
        	],
        ),
      ),
    );
  }



}
