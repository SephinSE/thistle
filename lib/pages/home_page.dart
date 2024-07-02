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
  final String? errorMessage = ApplicationState().errorMessage;

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator = AppStyles().progressIndicator;

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
                          Text('Let\'s message niggas', style: AppStyles.textStyle),
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
                  onPressed: ApplicationState().signOut,
                  style: AppStyles.buttonStyle.copyWith(padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30, vertical: 15))),
                  child: ApplicationState().isSigningOut ? progressIndicator : const Text('sign out')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
