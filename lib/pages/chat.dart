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
        title: 'CUSAT Forum',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),child: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            // Expanded to push content to bottom
            Expanded(child: Container()),

            // GuestBook wrapped in SingleChildScrollView
            SingleChildScrollView(
              reverse: true, // For upward scrolling
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (appState.loggedIn) ...[
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
      ),
      ),
    );
  }
}