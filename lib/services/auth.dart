import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lookinmeal/models/user.dart' as u;
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/strings.dart';

import 'geolocation.dart';

class AuthService{

	final FirebaseAuth _auth = FirebaseAuth.instance;

	u.User _userFromFirebaseUser(f.User user){
		return user != null ? u.User(uid: user.uid, email: user.email) : null;
	}

	Stream<String> get user {
		return _auth.authStateChanges().map((user){
			return user != null ? user.uid : null;
		});
	}

	Future signInEP(String email, String password) async{
		try{
			f.UserCredential result =	await _auth.signInWithEmailAndPassword(email: email, password: password);
			f.User user = result.user;
			return _userFromFirebaseUser(user);
		} catch(e){
			print(e);
			return null;
		}
	}

	Future registerEP(String email, String password, String name, String country, String username) async{
		try{
			f.UserCredential result =	await _auth.createUserWithEmailAndPassword(email: email, password: password);
			f.User user = result.user;
			await DBServiceUser.dbServiceUser.createUser(user.uid,email,name,StaticStrings.defaultImage,"EP", country, username);
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
				Uri(path:'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=$token'));
		final profile = json.decode(graphResponse.body);
		final facebookAuthCred = FacebookAuthProvider.credential(token);
		final credential = await _auth.signInWithCredential(facebookAuthCred);
		String picture = profile["picture"]["data"]["url"];
		u.User finalUser = await DBServiceUser.dbServiceUser.getUserDataChecker(credential.user.uid);
		if(finalUser == null) {
			while(true){
				String username = profile["first_name"].toString().trim() + profile["last_name"].toString().trim() + (Random().nextInt(10000).toString());
				if(await DBServiceUser.dbServiceUser.checkUsername(username)){
					username = profile["first_name"].toString().trim() + profile["last_name"].toString().trim() + (Random().nextInt(10000).toString());
				}
				else{
					await DBServiceUser.dbServiceUser.createUser(credential.user.uid,credential.user.email, profile["name"],picture,"FB", await GeolocationService().getCountry(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude), username);
					return _userFromFirebaseUser(credential.user);
				}
			}
		}
		else{
			//await DBServiceUser.dbServiceUser.updateUserData(credential.user.uid, credential.user.email, profile["name"],picture,"FB");
			await DBServiceUser.dbServiceUser.updateUserData(credential.user.uid, finalUser.name, finalUser.about, finalUser.picture, "FB", finalUser.country, finalUser.username);
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

		final AuthCredential credential = GoogleAuthProvider.credential(
			accessToken: googleSignInAuthentication.accessToken,
			idToken: googleSignInAuthentication.idToken,
		);

		final f.UserCredential authResult = await _auth.signInWithCredential(credential);
		final f.User user = authResult.user;
		assert(!user.isAnonymous);
		assert(await user.getIdToken() != null);
		final f.User currentUser = await _auth.currentUser;
		assert(user.uid == currentUser.uid);
		u.User finalUser = await DBServiceUser.dbServiceUser.getUserDataChecker(user.uid);
		if(finalUser == null) {
			while(true){
				String username = authResult.additionalUserInfo.profile['given_name'].toString().trim() + authResult.additionalUserInfo.profile['family_name'].toString().trim() + (Random().nextInt(10000).toString());
				if(await DBServiceUser.dbServiceUser.checkUsername(username)){
					username = authResult.additionalUserInfo.profile['given_name'].toString().trim() + authResult.additionalUserInfo.profile['family_name'].toString().trim() + (Random().nextInt(10000).toString());
				}
				else {
					await DBServiceUser.dbServiceUser.createUser(
							user.uid, user.email, authResult.additionalUserInfo.profile['name'],
							authResult.additionalUserInfo.profile['picture'], "GM", await GeolocationService().getCountry(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude), username);
					return _userFromFirebaseUser(user);
				}
			}
		}
		else{
			//await DBServiceUser.dbServiceUser.updateUserData(user.uid, user.email, authResult.additionalUserInfo.profile['name'], authResult.additionalUserInfo.profile['picture'], "GM");
			await DBServiceUser.dbServiceUser.updateUserData(user.uid, finalUser.name, finalUser.about, finalUser.picture, "GM", finalUser.country, finalUser.username);
			return _userFromFirebaseUser(user);
		}
	}

	void reBirth(BuildContext context){
		DBServiceUser.userF = null;
		Phoenix.rebirth(context);
	}

	Future signOut() async{
		DBServiceUser.userF = null;
		//Pool.ids.clear();
		Pool.restaurants.clear();
		try{
			final facebookLogin = FacebookLogin();
			facebookLogin.logOut();
		}catch(e){
			print(e);
			//return null;
		}
		try{
			final GoogleSignIn googleSignIn = GoogleSignIn(
				scopes: [
					'email',
					'https://www.googleapis.com/auth/userinfo.profile',
				],
			);
			await googleSignIn.signOut();
		}catch(e){
			print(e);
			//return null;
		}
		try{
			return await _auth.signOut();
		}catch(e){
			print(e);
			//return null;
		}
		return null;
	}

}