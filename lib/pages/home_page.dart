import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thistle/authentication.dart';

import '../appbar/appbar.dart';
import 'auth_page.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({
    super.key,
    required this.fullName
  });

  final String fullName;
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontFamily: 'Roboto Flex',
      fontWeight: FontWeight.w400,
      color: Color(0xFF3D2E5B),
      fontSize: 17,
    );
    final buttonStyle = ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF2B1A4E)),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        textStyle: WidgetStateProperty.all<TextStyle>(textStyle.copyWith(
          fontSize: 19,
        )),
        padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))
    );

    return Scaffold(
      appBar: const ThistleAppbar(title: 'Thistle Home'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Hi, $fullName' ?? 'User Email'),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: signOut,
                style: buttonStyle,
                child: const Text('sign out')
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
