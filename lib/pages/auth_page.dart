import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thistle/app_state.dart';
import 'styles.dart';

class ThistleAuthPage extends StatefulWidget {
  const ThistleAuthPage({super.key});

  @override
  State<ThistleAuthPage> createState() => _ThistleAuthPageState();
}

class _ThistleAuthPageState extends State<ThistleAuthPage> with TickerProviderStateMixin {
  String? errorMessage = ApplicationState().errorMessage;
  bool isLogin = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  final TextEditingController _controllerFullName = TextEditingController();
  bool _isRegistering = false;
  bool _isSigningIn = false;

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      await ApplicationState().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-credential') {
          errorMessage = 'Incorrect password!';
        } else {
          errorMessage = e.message;
        }
      });
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    setState(() {
      _isRegistering = true; // Disable button while registering
    });
    try {
      await ApplicationState().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        fullName: _controllerFullName.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if  (e.code == 'email-already-in-use') {
          errorMessage = 'Email is already registered! Please login instead.';
          return;
        } else {
          errorMessage = e.message;
        }
      });
    } finally {
      setState(() {
        _isRegistering = false;
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
    _controllerEmail.dispose();
    _controllerFullName.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final textStyle = AppStyles.textStyle;
    final formStyle = AppStyles.formStyle;
    final buttonStyle = AppStyles.buttonStyle;

    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth > 450 ? 600 : 45;

    Widget progressIndicator = AppStyles().progressIndicator;

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
                          key: _formKey,
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
                                        controller: _controllerFullName,
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
                                        controller: _controllerConfirmPassword,
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
                                    if (!isLogin && _controllerFullName.text.isEmpty) {
                                      setState(() {
                                        errorMessage = 'Full name field cannot be empty! Please try again.';
                                      });
                                      return;
                                    }
                                    if (_controllerPassword.text.isEmpty) {
                                      setState(() {
                                        errorMessage = 'Please provide a password and try again.';
                                      });
                                      return;
                                    }
                                    if (!isLogin && _controllerPassword.text != _controllerConfirmPassword.text) {
                                      setState(() {
                                        errorMessage = 'Passwords do not match! Please try again.';
                                      });
                                      return;
                                    }
                                    if (_formKey.currentState!.validate() && !_isRegistering) {
                                      isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();
                                    }
                                  },
                                  style: buttonStyle.copyWith(padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20))),
                                  child: _isRegistering || _isSigningIn ? progressIndicator : Text(isLogin ? 'sign in' : 'register'),
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
                                _controllerEmail.clear();
                                _controllerFullName.clear();
                                _controllerPassword.clear();
                                _controllerConfirmPassword.clear();
                                errorMessage = '';
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              }
                          ),
                        ]
                    )),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        errorMessage == '' ? '' : '$errorMessage',
                        textAlign: TextAlign.center,
                        style: textStyle.copyWith(
                          color: Colors.red,
                          fontSize: 13,
                        ),
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