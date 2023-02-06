import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

class wsy {
  static const String appName = 'Window App';

  static SharedPreferences? sharedPreferences;
  static User? user;
  static FirebaseAuth? auth;
  static FirebaseFirestore? firestore;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'userCart';
  static String subCollectionAddress = 'userAddress';

  static const String userName = 'user';
  static const String userEmail = 'email';
  static const String gender = 'gender';
  static const String rating = 'rating';
  static const String phoneNumber = 'phoneNumber';
  static const String age = 'age';
  static const String userPhotoUrl = 'photoUrl';
  static const String userUID = 'uid';
  static const String userAvatarUrl = 'url';

  static const String addressID = 'addressID';
  static const String totalAmount = 'totalAmount';
  static const String productID = 'productIDs';
  static const String paymentDetails = 'paymentDetails';
  static const String orderTime = 'orderTime';
  static const String isSuccess = 'isSuccess';
}
