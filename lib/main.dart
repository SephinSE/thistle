import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'app_state.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'pages/chat.dart';
import 'pages/map.dart';
import 'pages/post.dart';
import 'pages/activity.dart';
import 'pages/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //GoogleFonts.config.allowRuntimeFetching = false;
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(ChangeNotifierProvider(
      create: (context) => ApplicationState(), // Create your ChangeNotifier
      builder: ((context, child) => const MyApp()),
    ),
  );
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MyHomePage();
            } else {
              return const ThistleAuthPage();
            }
          },
        );
      },
      routes: [
        GoRoute(
          path: 'chat',
          builder: (context, state) {
            return const ChatRoomPage();
          }
        ),
        GoRoute(
          path: 'map',
          builder: (context, state) {
            return const ThistleMapPage();
          }
        ),
        GoRoute(
          path: 'post',
          builder: (context, state) {
            return const ThistlePostPage();
          }
        ),
        GoRoute(
          path: 'activity',
          builder: (context, state) {
            return const ThistleActivityPage();
          }
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return const ThistleProfilePage();
          }
        ),
      ]
    )
  ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Thistle App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6a6dcd)),
        textTheme: GoogleFonts.robotoFlexTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}