import 'package:flutter/material.dart';
import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';

class ThistlePostPage extends StatelessWidget {
  const ThistlePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ThistleAppbar(title: 'Post',),
      body: Center(child: Text('lol you\'re never gonna post'),),
      bottomNavigationBar: ThistleNavBar(),
    );
  }
}