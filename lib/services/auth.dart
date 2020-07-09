import 'package:firebase_auth/firebase_auth.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/database.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lookinmeal/shared/strings.dart';

class AuthService{

	final FirebaseAuth _auth = FirebaseAuth.instance;

	User _userFromFirebaseUser(FirebaseUser user){
		return user != null ? User(uid: user.uid, email: user.email) : null;
	}

	Stream<String> get user {
		return _auth.onAuthStateChanged.map((user){
			return user != null ? user.uid : null;
		});
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
			await DBService().createUser(user.uid,email,name,StaticStrings.defaultImage,"EP");
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
			'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=$token');
		final profile = json.decode(graphResponse.body);
		final facebookAuthCred = FacebookAuthProvider.getCredential(accessToken: token);
		final credential = await _auth.signInWithCredential(facebookAuthCred);
		String picture = profile["picture"]["data"]["url"];
		User finalUser = await DBService().getUserDataChecker(credential.user.uid);
		if(finalUser == null) {
			await DBService().createUser(credential.user.uid,credential.user.email, profile["name"],picture,"FB");
			return _userFromFirebaseUser(credential.user);
		}
		else{
			await DBService().updateUserData(credential.user.uid,credential.user.email, profile["name"],picture,"FB");
			return _userFromFirebaseUser(credential.user);
		}

	}

	Future loginGoogle()async{
		final GoogleSignIn googleSignIn = GoogleSignIn(
			scopes: [
				'email',
				'https://www.googleapis.com/auth/userinfo.profile',
			],
		);
		final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
		final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

		final AuthCredential credential = GoogleAuthProvider.getCredential(
			accessToken: googleSignInAuthentication.accessToken,
			idToken: googleSignInAuthentication.idToken,
		);

		final AuthResult authResult = await _auth.signInWithCredential(credential);
		final FirebaseUser user = authResult.user;
		assert(!user.isAnonymous);
		assert(await user.getIdToken() != null);
		final FirebaseUser currentUser = await _auth.currentUser();
		assert(user.uid == currentUser.uid);
		User finalUser = await DBService().getUserDataChecker(user.uid);
		if(finalUser == null) {
			await DBService().createUser(
					user.uid, user.email, authResult.additionalUserInfo.profile['name'],
					authResult.additionalUserInfo.profile['picture'], "GM");
			return _userFromFirebaseUser(user);
		}
		else{
			await DBService().updateUserData(
					user.uid, user.email, authResult.additionalUserInfo.profile['name'],
					authResult.additionalUserInfo.profile['picture'], "GM");
			return _userFromFirebaseUser(user);
		}
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