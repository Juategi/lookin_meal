import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return Container(
			color: Colors.white,
			child: Center(
				child: SpinKitCircle(
					color: Color.fromRGBO(255, 110, 117, 0.8),
					size: 50.0,
				),
			),
		);
	}

}

class CircularLoading extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Center(
		  child: Row(
		  	mainAxisAlignment: MainAxisAlignment.center,
		  	children: <Widget>[
		  		CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>( Color.fromRGBO(255, 110, 117, 1),),),
		  	],
		  ),
		);
	}
}