import 'package:geolocator/geolocator.dart';

class GeolocationService{

	Future<double> distanceBetween(double startLatitude, double startLongitude, double endLatitude, double endLongitude)async{ //optimizable
		double distance = await Geolocator().distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
		return num.parse((distance/1000).toStringAsFixed(2));
	}

	Future<Position> getLocation() async{
		Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
		if(position == null)
			return await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
		else
			return position;
	}
}
