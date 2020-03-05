import 'package:geolocator/geolocator.dart';

class GeolocationService{

	static Position pos;

	static void init()async{
		pos = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
		if(pos == null)
			pos = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
	}

	Future<Position> getLocation() async{
		Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
		if(position == null)
			return await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
		else
			return position;
	}
}
