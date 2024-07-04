import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:thistle/appbar/appbar.dart';
import 'guest_book.dart';
import 'package:thistle/app_state.dart';
import 'styles.dart';


class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThistleAppbar(
        title: 'Chat Room',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<ApplicationState>(
            builder: (context, appState, _) => SingleChildScrollView(
              child: Column(
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
          ),
        ),
      ),
    );
  }
}