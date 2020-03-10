import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

	Future updateRestaurantData(String id, String name, String phone, String website, String webUrl, String address, String email, String city, String country, double latitude,
		double longitude, double rating, int numberViews, List<String> images, List<String> types, Map<String,List<int>> schedule ) async{
		return await restaurantCollection.document(id).setData({
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