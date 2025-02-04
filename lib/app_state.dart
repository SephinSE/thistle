import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'classes/guest_book_message.dart';
import 'classes/user_profile_class.dart';
import 'functions/get_department.dart';

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

  StreamSubscription<DocumentSnapshot>? _userSubscription;
  UserProfileClass? _userProfile;
  UserProfileClass? get userProfile => _userProfile;

  void updateUserProfileClass(UserProfileClass newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }

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
          }
          notifyListeners();
        });

        _userSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          final userData = snapshot.data() as Map<String, dynamic>;
          final username = userData['username'];
          final photoURL = userData['photoURL'];
          final friendsCount = userData['friendsCount'];
          final thistleCount = userData['thistleCount'];
          final fullName = userData['displayName'];
          final departmentID = userData['departmentID'];
          final department = getDepartment(departmentID);
          final bio = userData['bio'];

          if (friendsCount != null && thistleCount != null && fullName != null && departmentID != null && bio != null) {
            updateUserProfileClass(
                UserProfileClass(
                    username: username,
                    photoURL: photoURL,
                    friendsCount: friendsCount,
                    thistleCount: thistleCount,
                    fullName: fullName,
                    department: department,
                    departmentID: departmentID,
                    bio: bio
                )
            );
            notifyListeners();
          }
        });

      } else {
        _loggedIn = false;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
        _userSubscription?.cancel();
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
      final uid = credential.user!.uid;
      final userData = {
        'email' : email,
        'displayName' : fullName,
        'uid' : credential.user!.uid,
        'username' : credential.user!.email!.split('@')[0],
        'timestamp' : DateTime.now().millisecondsSinceEpoch,
        'bio' : '',
        'friendsCount' : 0,
        'thistleCount' : 0,
        'departmentID' : 0,
        'photoURL' : 'https://firebasestorage.googleapis.com/v0/b/gift-of-the-thistle.appspot.com/o/profile_pictures%2Fdefault.png?alt=media&token=cf7e3d32-010e-488f-ba01-783aff1576f8',
      };
      await credential.user!.updateDisplayName(fullName);
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData)
          .onError((e, _) => print("Error writing document: $e"));
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

  Future<void> updateUserProfile(String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(<String, String>{
            'photoURL' : imageUrl
      }, SetOptions(merge: true));
    }
    notifyListeners(); // Now called after update is complete
  }


}