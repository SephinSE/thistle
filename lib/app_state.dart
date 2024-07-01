import 'authentication.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'package:flutter/material.dart';


class ApplicationState extends StatefulWidget {
  const ApplicationState({super.key});

  @override
  State<ApplicationState> createState() => _ApplicationStateState();
}

class _ApplicationStateState extends State<ApplicationState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHomePage(title: 'Thistle Home');
        } else {
          return const ThistleAuthPage();
        }
      },
    );
  }
}