import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookinmeal/models/user.dart';

class DBService{

	final String uid;
	final CollectionReference userCollection = Firestore.instance.collection('users');

	DBService({this.uid});

	Future updateUserData(String email, String name ) async{
		return await userCollection.document(uid).setData({
			'email':email,
			'name':name
		});
	}


	User _userDataFromSnapshot(DocumentSnapshot snapshot){
		return User(
			uid: uid,
			name: snapshot.data['name'],
			email: snapshot.data['email']
		);
	}


	Stream<User> get userdata{
		return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
	}


}