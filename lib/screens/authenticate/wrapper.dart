import 'package:flutter/material.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'authenticate.dart';
import 'package:lookinmeal/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:lookinmeal/models/user.dart';


class Wrapper extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

		final user = Provider.of<String>(context);
		if(user == null)
			return Authenticate();
		else
			return FutureProvider<User>.value(
					value: DBServiceUser.dbServiceUser.getUserData(user),
					catchError: (_, __) => null,
					child: Home()
			);
	}
}