import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../appbar/appbar.dart';
import '../app_state.dart';
import 'styles.dart';
import 'guest_book.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({
    super.key,
  });

  final String? fullName = FirebaseAuth.instance.currentUser?.displayName;

  Future<void> signOut() async {
    await ApplicationState().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThistleAppbar(title: 'Thistle Home'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Text('Hi, $fullName', style: AppStyles.textStyle),
                  const SizedBox(height: 10),
                  Consumer<ApplicationState>(
                    builder: (context, appState, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (appState.loggedIn) ...[
                          Text('Leave a message [redacted]', style: AppStyles.textStyle),
                          const SizedBox(height: 20),
                          GuestBook(
                            addMessage: (message) =>
                              appState.addMessageToGuestBook(message),
                            messages: appState.guestBookMessages,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: signOut,
                  style: AppStyles.buttonStyle,
                  child: const Text('sign out')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
