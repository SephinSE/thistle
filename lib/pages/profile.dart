import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';
import 'package:thistle/app_state.dart';
import 'package:thistle/functions/pick_image.dart';
import 'package:thistle/functions/crop_image.dart';
import 'package:thistle/functions/upload_image.dart';
import 'package:thistle/pages/styles.dart';
import 'edit_profile.dart';

class ThistleProfilePage extends StatelessWidget {
  const ThistleProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String username = user!.email!.split('@')[0];
    String fullName = user.displayName.toString();
    String? photoURL = user.photoURL;

    void navigateToEditProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ThistleEditProfilePage()),
      );
    }

    return Scaffold(
      appBar: ThistleAppbar(title: username),
      drawer: MyDrawer(
        onEditProfileTap: navigateToEditProfile,
        onSignOutTap: Provider.of<ApplicationState>(context, listen: false).signOut,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Consumer<ApplicationState>(
            //   builder: (context, state, _) {
            //     if (photoURL != null) {
            //       return ClipRRect(
            //         borderRadius: BorderRadius.circular(75),
            //         child: Image.network(
            //           photoURL,
            //           width: 150,
            //           height: 150,
            //           fit: BoxFit.cover,
            //         ),
            //       );
            //     } else {
            //       return const Icon(Icons.person, size: 100);
            //     }
            //   },
            // ),
            FutureBuilder<User?>(
              future: Provider.of<ApplicationState>(context).authStateChanges.first,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text('Error loading user data'); // Handle errors
                }
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  final photoURL = user.photoURL;
                  if (photoURL != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.network(
                        photoURL,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    return const Icon(Icons.person, size: 100); // Default icon for no photoURL
                  }
                }
                // Display loading indicator while user data is being fetched
                return const CircularProgressIndicator(color: Colors.black,);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final image = await pickImage(context);
                if (image != null) {
                  final croppedImage = await cropImage(image);
                  final croppedXFile = XFile(croppedImage!.path);
                  final imageUrl = await uploadImage(croppedXFile);
                  await Provider.of<ApplicationState>(context, listen: false).updateUserProfile(imageUrl);
                  // Show success message or update UI (optional)
                }
              },
              style: AppStyles.buttonStyle.copyWith(padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20, horizontal: 20))),
              child: Text(
                photoURL!= null ? 'Change Profile Picture' : 'Upload Profile Picture',
                style: AppStyles.textStyle.copyWith(
                  color: Colors.white
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text('Welcome, $fullName!', style: AppStyles.textStyle,),
          ],
        ),
      ),
      bottomNavigationBar: const ThistleNavBar(),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.onEditProfileTap, required this.onSignOutTap});

  final void Function()? onEditProfileTap;
  final void Function()? onSignOutTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF342E5B),
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              size: 64,
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_2_outlined,
              color: Colors.white,
            ),
            onTap: onEditProfileTap,
            title: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onTap: ()=>Navigator.pop(context),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onTap: onSignOutTap,
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
        ],
      ),
    );
  }
}