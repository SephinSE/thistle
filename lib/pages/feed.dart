import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';
import 'styles.dart';

class ThistleFeedPage extends StatefulWidget {
  const ThistleFeedPage({super.key});

  @override
  State<ThistleFeedPage> createState() => _ThistleFeedPageState();
}

class _ThistleFeedPageState extends State<ThistleFeedPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThistleAppbar(
        title: 'Feed',
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
      body: const Center(child: Text('wow, such empty'),),
      bottomNavigationBar: const ThistleNavBar(),
    );
  }
}