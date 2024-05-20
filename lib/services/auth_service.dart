import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/services/firestore.dart';

class AuthService {

  final _authInstance = FirebaseAuth.instance;

  Future<bool> signupUser(String email, String password) async {
    try {
      // userData contains user data after user created
      final userData = await _authInstance.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userData.user;
      print('userData.user = $user');

      if (user != null) {
        return Firestore().CreateUser(user.uid, email);
      }
      return false;
    } catch (err) {
      print('error occured in signupUser = $err');
      return false;
    }
  }


  Future<bool> loginUser(String email, String password) async {
    try {
      final userData = await _authInstance
          .signInWithEmailAndPassword(email: email, password: password);
      print('loggedin user data = $userData');
      if (userData.user != null) {
        return true;
      }
      return false;
      //return userData.user;
    } catch (err) {
      print('error occured in signupUser = $err');
      return false;
    }
  }

  //firebase logs out current user
  Future<bool> logoutUser() async {
    try {
      await _authInstance.signOut();

      if(_authInstance.currentUser?.uid == null) {
        print('user logged out successfully ');
        return true;
      }else {
        return false;
      }
    } catch (err) {
      print('err while logout = $err');
      return false;
    }
  }

}