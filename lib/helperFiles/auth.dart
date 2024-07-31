import 'package:firebase_auth/firebase_auth.dart';

class Auth{

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
    );
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
}