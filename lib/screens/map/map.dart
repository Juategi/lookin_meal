import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/loading.dart';


class MapSample extends StatefulWidget {
	@override
	State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

	String _mapStyle;
	Completer<GoogleMapController> _controller = Completer();
	final GeolocationService _geolocationService = GeolocationService();
	DBService _dbService = DBService();
	List<Restaurant> _restaurants;
	Set<Marker> _markers = Set<Marker>();
	CameraPosition _cameraPosition;

	@override
	initState(){
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
				infoWindow: InfoWindow(
					title: restaurant.name,
					snippet: restaurant.address,
				),
			));
		}
	}

	@override
	Widget build(BuildContext context){
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