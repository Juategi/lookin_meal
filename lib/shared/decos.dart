import 'package:flutter/material.dart';

var textInputDeco = InputDecoration(
	filled: true,
	focusedBorder: OutlineInputBorder(
			borderSide: BorderSide(color: Colors.white, width: 1),
			borderRadius: BorderRadius.circular(20)
	),
	enabledBorder: OutlineInputBorder(
			borderSide: BorderSide(color: Colors.white, width: 1),
			borderRadius: BorderRadius.circular(20)
	),
	errorBorder: OutlineInputBorder(
			borderSide: BorderSide(color: Colors.white, width: 1),
			borderRadius: BorderRadius.circular(20)
	),
	focusedErrorBorder: OutlineInputBorder(
			borderSide: BorderSide(color: Colors.white, width: 1),
			borderRadius: BorderRadius.circular(20)
	)
);

