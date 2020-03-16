import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';


class MapSample extends StatefulWidget {
	@override
	State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
	User user;
	String _mapStyle;
	Completer<GoogleMapController> _controller = Completer();
	final GeolocationService _geolocationService = GeolocationService();
	BitmapDescriptor pinLocationIcon;
	final DBService _dbService = DBService();
	List<Restaurant> _restaurants;
	Set<Marker> _markers = Set<Marker>();
	CameraPosition _cameraPosition;

	@override
	initState(){
		BitmapDescriptor.fromAssetImage(
			ImageConfiguration(devicePixelRatio: 2.5),
			'assets/marker.png').then((onValue) {
			pinLocationIcon = onValue;
		});
		_getUserLocation();
		_loadMarkers();
		super.initState();
		rootBundle.loadString('assets/map_style.txt').then((string) {
			_mapStyle = string;
		});


	}

	void _getUserLocation() async{
		Position pos = await _geolocationService.getLocation();
		_cameraPosition = CameraPosition(
			target: LatLng(pos.latitude,pos.longitude),
			zoom: 14.5,
		);
	}

	void _loadMarkers() async{
		_restaurants = await _dbService.allrestaurantdata;
		for(Restaurant restaurant in _restaurants){
			_markers.add(Marker(
				markerId: MarkerId(restaurant.id),
				position: LatLng(restaurant.latitude,restaurant.longitude),
				icon: pinLocationIcon,
				infoWindow: InfoWindow(
					title: "${restaurant.name}   ${restaurant.rating}/5.0",
					snippet: restaurant.address,
					onTap: ()async{
						Position myPos = await _geolocationService.getLocation();
						List<Object> args = List<Object>();
						args.add(restaurant);
						args.add(await _geolocationService.distanceBetween(myPos.latitude,myPos.longitude, restaurant.latitude, restaurant.longitude));
						args.add(user);
						Navigator.pushNamed(context, "/restaurant",arguments: args);
					}
				),

			));
		}
	}

	@override
	Widget build(BuildContext context){
		user = Provider.of<User>(context);
		return _cameraPosition == null || _markers.length == 0 ? Loading() : Stack(
		  children: <Widget>[
				GoogleMap(
					markers: _markers,
					myLocationButtonEnabled: true,
					myLocationEnabled: true,
					mapType: MapType.normal,
					initialCameraPosition: _cameraPosition,
					onMapCreated: (GoogleMapController controller) async{
						_controller.complete(controller);
						controller.setMapStyle(_mapStyle);

					},
			  ),
			],
		);
	}

	Future<void> _goToPos(Position pos) async {
		final GoogleMapController controller = await _controller.future;
		 _cameraPosition = CameraPosition(
			target: LatLng(pos.latitude, pos.longitude),
			zoom: 14.5,
		);
		controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));


	}
}