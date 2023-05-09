import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences ;
FirebaseAuth firebaseAuth = FirebaseAuth.instance ;
String completeAddress = '';
Position? position;
List<Placemark>? placeMarks;

String perParcelDeliveryAmount = '';
String previousEarnings = '';
String previousSellerEarnings = '';