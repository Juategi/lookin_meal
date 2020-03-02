import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookinmeal/models/user.dart';

class DBService{

	final String uid;
	final CollectionReference userCollection = Firestore.instance.collection('users');

	DBService({this.uid});

	Future updateUserData(String email, String name, String picture ) async{
		return await userCollection.document(uid).setData({
			'email':email,
			'name':name,
			'picture':picture
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