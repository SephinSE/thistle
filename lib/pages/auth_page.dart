import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authentication.dart';

class ThistleAuthPage extends StatefulWidget {
  const ThistleAuthPage({super.key});

  @override
  State<ThistleAuthPage> createState() => _ThistleAuthPageState();
}

class _ThistleAuthPageState extends State<ThistleAuthPage> with TickerProviderStateMixin {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }


  late final AnimationController _controller = AnimationController(
    vsync: this, // Use a TickerProviderStateMixin for vsync
    duration: const Duration(seconds: 3), //Adjust the duration of one rotation
  );

  @override
  void initState() {
    super.initState();
    _controller.repeat();
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
    const textStyle = TextStyle(
      fontFamily: 'Roboto Flex',
      fontWeight: FontWeight.w400,
      color: Color(0xFF3D2E5B),
      fontSize: 17,
    );
    final formStyle = InputDecoration(
      fillColor: const Color(0x3A1C102C),
      filled: true,
      hintStyle: textStyle.copyWith(
        fontSize: 20,
        color: const Color(0xB82B1A4E),
      ),
      floatingLabelStyle: textStyle.copyWith(
        fontSize: 20,
        color: const Color(0xB82B1A4E),
        height: 100
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 24
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(22),
      ),
    );
    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF2B1A4E)),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      textStyle: WidgetStateProperty.all<TextStyle>(textStyle.copyWith(
        fontSize: 19,
      )),
      padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))
    );
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth > 450 ? 600 : 45;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: SvgPicture.asset(
                'assets/authBG.svg',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: padding, bottom: 15),
                        child: Text(
                          isLogin ? 'sign in' : 'register',
                          style: const TextStyle(
                            fontFamily: 'Roboto Flex',
                            color: Color(0xFF3A2C59),
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'thistle',
                          style: TextStyle(
                            fontFamily: 'Roboto Flex',
                            color: Color(0xFF3A2C59),
                            fontSize: 58,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 18),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _controller.value * 2 * pi,
                              child: SvgPicture.asset(
                                'assets/thistleLOGO.svg',
                                width: 56,
                                height: 56,
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(padding, 4, padding, 12),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 8,
                                    sigmaY: 8,
                                  ),
                                  child: TextFormField(
                                    controller: _controllerEmail,
                                    decoration: formStyle.copyWith(hintText: 'email'),
                                    style: textStyle.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xC82B1A4E),
                                    ),
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                  ),

                                ),
                              ),
                            ),
                            Padding(
                              padding: isLogin ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20),
                              child: Visibility(
                                visible: !isLogin,
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 8,
                                      sigmaY: 8,
                                    ),
                                    child: TextFormField(
                                      decoration: formStyle.copyWith(hintText: 'full name'),
                                      style: textStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xC82B1A4E),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: isLogin ? const EdgeInsets.only(bottom: 24) : const EdgeInsets.only(bottom: 20),
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 8,
                                    sigmaY: 8,
                                  ),
                                  child: TextFormField(
                                    controller: _controllerPassword,
                                    decoration: formStyle.copyWith(hintText: 'password'),
                                    obscureText: true,
                                    style: textStyle.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xC82B1A4E),
                                    ),
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: isLogin ? EdgeInsets.zero : const EdgeInsets.only(bottom: 24),
                              child: Visibility(
                                visible: !isLogin,
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 8,
                                      sigmaY: 8,
                                    ),
                                    child: TextFormField(
                                      decoration: formStyle.copyWith(hintText: 'confirm password'),
                                      obscureText: true,
                                      style: textStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xC82B1A4E),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  //context.push('/home');
                                  isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();
                                },
                                style: buttonStyle,
                                child: Text(isLogin ? 'sign in' : 'register')
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                    RichText(text: TextSpan(
                      style: textStyle.copyWith(fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: isLogin ? 'Not an existing user? Register ' : 'Already have an account? Sign in '
                        ),
                        TextSpan(
                          text: 'here.',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          }
                        ),
                      ]
                    )),
                    const SizedBox(height: 30),
                    Text(
                      errorMessage == '' ? '' : 'Hmmm ? $errorMessage',
                      style: const TextStyle(
                        color: Colors.red
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}