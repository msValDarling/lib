import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/usera_model.dart';

class FacebookAuthentication {
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> signInWithFacebook() async {
    this.signOut();
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        UserModel userModel = UserModel.fromFirebaseUser(userCredential.user!);
        return userModel;
      } else {
        return UserModel(name: null);
      }
    } catch (e) {
      return UserModel(name: null);
    }
  }

  Future<int> signUpWithFacebook() async {
    this.signOut();
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);
        final UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: accessToken.userId + '@facebook.com',
                password: accessToken.token);
        await userCredential.user!.linkWithCredential(credential);
        return 1;
      } else {
        return 3;
      }
    } catch (e) {
      if (e.toString().contains('already')) {
        return 2;
      } else {
        return 3;
      }
    }
  }

  Future<bool> signOut() async {
    try {
      await _facebookAuth.logOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
