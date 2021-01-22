
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:fluster/fluster.dart';
import 'dart:math' as math;

class MapSample extends StatefulWidget {
	@override
	State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
	User user;
	Position pos;
	String _mapStyle;
	double latTo, latFrom, longTo, longFrom;
	Completer<GoogleMapController> _controller = Completer();
	final GeolocationService _geolocationService = GeolocationService();
	final _key = GlobalKey();
	Map<String,BitmapDescriptor> pinLocationIcons;
	BitmapDescriptor basic;
	List<Restaurant> _restaurants = [];
	List<RestaurantMarker> _markers = List<RestaurantMarker>();
	CameraPosition _cameraPosition;
	Fluster<RestaurantMarker> fluster;
	List<Marker> googleMarkers;
	List<Marker> _markersNoCluster = [];


	void _timer() {
		if(_cameraPosition == null && _markers == null) {
			Future.delayed(Duration(seconds: 2)).then((_) {
				setState(() {
					print("Loading map...");
				});
				_timer();
			});
		}
	}

	@override
	initState(){
		BitmapDescriptor.fromAssetImage(
				ImageConfiguration(devicePixelRatio: 2.5),
				'assets/marker.png').then((onValue) {
			basic = onValue;
		});
		pinLocationIcons = {};
		for(String type in CommonData.typesImage.keys){
			BitmapDescriptor.fromAssetImage(
					ImageConfiguration(devicePixelRatio: 2.5),
					'assets/food/${CommonData.typesImage[type]}.png').then((value) => pinLocationIcons[type] = value);
		}
		_getUserLocation();
		//_loadMarkers();
		_timer();
		super.initState();
		rootBundle.loadString('assets/map_style.txt').then((string) {
			_mapStyle = string;
		});
		fluster = Fluster<RestaurantMarker>(
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
		googleMarkers = fluster.clusters([-180, -85, 180, 85], 10).map((cluster) => cluster.toMarker()).toList();
	}

	void _getUserLocation() async{
		pos = await _geolocationService.getLocation();
		_cameraPosition = CameraPosition(
			target: LatLng(pos.latitude,pos.longitude),
			zoom: 16,
		);
	}

	Future _loadMarkers() async {
		_restaurants = await DBService().getRestaurantsSquare(pos.latitude, pos.longitude, latFrom, latTo, longFrom, longTo);
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

	Future _loadMarkersNoCluster() async {
		_restaurants = await DBService().getRestaurantsSquare(pos.latitude, pos.longitude, latFrom, latTo, longFrom, longTo);
		_markersNoCluster.clear();
		for(Restaurant restaurant in _restaurants){
			_markersNoCluster.add(Marker(
				markerId: MarkerId(restaurant.restaurant_id),
				position: LatLng(restaurant.latitude,restaurant.longitude),
				icon:restaurant.types.length > 0 ? pinLocationIcons[restaurant.types[0]] : basic,
				infoWindow: InfoWindow(
						title: "${restaurant.name}   ${restaurant.rating}/5.0",
						snippet: "${restaurant.distance} km",
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
	}

	@override
	Widget build(BuildContext context){
		user = Provider.of<User>(context);
		return _cameraPosition == null || (_markersNoCluster.length == 0 && _restaurants.length != 0) ? Loading() : Container(
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
						onCameraMove: (CameraPosition pos){
							double lastZoom = _cameraPosition.zoom;
							_cameraPosition = pos;
							if(pos.zoom < 15 && pos.zoom < lastZoom) {
								_markersNoCluster.clear();
								_restaurants.clear();
							}
							setState(() {
							});
						},
					),
					Positioned(
						top: 550,
						left: 140,
						child: RaisedButton(child: Text("Cargar restaurantes"), onPressed: ()async{
							Size _widgetSize = _key.currentContext.size;
							var _correctZoom = math.pow(2, _cameraPosition.zoom) * 2;
							var _width = _widgetSize.width.toInt() / _correctZoom;
							var _height = _widgetSize.height.toInt() / _correctZoom;
							latFrom = _cameraPosition.target.latitude - _width;
							latTo = _cameraPosition.target.latitude + _width;
							longFrom = _cameraPosition.target.longitude - _height;
							longTo = _cameraPosition.target.longitude + _height;
							print(latFrom);
							print(latTo);
							print(longFrom);
							print(longTo);
							await _loadMarkersNoCluster();
							setState((){
							});
						},),
					)
				],
			)
		);
	}
}

class RestaurantMarker extends Clusterable {
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

