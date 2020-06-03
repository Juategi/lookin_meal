import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:diacritic/diacritic.dart';

class GeolocationService{

	Future<double> distanceBetween(double startLatitude, double startLongitude, double endLatitude, double endLongitude)async{ //optimizable
		double distance = await Geolocator().distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
		return num.parse((distance/1000).toStringAsFixed(1));
	}

	Future<Position> getLocation() async{
		Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
		if(position == null)
			return await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
		else
			return position;
	}

	Future<String> getCity(double latitude, double longitude)async{
		final coordinates = new Coordinates(latitude, longitude);
		var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
		var first = addresses.first;
		return removeDiacritics(first.locality);
	}
}
