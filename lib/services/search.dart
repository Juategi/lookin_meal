import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';

class SearchService{
  final CollectionReference userCollection = Firestore.instance.collection('menus');
  
}