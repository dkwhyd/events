import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future login(String email, String password) async {
    UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = authResult.user;

    return user!.uid;
  }

  Future signUp(String email, String password) async {
    UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = authResult.user;
    return user!.uid;
  }

  Future signOut() async {
    return _firebaseAuth.signOut();
  }

  Future getUser() async {
    User? user = _firebaseAuth.currentUser;
    return user;
  }
}
