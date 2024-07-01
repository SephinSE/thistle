import 'package:provider/provider.dart';

import 'authentication.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'package:flutter/material.dart';


// class ApplicationState extends StatefulWidget {
//   const ApplicationState({super.key});
//
//   @override
//   State<ApplicationState> createState() => _ApplicationStateState();
// }
//
// class _ApplicationStateState extends State<ApplicationState> {
//   final TextEditingController _controllerFullName = TextEditingController();
//   TextEditingController get controllerFullName => _controllerFullName;
//   String get fullName => _controllerFullName.text;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: Auth().authStateChanges,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return MyHomePage();
//         } else {
//           return const ThistleAuthPage();
//         }
//       },
//     );
//   }
// }

class ApplicationState extends ChangeNotifier {
  final TextEditingController _controllerFullName = TextEditingController();
  TextEditingController get controllerFullName => _controllerFullName;
  String get fullName => _controllerFullName.text;
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();

    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHomePage(fullName: appState.fullName);
        } else {
          return const ThistleAuthPage();
        }
      },
    );
  }
}