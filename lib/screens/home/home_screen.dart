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
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
		return !search? SafeArea(
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
		  	  		SizedBox(height: 30.h,),
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
		):
		Search();
  }
}
