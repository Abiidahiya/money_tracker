import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
        final User user = userCredential.user!;



        await _ensureUserInFirestore(user);

        emit(Authenticated(user));
        add(CheckAuthStatus());
      } else {

        emit(Unauthenticated());
      }
    } catch (e) {

      emit(AuthError(e.toString()));
    }
  }

  Future<void> _ensureUserInFirestore(User user) async {
    final DocumentReference userDoc =
    _firestore.collection('users').doc(user.uid);
    final DocumentSnapshot userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      print("🆕 User not found in Firestore. Creating new entry...");
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'created_at': FieldValue.serverTimestamp(),
      });
    } else {

    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    emit(Unauthenticated());
    add(CheckAuthStatus());
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print("🔄 Checking authentication status...");
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _ensureUserInFirestore(user); // ✅ Ensure Firestore entry
        emit(Authenticated(user));
      } else {

        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}