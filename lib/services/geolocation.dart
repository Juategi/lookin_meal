import 'package:geolocator/geolocator.dart';

class GeolocationService{

	Future<Position> getLocation() async{
		Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
		if(position == null)
			return await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
		else
			return position;
	}
}
