import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/services/geolocation.dart';


class MapSample extends StatefulWidget {
	@override
	State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

	String _mapStyle;
	Completer<GoogleMapController> _controller = Completer();
	final GeolocationService _geolocationService = GeolocationService();


	CameraPosition _cameraPosition = CameraPosition(
		target: LatLng(GeolocationService.pos.latitude, GeolocationService.pos.longitude),
		zoom: 14.4746,
	);

	@override
	initState() {
		super.initState();
		rootBundle.loadString('assets/map_style.txt').then((string) {
			_mapStyle = string;
		});
	}

	@override
	Widget build(BuildContext context){
		return Stack(
		  children: <Widget>[
				GoogleMap(
				myLocationButtonEnabled: true,
				myLocationEnabled: true,
				mapType: MapType.normal,
				initialCameraPosition: _cameraPosition,
				onMapCreated: (GoogleMapController controller) {
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
			zoom: 14.4746,
		);
		controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));


	}
}