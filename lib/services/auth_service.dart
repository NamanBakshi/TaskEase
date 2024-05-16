import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final _authInstance=FirebaseAuth.instance;
  
  Future<User?> signupUser(String name,String email,String password) async {
    try{
      // userData contains user data after user created
      final userData= await _authInstance.createUserWithEmailAndPassword(email: email, password: password);
      return userData.user;
    }catch(err){
      print('error occured in signupUser = $err');
    }
    return null;
  }


  Future<User?> loginUser(String email,String password) async {
    try{

      final userData= await  _authInstance.signInWithEmailAndPassword(email: email, password: password);
      return userData.user;
    }catch(err){
      print('error occured in signupUser = $err');
    }
    return null;
  }

  //firebase logs out current user
  Future<void> logoutUser() async {
      try{
        await _authInstance.signOut();
      }catch(err){
        print('err while logout = $err');
      }
  }

}