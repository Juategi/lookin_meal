import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return Container(
			color: Colors.brown[100],
			child: Center(
				child: SpinKitChasingDots(
					color: Colors.brown,
					size: 50.0,
				),
			),
		);
	}

}

class CircularLoading extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: <Widget>[
				CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(255, 65, 112, 1)),),
			],
		);
	}
}