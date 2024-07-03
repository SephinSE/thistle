import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';
import 'package:thistle/app_state.dart';
import 'edit_profile.dart';

class ThistleProfilePage extends StatelessWidget {
  const ThistleProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String username = user!.email!.split('@')[0];
    String fullName = user.displayName.toString();

    void navigateToEditProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ThistleEditProfilePage(user: user)),
      );
    }

    return Scaffold(
      appBar: ThistleAppbar(title: username),
      drawer: MyDrawer(
        onEditProfileTap: navigateToEditProfile,
        onSignOutTap: Provider.of<ApplicationState>(context, listen: false).signOut,
      ),
      body: Center(
        child: Text('Welcome, $fullName!'),
      ),
      bottomNavigationBar: const ThistleNavBar(),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.onEditProfileTap, required this.onSignOutTap});

  final void Function()? onEditProfileTap;
  final void Function()? onSignOutTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF342E5B),
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              size: 64,
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_2_outlined,
              color: Colors.white,
            ),
            onTap: onEditProfileTap,
            title: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onTap: ()=>Navigator.pop(context),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onTap: onSignOutTap,
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
        ],
      ),
    );
  }
}