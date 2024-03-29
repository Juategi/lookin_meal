import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:diacritic/diacritic.dart';

class GeolocationService{

	static String locality, country;
	static Position myPos;

	Future<double> distanceBetween(double startLatitude, double startLongitude, double endLatitude, double endLongitude)async{ //optimizable
		double distance = await Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
		return num.parse((distance/1000).toStringAsFixed(1));
	}

	Future<Position> getLocation() async{
		Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
		if(position == null) {
			myPos = await Geolocator.getLastKnownPosition();
			return myPos;
		}
		else {
			myPos = position;
			return position;
		}
	}

	Future<String> getLocality(double latitude, double longitude)async{
		final coordinates = new Coordinates(latitude, longitude);
		var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
		var first = addresses.first;
		locality = removeDiacritics(first.locality);
		return removeDiacritics(first.locality);
	}

	Future<String> getCountry(double latitude, double longitude)async{
		final coordinates = new Coordinates(latitude, longitude);
		var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
		var first = addresses.first;
		country = first.countryName;
		return removeDiacritics(first.countryName);
	}

	static Future prueba()async{
		String query1 = "Carrer del Pintor Vila Prades, 21,València, 46008";
		String query2 = "C/Pintor Vila Prades 21 C/Pintor Vila Prades 21, 46008, Valencia España";
		var addresses = await Geocoder.local.findAddressesFromQuery(query1);
		print(addresses.first.coordinates.latitude);
		print(addresses.first.coordinates.longitude);

		addresses = await Geocoder.local.findAddressesFromQuery(query2);
		print(addresses.first.coordinates.latitude);
		print(addresses.first.coordinates.longitude);

	}
}
