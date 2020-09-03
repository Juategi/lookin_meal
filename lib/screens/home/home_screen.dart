import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/restaurants/restaurant_tile.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	User user;
	List<Restaurant> nearRestaurants;
	Position myPos;
	String location;

	List<Widget> _initTiles(User user){
		List<Widget> tiles = new List<Widget>();
		for(int i = 0; i < nearRestaurants.length; i ++){
			tiles.add(
				Card(
					child: ListTile(
						title: Text(nearRestaurants.elementAt(i).name),
						subtitle: Text(" 📍 ${nearRestaurants.elementAt(i).distance} Km"),
						leading: Image.network(nearRestaurants.elementAt(i).images.first, width: 100, height: 100,),
						trailing: Icon(Icons.arrow_right),
						onTap: () {
							List<Object> args = List<Object>();
							args.add(nearRestaurants.elementAt(i));
							args.add(user);
							Navigator.pushNamed(context, "/restaurant",arguments: args);
						}
					),
				)
			);
		}
		return tiles;
	}

	@override
  Widget build(BuildContext context) {
		user = Provider.of<User>(context);
		nearRestaurants = Provider.of<List<Restaurant>>(context);
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
		return Scaffold(
			appBar: PreferredSize(
				preferredSize: Size.fromHeight(70.h),
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
										IconButton(
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
										),
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
																	myPos = Position(latitude: result.geometry.location.lat, longitude: result.geometry.location.lng);
																	String locality = await GeolocationService().getLocality(myPos.latitude, myPos.longitude);
																	List<Restaurant> aux;
																	aux = await DBService.dbService.getNearRestaurants(myPos.latitude, myPos.longitude, locality.toUpperCase());
																	Pool.addRestaurants(aux);
																	nearRestaurants = Pool.getSubList(aux);
																	setState(() {
																	});
																	Navigator.of(context).pop();
																},
																initialPosition: LatLng(myPos.latitude, myPos.longitude),
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
							height: 150.h,
						  child: ListView(
						  	scrollDirection: Axis.horizontal,
						  	children: nearRestaurants.map((r) => Provider<Restaurant>.value(value: r, child: RestaurantTile(),)).toList(),
						  ),
						)
			  	],
			  ),
			),
		);
  }
}
