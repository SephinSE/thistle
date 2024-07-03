import 'package:flutter/material.dart';
import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';

class ThistleProfilePage extends StatelessWidget {
  const ThistleProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ThistleAppbar(title: 'Profile',),
      body: Center(child: Text('blank profile page'),),
      bottomNavigationBar: ThistleNavBar(),
    );
  }
}