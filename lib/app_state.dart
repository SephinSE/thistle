import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'pages/guest_book_message.dart';


class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? errorMessage = '';

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _isSigningOut = false;
  bool get isSigningOut => _isSigningOut;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void onNavBarTap(index) {
    _selectedIndex = index;
    notifyListeners();
  }

  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  Future<void> init() async {

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _guestBookMessages = [];
          for (final document in snapshot.docs) {
            final name = document.data()['name'] as String?;
            final message = document.data()['text'] as String?;

            if (name != null && message != null) {
              _guestBookMessages.add(
                GuestBookMessage(
                  name: name,
                  message: message,
                ),
              );
            }
            // else {
            //   print('Warning: Null name or message encountered in Firestore document');
            // }
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(fullName);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isSigningOut = true;
    _selectedIndex = 0;
    notifyListeners();
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    } finally {
      _isSigningOut = false;
      notifyListeners();
    }
  }

  Future<DocumentReference> addMessageToGuestBook(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

}