import 'package:firebase_auth/firebase_auth.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/database.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


class AuthService{

	final FirebaseAuth _auth = FirebaseAuth.instance;

	User _userFromFirebaseUser(FirebaseUser user){
		return user != null ? User(uid: user.uid, email: user.email) : null;
	}


	Stream<User> get user {
		return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
		//return _auth.onAuthStateChanged.map((FirebaseUser user) => _userFromFirebaseUser(user));
	}

	Future signInEP(String email, String password) async{
		try{
			AuthResult result =	await _auth.signInWithEmailAndPassword(email: email, password: password);
			FirebaseUser user = result.user;
			return _userFromFirebaseUser(user);
		} catch(e){
			print(e);
			return null;
		}
	}

	Future registerEP(String email, String password, String name) async{
		try{
			AuthResult result =	await _auth.createUserWithEmailAndPassword(email: email, password: password);
			FirebaseUser user = result.user;
			await DBService(uid: user.uid).updateUserData(email,name);
			return _userFromFirebaseUser(user);
		} catch(e){
			print(e);
			return null;
		}
	}

	Future loginFB()async{
		final facebookLogin = FacebookLogin();
		//facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
		final result = await facebookLogin.logIn(['email']);
		switch (result.status) {
			case FacebookLoginStatus.loggedIn:
				print("Login Correct");
				break;
			case FacebookLoginStatus.cancelledByUser:
				print("Login cancelled by user");
				break;
			case FacebookLoginStatus.error:
				print(result.errorMessage);
				break;
		}

		final token = result.accessToken.token;
		final graphResponse = await http.get(
			'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
		final profile = json.decode(graphResponse.body);
		final facebookAuthCred = FacebookAuthProvider.getCredential(accessToken: token);
		final credential = await _auth.signInWithCredential(facebookAuthCred);
		User fuser = _userFromFirebaseUser(credential.user);
		await DBService(uid: fuser.uid).updateUserData(fuser.email, profile["name"]);
		return fuser;
	}

	Future signOut() async{
		try{
			return await _auth.signOut();
		}catch(e){
			print(e);
			return null;
		}
	}
}