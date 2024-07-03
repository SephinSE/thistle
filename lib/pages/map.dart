import 'package:flutter/material.dart';
import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';

class ThistleMapPage extends StatelessWidget {
  const ThistleMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ThistleAppbar(title: 'Map',),
      body: Center(child: Text('blank maps page'),),
      bottomNavigationBar: ThistleNavBar(),
    );
  }
}