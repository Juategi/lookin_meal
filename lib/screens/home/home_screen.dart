import 'dart:io';
import 'package:lookinmeal/screens/top/top.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:upgrader/upgrader.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/main_screen_dish_tile.dart';
import 'package:lookinmeal/screens/restaurants/restaurant_tile.dart';
import 'package:lookinmeal/screens/search/search.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	User user;
	List<Restaurant> nearRestaurants, recommended, sponsored;
	Map<MenuEntry,Restaurant> popular;
	String location;
	bool first = true;
	bool search = false;

	bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
		if (info.ifRouteChanged(context)) return false;
		if(!search) return false;
		setState(() {
		  search = false;
		});
		return true;
	}

	void initRating() {
		RateMyApp rateMyApp = RateMyApp(
			preferencesPrefix: 'rateMyApp_',
			minDays: 0,
			minLaunches: 0,
			remindDays: 0,
			remindLaunches: 1,
			googlePlayIdentifier: 'com.wt.lookinmeal',
			//appStoreIdentifier: '1491556149',
		);
		rateMyApp.init().then((_) {
			if (rateMyApp.shouldOpenDialog) {
				rateMyApp.showRateDialog(
					context,
					title: 'Rate this app', // The dialog title.
					message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
					rateButton: 'RATE', // The dialog "rate" button text.
					noButton: 'NO THANKS', // The dialog "no" button text.
					laterButton: 'MAYBE LATER', // The dialog "later" button text.
					listener: (button) { // The button click listener (useful if you want to cancel the click event).
						switch(button) {
							case RateMyAppDialogButton.rate:
								print('Clicked on "Rate".');
								break;
							case RateMyAppDialogButton.later:
								print('Clicked on "Later".');
								break;
							case RateMyAppDialogButton.no:
								print('Clicked on "No".');
								break;
						}

						return true; // Return false if you want to cancel the click event.
					},
					ignoreNativeDialog: Platform.isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
					dialogStyle: const DialogStyle(), // Custom dialog styles.
					onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
					// contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
					// actionsBuilder: (context) => [], // This one allows you to use your own buttons.
				);

				// Or if you prefer to show a star rating bar (powered by `flutter_rating_bar`) :

				/*rateMyApp.showStarRateDialog(
					context,
					title: 'Rate this app', // The dialog title.
					message: 'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
					// contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
					actionsBuilder: (context, stars) { // Triggered when the user updates the star rating.
						return [ // Return a list of actions (that will be shown at the bottom of the dialog).
							FlatButton(
								child: Text('OK'),
								onPressed: () async {
									print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
									// You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
									// This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
									await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
									Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
								},
							),
						];
					},
					ignoreNativeDialog: Platform.isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
					dialogStyle: const DialogStyle( // Custom dialog styles.
						titleAlign: TextAlign.center,
						messageAlign: TextAlign.center,
						messagePadding: EdgeInsets.only(bottom: 20),
					),
					starRatingOptions: const StarRatingOptions(), // Custom star bar rating options.
					onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
				);*/
			}
		});
	}

	@override
  void initState() {
		BackButtonInterceptor.add(myInterceptor, context: context);
    super.initState();
  }

  @override
  void dispose() {
		BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

	@override
  Widget build(BuildContext context) {
		if(first){
			user = Provider.of<User>(context);
			nearRestaurants = Provider.of<List<List<Restaurant>>>(context).first;
			recommended = Provider.of<List<List<Restaurant>>>(context)[1];
			sponsored = Provider.of<List<List<Restaurant>>>(context).last;
			popular = Provider.of<Map<MenuEntry,Restaurant>>(context);
			user.addListener(() { setState(() {
			});});
			for(MenuEntry entry in popular.keys){
				entry.addListener(() { setState(() {
				});});
			}
			List<Restaurant> aux = [];
			for(Restaurant r in nearRestaurants){
				for(MenuEntry entry in r.menu){
					entry.addListener(() { setState(() {
					});});
				}
				if(sponsored.contains(r)){
					aux.add(r);
				}
			}
			for(Restaurant r in aux){
				nearRestaurants.remove(r);
			}
			for(Restaurant r in user.recently){
				for(MenuEntry entry in r.menu){
					entry.addListener(() { setState(() {
					});});
				}
			}
			first = false;
		}
		initRating();
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
		return !search? SafeArea(
		  child: UpgradeAlert(
		    child: Scaffold(
		    	//backgroundColor: CommonData().getColor(),
		    	//backgroundColor: Colors.white,
		    	appBar: PreferredSize(
		    		preferredSize: Size.fromHeight(80.h),
		    		child: AppBar(
		    			elevation: 0,
		    			backgroundColor: Theme.of(context).scaffoldBackgroundColor,
		    			flexibleSpace: Column(
		    				children: <Widget>[
		    					SizedBox(height: 19.h,),
		    					Container(
		    						padding: EdgeInsets.only(left: 8.w, right: 8.w),
		    						margin: EdgeInsets.only(left: 30.w, right: 30.w),
		    						width: 380.w,
		    						height: 50.h,
		    						child: Row(
		    							children: <Widget>[
		    								/*IconButton(
		    									icon: Icon(FontAwesomeIcons.listUl,
		    										color: Color.fromRGBO(255, 110, 117, 0.61),
		    										size: ScreenUtil().setSp(16),
		    									),
		    								),
		    								Expanded(
		    									child: TextField(
		    										//controller: _searchQuery,
		    										autofocus: false,
		    										style: TextStyle(
		    											color: Colors.black54,
		    										),
		    										decoration: new InputDecoration.collapsed(
		    												hintText: "Restaurant or dish...",
		    												hintStyle: new TextStyle(color: Colors.black45)
		    										),
		    									),
		    								),*/
		    								GestureDetector(
		    									child: Text('Search for restaurant or dish...', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
		    									onTap: (){
		    										setState(() {
		    										  search = true;
		    										});
		    									},
		    								),
		    								SizedBox(width: 40.w,),
		    								IconButton(
		    										icon: Icon(Icons.my_location,
		    											color: Color.fromRGBO(255, 110, 117, 0.61),
		    											size: ScreenUtil().setSp(23),
		    										),
		    										onPressed: () {
		    											Navigator.push(
		    												context,
		    												MaterialPageRoute(
		    													builder: (context) => PlacePicker(
		    														apiKey: "",
		    														autocompleteLanguage: "es",
		    														desiredLocationAccuracy: LocationAccuracy.high,
		    														hintText: "Buscar",
		    														searchingText: "Buscando..",
		    														onPlacePicked: (result) async {
		    															print(result.formattedAddress);
		    															GeolocationService.myPos = Position(latitude: result.geometry.location.lat, longitude: result.geometry.location.lng);
		    															String locality = await GeolocationService().getLocality(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude);
		    															await GeolocationService().getCountry(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude);
		    															nearRestaurants = await DBServiceRestaurant.dbServiceRestaurant.getNearRestaurants(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude, 12);
		    															recommended = await DBServiceRestaurant.dbServiceRestaurant.getRecommended(DBServiceUser.userF.uid);
		    															popular = await DBServiceRestaurant.dbServiceRestaurant.getPopular();
		    															print(nearRestaurants.first.name);
		    															Navigator.of(context).pop();
		    														},
		    														initialPosition: LatLng(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude),
		    														useCurrentLocation: false,
		    													),
		    												),
		    											).then((value) {
		    												//nearly = [];
		    												setState(() {
		    												});
		    											});
		    										}
		    								),
		    							],
		    						),
		    						decoration: BoxDecoration(
		    								color: Colors.white,
		    								border: Border.all(color: Colors.white),
		    								borderRadius: new BorderRadius.only(
		    									topLeft: const Radius.circular(5),
		    									topRight: const Radius.circular(5),
		    									bottomLeft: const Radius.circular(5),
		    									bottomRight: const Radius.circular(5),
		    								)
		    						),
		    					),
		    					SizedBox(height: 10.h,),
		    				],
		    			),
		    		),
		    	),
		    	body: Padding(
		    		padding: EdgeInsets.symmetric(horizontal: 20.w),
		    	  child: ListView(
		    	  	children: <Widget>[
		    	  		SizedBox(height: 10.h,),
								Row(
									children: <Widget>[
											SizedBox(width: 2.w,),
											GestureDetector(
												onTap: (){
													CommonData.pop[0] = true;
													pushNewScreenWithRouteSettings(
														context,
														settings: RouteSettings(
																name: "/top"),
														screen: Top(),
														withNavBar: true,
														pageTransitionAnimation: PageTransitionAnimation.slideUp,
													);
												},
											  child: Container(
											  	height: 40.w,
											  	width: 245.w,
											  	decoration: BoxDecoration(
											  			color: Colors.white,
											  			border: Border.all(color: Colors.white),
											  			boxShadow: [BoxShadow(
											  				color: Colors.grey.withOpacity(0.2),
											  				spreadRadius: 2,
											  				blurRadius: 3,
											  				offset: Offset(1, 1), // changes position of shadow
											  			),],
											  			borderRadius: new BorderRadius.all(
											  				const Radius.circular(20),
											  			)
											  	),
											  	child: Row(
											  		children: [
											  			SizedBox(width: 5.w,),
											  			Icon(Icons.star_outlined, color: Color.fromRGBO(255, 201, 23, 1), size: ScreenUtil().setSp(28),),
											  			SizedBox(width: 5.w,),
											  			Text('Top restaurants and dishes', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(15),),)),
											  		],
											  	),
											  ),
											)
										],
								),
								SizedBox(height: 10.h,),
		    	  		Row(
		    	  		  children: <Widget>[
		    	  		    Text('Nearly ', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
		    						Text("${GeolocationService.locality}, ${GeolocationService.country}", style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
		    					],
		    	  		),
		    				SizedBox(height: 10.h,),
		    				Container(
		    					height: 355.h,
		    				  child:/* ListView(
		    				  	scrollDirection: Axis.horizontal,
		    				  	children: nearRestaurants.map((r) => Padding(
		    							padding: EdgeInsets.symmetric(vertical: 10.h),
		    							child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),),
		    						)).toList()
		    				  ),*/
		    					GridView(
		    						scrollDirection: Axis.horizontal,
		    						gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
		    								maxCrossAxisExtent: 200,
		    								childAspectRatio: 1.3 / 2,
		    								crossAxisSpacing: 1,
		    								mainAxisSpacing: 2
		    						),
		    						children: sponsored.map((r) => Padding(
										padding: EdgeInsets.symmetric(vertical: 10.h),
										child: Provider<bool>.value(value: true, child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),)),
									)).toList() + nearRestaurants.map((r) => Padding(
		    							padding: EdgeInsets.symmetric(vertical: 10.h),
		    							child: Provider<bool>.value(value: false, child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),)),
		    						)).toList(),
		    					),
		    				),
		    				SizedBox(height: 50.h,),
		    				popular.entries.length == 0? Container() : Text('Popular plates', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
		    				SizedBox(height: 10.h,),
		    				popular.entries.length == 0? Container() : Container(
		    					height: 195.h,
		    					child: ListView(
		    						scrollDirection: Axis.horizontal,
		    						//children: user.favorites.first.menu.map((e) => Provider<MenuEntry>.value(value: e, child: DishTile(),)).toList(),
		    						children: popular.entries.map((e) => MultiProvider(
		    							providers: [
		    								Provider<MenuEntry>(create: (c) => e.key,),
		    								Provider<Restaurant>(create: (c) => e.value,)
		    							],
		    							child: Padding(
		    							  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
		    							  child: DishTile(),
		    							),
		    						) ).toList(),
		    					),
		    				),
		    				popular.entries.length == 0? Container() : SizedBox(height: 50.h,),
		    				user.recently.length == 0? Container() : Text('Recently viewed', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
		    				SizedBox(height: 10.h,),
		    				user.recently.length == 0? Container() : Container(
		    					height: 175.h,
		    					child: ListView(
		    						scrollDirection: Axis.horizontal,
		    						children: user.recently.map((r) => Padding(
		    							padding: EdgeInsets.symmetric(vertical: 10.h),
		    						  child: Provider<bool>.value(value: false, child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),)),
		    						)).toList(),
		    					),
		    				),
		    				user.recently.length == 0? Container() : SizedBox(height: 50.h,),
		    				recommended.length == 0? Container() : Text('You might like', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
		    				SizedBox(height: 20.h,),
		    				recommended.length == 0? Container() : Container(
		    					height: 355.h,
		    					child:
		    					GridView(
		    						scrollDirection: Axis.horizontal,
		    						gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
		    								maxCrossAxisExtent: 200,
		    								childAspectRatio: 1.3 / 2,
		    								crossAxisSpacing: 1,
		    								mainAxisSpacing: 2
		    						),
		    						children: recommended.map((r) => Padding(
		    							padding: EdgeInsets.symmetric(vertical: 10.h),
		    							child: Provider<bool>.value(value: false, child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),)),
		    						)).toList(),
		    					),
		    				),
		    			],
		    	  ),
		    	),
		    ),
		  ),
		):
		Search();
  }
}
