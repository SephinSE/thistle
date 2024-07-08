import 'dart:async';
import 'package:flutter/material.dart';

import 'styles.dart';
import '../classes/guest_book_message.dart';

class GuestBook extends StatefulWidget {
  const GuestBook({
    super.key,
    required this.addMessage,
    required this.messages,
  });

  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages;

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final buttonStyle = AppStyles.buttonStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var message in widget.messages)
          Text('${message.name}: ${message.message}'),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 18),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  style: buttonStyle,
                  child: const Row(
                    children: [
                      Icon(Icons.send, size: 18,),
                      SizedBox(width: 8),
                      Text('send', style: TextStyle(fontSize: 18),),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}