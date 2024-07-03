import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:thistle/appbar/appbar.dart';

class ThistleEditProfilePage extends StatelessWidget {
  const ThistleEditProfilePage({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThistleAppbar(title: 'Edit Profile'),
      body: Center(
        child: Text('Edit Profile for ${user!.email}'),
      ),
    );
  }
}