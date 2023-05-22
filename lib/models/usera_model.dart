import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? name;
  final String? email;
  final String? photoURL;

  UserModel({this.name, this.email, this.photoURL});

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    String? name = firebaseUser.providerData[0].displayName;
    String? email = firebaseUser.providerData[0].email;
    String? photoURL = firebaseUser.providerData[0].photoURL;
    UserModel userModel =
        UserModel(name: name, email: email, photoURL: photoURL);
    return userModel;
  }
}
