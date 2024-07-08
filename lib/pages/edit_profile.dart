import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/functions/get_department.dart';
import 'package:thistle/pages/styles.dart';
import '../app_state.dart';

class ThistleEditProfilePage extends StatefulWidget {
  const ThistleEditProfilePage({super.key});

  @override
  State<ThistleEditProfilePage> createState() => _ThistleEditProfilePageState();
}

class _ThistleEditProfilePageState extends State<ThistleEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  TextEditingController _controllerDepartment = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = Provider.of<ApplicationState>(context, listen: false).userProfile;
      if (userProfile != null) {
        setState(() {
          selectedValue = userProfile.department;
          _controllerDepartment.text = userProfile.department; // Update controller as well
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ApplicationState>(context).currentUser;
    final textStyle = AppStyles.textStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w400);

    return Consumer<ApplicationState>(
      builder: (context, appState, child) {
        final userProfile = appState.userProfile;
        if (user != null && userProfile != null) {
          String username = userProfile.username;
          String fullName = userProfile.fullName;
          String bio = userProfile.bio;
          int departmentID = userProfile.departmentID;
          String department = userProfile.department;
          final TextEditingController _controllerFullName = TextEditingController(text: fullName);
          final TextEditingController _controllerUsername = TextEditingController(text: username);
          _controllerDepartment = TextEditingController(text: department);
          final TextEditingController _controllerBio = TextEditingController(text: bio);
          final List<String> options = [
            'Select department',
            'BTech Civil, School of Engineering',
            'BTech CS, School of Engineering',
            'BTech EC, School of Engineering',
            'BTech EEE, School of Engineering',
            'BTech IT, School of Engineering',
            'BTech Mech, School of Engineering',
            'BTech Safety, School of Engineering',
          ];

          return Scaffold(
              appBar: const ThistleAppbar(title: 'Edit Profile'),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Full name: ', style: textStyle),
                            SizedBox(
                              width: 260,
                              child: TextFormField(
                                controller: _controllerFullName,
                                style: textStyle,
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).colorScheme.surfaceBright,
                                  filled: true,
                                  labelStyle: textStyle,
                                  hintStyle: textStyle.copyWith(
                                    fontSize: 18,
                                    color: const Color(0xB82B1A4E),
                                  ),
                                  floatingLabelStyle: textStyle.copyWith(
                                      fontSize: 20,
                                      color: const Color(0xB82B1A4E),
                                      height: 100
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppStyles.thistleColor, width: 30.0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Username: ', style: textStyle),
                            SizedBox(
                              width: 260,
                              child: TextFormField(
                                controller: _controllerUsername,
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: '',
                                  hintStyle: textStyle,
                                  floatingLabelStyle: textStyle.copyWith(
                                      fontSize: 20,
                                      color: const Color(0xB82B1A4E),
                                      height: 100
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppStyles.thistleColor, width: 30.0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                style: textStyle,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Department: ', style: textStyle),
                            DropdownMenu<String>(
                              width: 260,
                              initialSelection: selectedValue,
                              textStyle: textStyle,
                              inputDecorationTheme: InputDecorationTheme(
                                fillColor: AppStyles.onThistleColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppStyles.thistleColor, width: 2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onSelected: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue;
                                  _controllerDepartment.text = newValue!;
                                });
                              },
                              dropdownMenuEntries: options.map((String option) {
                                return DropdownMenuEntry(value: option, label: option);
                              }).toList(),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Bio: ', style: textStyle),
                            SizedBox(
                              width: 260,
                              child: TextFormField(
                                controller: _controllerBio,
                                maxLines: null,
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).colorScheme.surfaceBright,
                                  filled: true,
                                  hintText: '',
                                  hintStyle: textStyle,
                                  floatingLabelStyle: textStyle.copyWith(
                                      fontSize: 20,
                                      color: const Color(0xB82B1A4E),
                                      height: 100
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppStyles.thistleColor, width: 30.0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                style: textStyle,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF2B1A4E)),
                                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                textStyle: WidgetStateProperty.all<TextStyle>(textStyle.copyWith(
                                  fontSize: 18,
                                )),
                                padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
                                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                            ),
                            onPressed: () {
                              print(selectedValue);
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .set(<String, dynamic>{
                                'displayName' : _controllerFullName.text,
                                'username' : _controllerUsername.text,
                                'departmentID' : getDepartmentID(selectedValue!),
                                'bio' : _controllerBio.text,
                              }, SetOptions(merge: true));
                            },
                            child: const Text('Update Profile'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          );
        }
        if (userProfile == null) {
          return const CircularProgressIndicator(color: Colors.black); // or some loading widget
        }
        if (user == null) {
          return const Scaffold(
            appBar: ThistleAppbar(title: 'user'),
            body: SizedBox(height: double.infinity, width: double.infinity),
          );
        }
        return const CircularProgressIndicator(color: Colors.black);
      },
    );
  }
}