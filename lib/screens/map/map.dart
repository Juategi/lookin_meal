import 'dart:ui' as ui;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';
//import 'package:fluster/fluster.dart';
import 'dart:math' as math;

class MapSample extends StatefulWidget {
	@override
	State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
	User user;
	Position pos;
	int size;
	double latTo, latFrom, longTo, longFrom;
	bool loading = false;
	bool first = true;
	Restaurant selected;
	String _mapStyle = '[{"featureType": "poi", elementType: "labels","stylers": [{"visibility": "off"}]}]';
	Completer<GoogleMapController> _controller = Completer();
	final GeolocationService _geolocationService = GeolocationService();
	final _key = GlobalKey();
	Map<String,BitmapDescriptor> pinLocationIcons = {};
	BitmapDescriptor basic;
	List<Restaurant> _restaurants = [];
	//List<RestaurantMarker> _markers = List<RestaurantMarker>();
	CameraPosition _cameraPosition;
	//Fluster<RestaurantMarker> fluster;
	List<Marker> googleMarkers;
	List<Marker> _markersNoCluster = [];



	int calculateMarkerSize(){

		if(_cameraPosition.zoom > ScreenUtil().setSp(14)){
			return (_cameraPosition.zoom * ScreenUtil().setSp(4.5)).toInt();
		}
		else if(_cameraPosition.zoom < ScreenUtil().setSp(13)){
			return (_cameraPosition.zoom * ScreenUtil().setSp(3.2)).toInt();
		}
		else if(_cameraPosition.zoom < ScreenUtil().setSp(12)){
			return (_cameraPosition.zoom).toInt();
		}
		else{
			return (_cameraPosition.zoom * ScreenUtil().setSp(6)).toInt();
		}
	}

	Future<Uint8List> getBytesFromAsset(String path, int width) async {
		ByteData data = await rootBundle.load(path);
		ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
		ui.FrameInfo fi = await codec.getNextFrame();
		return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
	}

	Future updateMarkersSize() async{
		int size = calculateMarkerSize();
		print(size);
		print(_cameraPosition.zoom );
		for(String type in CommonData.typesImage.keys){
			Uint8List markerIcon = await getBytesFromAsset('assets/food/${CommonData.typesImage[type]}.png', size);
			pinLocationIcons[type] = BitmapDescriptor.fromBytes(markerIcon);
		}
	}

	@override
	initState(){
		BitmapDescriptor.fromAssetImage(
				ImageConfiguration(devicePixelRatio: 2.5),
				'assets/marker.png').then((onValue) {
			basic = onValue;
		});
		for(String type in CommonData.typesImage.keys){
			BitmapDescriptor.fromAssetImage(
					ImageConfiguration(devicePixelRatio: 2.5),
					'assets/food/${CommonData.typesImage[type]}.png').then((value) => pinLocationIcons[type] = value);
		}
		_getUserLocation();
		//_loadMarkers();
		super.initState();
		/*fluster = Fluster<RestaurantMarker>(
			minZoom: 14, // The min zoom at clusters will show
			maxZoom: 30, // The max zoom at clusters will show
			radius: 150, // Cluster radius in pixels
			extent: 2048, // Tile extent. Radius is calculated with it.
			nodeSize: 64, // Size of the KD-tree leaf node.
			points: _markers, // The list of markers created before
			createCluster: ( // Create cluster marker
					BaseCluster cluster,
					double lng,
					double lat,
					) => RestaurantMarker(
				id: cluster.id.toString(),
				position: LatLng(lat, lng),
				//icon: pinLocationIcon,
				isCluster: cluster.isCluster,
				clusterId: cluster.id,
				pointsSize: cluster.pointsSize,
				childMarkerId: cluster.childMarkerId,
			),
		);
		googleMarkers = fluster.clusters([-180, -85, 180, 85], 10).map((cluster) => cluster.toMarker()).toList();*/
	}

	void _getUserLocation() async{
		pos = await _geolocationService.getLocation();
		_cameraPosition = CameraPosition(
			target: LatLng(pos.latitude,pos.longitude),
			zoom: 16,
		);
		setState(() {
		});
	}

	/*Future _loadMarkers() async {
		_restaurants = await DBServiceRestaurant.dbServiceRestaurant.getRestaurantsSquare(pos.latitude, pos.longitude, latFrom, latTo, longFrom, longTo);
		for(Restaurant restaurant in _restaurants){
			_markers.add(RestaurantMarker(
				id: restaurant.restaurant_id,
				position: LatLng(restaurant.latitude,restaurant.longitude),
				//icon: pinLocationIcon,
				infoWindow: InfoWindow(
					title: "${restaurant.name}   ${restaurant.rating}/5.0",
					snippet: restaurant.address,
					onTap: ()async{
						List<Object> args = List<Object>();
						args.add(restaurant);
						args.add(user);
						Pool.addRestaurant(restaurant);
						Navigator.pushNamed(context, "/restaurant",arguments: args);
					}
				),
			));
		}
		googleMarkers = fluster.clusters([-180, -85, 180, 85], 10).map((cluster) => cluster.toMarker()).toList();
	}

	 */

	Future _loadMarkersNoCluster() async {
		setState(() {
			loading = true;
		});
		_restaurants = await DBServiceRestaurant.dbServiceRestaurant.getRestaurantsSquare(pos.latitude, pos.longitude, latFrom, latTo, longFrom, longTo);
		_markersNoCluster.clear();
		for(Restaurant restaurant in _restaurants){
			_markersNoCluster.add(Marker(
				markerId: MarkerId(restaurant.restaurant_id),
				position: LatLng(restaurant.latitude,restaurant.longitude),
				icon:restaurant.types.length > 0 ? pinLocationIcons[restaurant.types[0]] : basic,
				onTap: (){
					setState(() {
					  selected = restaurant;
					  print(selected.name);
					});
				}
				/*infoWindow: InfoWindow(
						title: "${restaurant.name}   ${restaurant.rating}/5.0",
						snippet: "${restaurant.distance} km",
						onTap: ()async{
							List<Object> args = List<Object>();
							args.add(restaurant);
							args.add(user);
							Pool.addRestaurant(restaurant);
							Navigator.pushNamed(context, "/restaurant",arguments: args);
						}
				),*/
			));
		}
		setState(() {
			loading = false;
		});
	}

	@override
	Widget build(BuildContext context){
		AppLocalizations tr = AppLocalizations.of(context);
		user = Provider.of<User>(context);
		if(first){
			CommonData.tabContext = context;
			first = false;
		}
		return _cameraPosition == null || (_markersNoCluster.length == 0 && _restaurants.length != 0) ? Loading() : Container(
		  child: SafeArea(
		    child: Stack(
				children: <Widget>[
					GoogleMap(
						key: _key,
						markers: _markersNoCluster.toSet(),
						myLocationButtonEnabled: true,
						myLocationEnabled: true,
						mapType: MapType.normal,
						initialCameraPosition: _cameraPosition,
						onMapCreated: (GoogleMapController controller) async{
							_controller.complete(controller);
							controller.setMapStyle(_mapStyle);
						},
						onTap: (pos){
							setState(() {
								selected = null;
							});
						},
						onCameraMove: (CameraPosition pos) async{
							double lastZoom = _cameraPosition.zoom;
							_cameraPosition = pos;
							List<Marker> aux = [];
							if(pos.zoom != lastZoom){
								updateMarkersSize();
								for(int i = 0; i < _markersNoCluster.length; i++){
									Marker marker = _markersNoCluster[i];
									Restaurant r = _restaurants[i];
									aux.add(Marker(
										markerId: MarkerId(marker.markerId.toString()),
										icon: r.types.length > 0 ? pinLocationIcons[r.types[0]] : basic,
										position: LatLng(marker.position.latitude, marker.position.longitude),
										onTap: marker.onTap,
										infoWindow: marker.infoWindow,
									));
								}
								_markersNoCluster.clear();
								_markersNoCluster.addAll(aux);
							}
							setState(() {
							});
						},
					),
					Positioned(
						top: 110.h,
						right: 20.w,
						child: RaisedButton(color:Colors.white, child: Text(tr.translate("loadres"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(15),),)), onPressed: ()async{
							Size _widgetSize = _key.currentContext.size;
							var _correctZoom = math.pow(2, _cameraPosition.zoom) * 2;
							var _width = _widgetSize.width.toInt() / _correctZoom;
							var _height = _widgetSize.height.toInt() / _correctZoom;
							latFrom = _cameraPosition.target.latitude - _width;
							latTo = _cameraPosition.target.latitude + _width;
							longFrom = _cameraPosition.target.longitude - _height;
							longTo = _cameraPosition.target.longitude + _height;
							await _loadMarkersNoCluster();
							setState((){
							});
						},),
					),
					Positioned(
						top: 60.h,
						right: 20.w,
						child: RaisedButton(color:Colors.white, child: Text(tr.translate("clear"), maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 110, 117, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(15),),)), onPressed: (){
								_markersNoCluster.clear();
								_restaurants.clear();
								setState(() {});
						},),
					),
					Positioned(
							bottom: 350.h,
							left: 0.w,
							right: 0.w,
						child: loading ? Center(child: Container(width: 50.w, child: Loading())) : Container()
					),
					selected == null ? Container() : AnimatedPositioned(
							bottom: 70.h,
							left: 0.w,
							right: 0.w,
							child: GestureDetector(
								onTap: ()async{
									DBServiceRestaurant.dbServiceRestaurant.updateRecently(selected);
									CommonData.pop[1] = true;
									await pushNewScreenWithRouteSettings(
										context,
										settings: RouteSettings(name: "/restaurant", arguments: selected),
										screen: ProfileRestaurant(),
										withNavBar: true,
										pageTransitionAnimation: PageTransitionAnimation.slideUp,
									).then((value) => setState(() {}));
									//Navigator.pushNamed(context, "/restaurant",arguments: selected).then((value) => setState(() {}));
								},
							  child: Center(
							  		child: Container(
							  			height: 100.h,
							  			width: 270.w,
							  			decoration: new BoxDecoration(
							  				color: Colors.white,
							  				borderRadius: BorderRadius.all(Radius.circular(25)),
							  				boxShadow: [BoxShadow(
							  					color: Colors.grey.withOpacity(0.2),
							  					spreadRadius: 2,
							  					blurRadius: 3,
							  					offset: Offset(1, 1), // changes position of shadow
							  				),],
							  			),
							  			child: Padding(
							  			  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
							  			  child: Row(
							  			  	children: [
							  			  		Container(height: 65.h, width: 65.w,
							  			  				decoration: new BoxDecoration(
							  			  						shape: BoxShape.circle,
							  			  						image: new DecorationImage(
							  			  								fit: BoxFit.cover,
							  			  								image: new NetworkImage(
																						selected.images.length == 0? StaticStrings.defaultImage :	selected.images.first)
							  			  						)
							  			  				)
							  			  		),
							  						SizedBox(width: 15.w,),
							  						Column( crossAxisAlignment: CrossAxisAlignment.start,
							  							children: [
							  								SizedBox(height: 10.w,),
							  								Container(width: 170.w,child: Text(selected.name, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(15),),))),
																Container(width: 170.w,child: Text(selected.types.length == 0 ? "" : selected.types.length > 1 ? "${tr.translate(selected.types[0])}, ${tr.translate(selected.types[1])}" : "${tr.translate(selected.types[0])}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.8), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),))),
							  								SizedBox(height: 4.h,),
							  								Row(
							  								  children: [
							  								    StarRating(color: Color.fromRGBO(250, 201, 53, 1), rating: Functions.getRating(selected), size: ScreenUtil().setSp(12),),
							  										SizedBox(width: 10.w,),
							  										Text("${Functions.getVotes(selected)} ${tr.translate("votes")}", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),)),
							  									],
							  								),
							  							],
							  						)
							  			  	],
							  			  ),
							  			),
							  		)
							  ),
							), duration: Duration(seconds: 1)),
				],
			),
		  )
		);
	}
}

/*class RestaurantMarker extends Clusterable {
	final String id;
	final LatLng position;
	final BitmapDescriptor icon;
	final InfoWindow infoWindow;
	RestaurantMarker({
		@required this.id,
		@required this.position,
		@required this.icon,
		@required this.infoWindow,
		isCluster = false,
		clusterId,
		pointsSize,
		childMarkerId,
	}) : super(
		markerId: id,
		latitude: position.latitude,
		longitude: position.longitude,
		isCluster: isCluster,
		clusterId: clusterId,
		pointsSize: pointsSize,
		childMarkerId: childMarkerId,
	);
	Marker toMarker() => Marker(
		markerId: MarkerId(id),
		position: LatLng(
			position.latitude,
			position.longitude,
		),
		icon: icon,
		infoWindow: infoWindow
	);
}

 */

