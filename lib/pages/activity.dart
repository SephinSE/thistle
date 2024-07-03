import 'package:flutter/material.dart';
import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';

class ThistleActivityPage extends StatelessWidget {
  const ThistleActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ThistleAppbar(title: 'Activity',),
      body: Center(child: Text('you have zero friends why are you on this app'),),
      bottomNavigationBar: ThistleNavBar(),
    );
  }
}