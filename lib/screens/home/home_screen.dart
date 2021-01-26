import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/database/userDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/main_screen_dish_tile.dart';
import 'package:lookinmeal/screens/restaurants/restaurant_tile.dart';
import 'package:lookinmeal/screens/search/search.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	User user;
	List<Restaurant> nearRestaurants;
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
		user = Provider.of<User>(context);
		nearRestaurants = Provider.of<List<Restaurant>>(context);
		popular = Provider.of<Map<MenuEntry,Restaurant>>(context);
		if(first){
			user.addListener(() { setState(() {
			});});
			for(MenuEntry entry in popular.keys){
				entry.addListener(() { setState(() {
				});});
			}
			for(Restaurant r in nearRestaurants){
				for(MenuEntry entry in r.menu){
					entry.addListener(() { setState(() {
					});});
				}
			}
			for(Restaurant r in user.recently){
				for(MenuEntry entry in r.menu){
					entry.addListener(() { setState(() {
					});});
				}
			}
			first = false;
		}
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
		return !search? Scaffold(
			//backgroundColor: CommonData.backgroundColor,
			backgroundColor: Colors.white,
			appBar: PreferredSize(
				preferredSize: Size.fromHeight(80.h),
				child: AppBar(
					elevation: 0,
					backgroundColor: Theme.of(context).scaffoldBackgroundColor,
					flexibleSpace: Column(
						children: <Widget>[
							SizedBox(height: 50.h,),
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
																apiKey: "AIzaSyAIIK4P68Ge26Yc0HkQ6uChj_NEqF2VeCU",
																autocompleteLanguage: "es",
																desiredLocationAccuracy: LocationAccuracy.high,
																hintText: "Buscar",
																searchingText: "Buscando..",
																onPlacePicked: (result) async {
																	print(result.formattedAddress);
																	GeolocationService.myPos = Position(latitude: result.geometry.location.lat, longitude: result.geometry.location.lng);
																	String locality = await GeolocationService().getLocality(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude);
																	nearRestaurants = await DBServiceRestaurant.dbServiceRestaurant.getNearRestaurants(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude, locality.toUpperCase());
																	setState(() {
																	});
																	Navigator.of(context).pop();
																},
																initialPosition: LatLng(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude),
																useCurrentLocation: false,
															),
														),
													);
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
			  		SizedBox(height: 30.h,),
			  		Row(
			  		  children: <Widget>[
			  		    Text('Nearly ', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
								Text("${GeolocationService.locality}, ${GeolocationService.country}", style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
							],
			  		),
						SizedBox(height: 10.h,),
						Container(
							height: 175.h,
						  child: ListView(
						  	scrollDirection: Axis.horizontal,
						  	children: nearRestaurants.map((r) => Padding(
									padding: EdgeInsets.symmetric(vertical: 10.h),
						  	  child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),),
						  	)).toList(),
						  ),
						),
						SizedBox(height: 50.h,),
						Text('Popular plates', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
						SizedBox(height: 10.h,),
						Container(
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
						SizedBox(height: 50.h,),
						Text('Recently viewed', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
						SizedBox(height: 10.h,),
						Container(
							height: 175.h,
							child: ListView(
								scrollDirection: Axis.horizontal,
								children: user.recently.map((r) => Padding(
									padding: EdgeInsets.symmetric(vertical: 10.h),
								  child: Provider<Restaurant>.value(value: r, child: RestaurantTile(),),
								)).toList(),
							),
						),
						SizedBox(height: 50.h,),
						Text('You might like', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.52), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)),
					],
			  ),
			),
		):
		Search();
  }
}
