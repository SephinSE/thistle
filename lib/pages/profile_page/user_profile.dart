import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thistle/pages/home_page.dart';
import 'package:thistle/pages/profile_page/drawer.dart';
import 'package:thistle/pages/profile_page/edit_profile.dart';
import 'package:thistle/pages/auth_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user; // Store the current user
  String? username;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Function to navigate to the edit profile page
  void navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(user: _user)),
    );
  }

  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  Future<void> signOutAndNavigateToLogin() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ThistleAuthPage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Handle any errors here
      print('Error signing out: $e');
    }
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
        username = user.email?.split('@')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username ?? 'Anonymous'),
      ),
      drawer: MyDrawer(
        onEditProfileTap: navigateToEditProfile,
        onHomeTap: navigateToHomePage,
        onSignOutTap: signOutAndNavigateToLogin,
      ),
      body: _user == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Center(
        child: Text('Welcome, ${username ?? 'Anonymous'}!'),
      ),
    );
  }
}
