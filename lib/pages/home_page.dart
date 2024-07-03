import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../appbar/appbar.dart';
import '../appbar/navbar.dart';
import '../app_state.dart';
import 'styles.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator = AppStyles().progressIndicator;
    final String fullName = FirebaseAuth.instance.currentUser!.displayName ?? 'user';

    return Scaffold(
      appBar: ThistleAppbar(
        title: 'Thistle Home',
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () {
              context.go('/chat');
            },
            icon: Icon(
              Icons.chat,
              color: AppStyles.thistleColor,
              size: 30,
            )
          ),
        ]
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    'Hi, $fullName',
                    style: AppStyles.textStyle,
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: ApplicationState().signOut,
                  style: AppStyles.buttonStyle.copyWith(padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30, vertical: 15))),
                  child: ApplicationState().isSigningOut ? progressIndicator : const Text('sign out')
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ThistleNavBar(),
    );
  }
}
