import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    vsync: this, // Use a TickerProviderStateMixin for vsync
    duration: const Duration(seconds: 3), //Adjust the duration of one rotation
  );

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.repeat();
    _navigateToNextScreen();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();// Add this line
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * pi,
                    child: SvgPicture.asset(
                      'assets/thistleLOGO.svg',
                      width: 120,
                      height: 120,
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}