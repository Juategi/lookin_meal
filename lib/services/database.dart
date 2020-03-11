import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';

class DBService{

	final String uid;
	final CollectionReference userCollection = Firestore.instance.collection('users');
	final CollectionReference restaurantCollection = Firestore.instance.collection('restaurants');

	DBService({this.uid});

	Future updateUserData(String email, String name, String picture ) async{
		return await userCollection.document(uid).setData({
			'email':email,
			'name':name,
			'picture':picture
		});
	}

	Future updateRestaurantData(String name, String phone, String website, String webUrl, String address, String email, String city, String country, double latitude,
		double longitude, double rating, int numberViews, List<String> images, List<String> types, Map<String,List<int>> schedule ) async{
		return await restaurantCollection.document(uid).setData({
			'name':name,
			'phone':phone,
			'website':website,
			'webUrl':webUrl,
			'address':address,
			'email':email,
			'city':city,
			'country':country,
			'latitude':latitude,
			'longitude':longitude,
			'rating':rating,
			'numberViews':numberViews,
			'images':images,
			'types':types,
			'schedule':schedule
		});
	}

	Restaurant _restaurantDataFromSnapshot(DocumentSnapshot snapshot){
		return Restaurant(
			id: snapshot.documentID,
			name: snapshot.data['name'],
			phone: snapshot.data['phone'],
			website: snapshot.data['website'],
			webUrl: snapshot.data['webUrl'],
			address: snapshot.data['address'],
			email: snapshot.data['email'],
			city: snapshot.data['city'],
			country: snapshot.data['country'],
			latitude: snapshot.data['latitude'],
			longitude: snapshot.data['longitude'],
			rating: snapshot.data['rating'],
			numberViews: snapshot.data['numberViews'],
			images: List<String>.from(snapshot.data['images']),
			types: List<String>.from(snapshot.data['types']),
			//schedule: Map<String,List<dynamic>>.from(snapshot.data['schedule']), Pendiente de arreglar
		);
	}


	Future<List<Restaurant>> get allrestaurantdata async{
		QuerySnapshot querySnapshot = await restaurantCollection.getDocuments();
		return querySnapshot.documents.map(_restaurantDataFromSnapshot).toList();
	}

	User _userDataFromSnapshot(DocumentSnapshot snapshot){
		return User(
			uid: uid,
			name: snapshot.data['name'],
			email: snapshot.data['email'],
			picture: snapshot.data['picture']
		);
	}


	Stream<User> get userdata{
		return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
	}


}