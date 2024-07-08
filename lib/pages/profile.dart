import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';
import 'package:thistle/app_state.dart';
import 'package:thistle/functions/get_department.dart';
import 'package:thistle/functions/pick_image.dart';
import 'package:thistle/functions/crop_image.dart';
import 'package:thistle/functions/upload_image.dart';
import 'package:thistle/pages/friends.dart';
import 'package:thistle/pages/styles.dart';
import 'current_user_activity.dart';
import 'edit_profile.dart';
import 'user_avatar.dart';

class ThistleProfilePage extends StatefulWidget {
  const ThistleProfilePage({super.key});

  @override
  State<ThistleProfilePage> createState() => _ThistleProfilePageState();
}

class _ThistleProfilePageState extends State<ThistleProfilePage> {

  Future<void> changeProfileImage(BuildContext context) async {
    final image = await pickImage(context);
    if (image != null) {
      final croppedImage = await cropImage(image, context);
      final croppedXFile = XFile(croppedImage!.path);
      final imageUrl = await uploadImage(croppedXFile);
      await Provider.of<ApplicationState>(context, listen: false).updateUserProfile(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ApplicationState>(context).currentUser;

    void navigateToEditProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ThistleEditProfilePage()),
      );
    }
    void navigateToUserActivity() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ThistleCurrentUserActivityPage()),
      );
    }
    void navigateToFriendsPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ThistleFriendsPage()),
      );
    }

    return Consumer<ApplicationState>(
        builder: (context, appState, child) {
          final userProfile = appState.userProfile;
          if (user != null && userProfile != null) {
            String username = userProfile.username;
            String fullName = userProfile.fullName;
            String bio = userProfile.bio;
            int friendsCount = userProfile.friendsCount;
            int thistleCount = userProfile.thistleCount;
            int departmentID = userProfile.departmentID;
            String? photoURL = userProfile.photoURL;

            return Scaffold(
              appBar: ThistleAppbar(title: username),
              endDrawer: MyDrawer(
                onSignOutTap: Provider.of<ApplicationState>(context, listen: false).signOut,
                onActivityTap: navigateToUserActivity,
                onSettingsTap: navigateToEditProfile,
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UserAvatar(changeProfileImage: changeProfileImage, providerImage: CachedNetworkImageProvider(photoURL!)),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(friendsCount.toString(), style: AppStyles.textStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w600)),
                                  Text('friends', style: AppStyles.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(thistleCount.toString(), style: AppStyles.textStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w600)),
                                  Text('posts', style: AppStyles.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fullName, style: AppStyles.textStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w500)),
                          if (departmentID == 0) const SizedBox(height: 0) else Text(getDepartment(departmentID), style: AppStyles.textStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: AppStyles.thistleColor.withOpacity(0.6))),
                          const SizedBox(height: 4),
                          if (bio.isEmpty) const SizedBox(height: 0) else SizedBox(width: 300, child: Text(bio, style: AppStyles.textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(
                          onPressed: navigateToEditProfile,
                          style: AppStyles.buttonStyle.copyWith(
                              side: WidgetStatePropertyAll(BorderSide(color: AppStyles.thistleColor, width: 1.5)),
                              elevation: const WidgetStatePropertyAll(0),
                              backgroundColor: const WidgetStatePropertyAll(Colors.white),
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                          ),
                          child: Text('Edit Profile', style: AppStyles.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: AppStyles.thistleColor)),
                        )),
                        const SizedBox(width: 8),
                        Expanded(child: OutlinedButton(
                          onPressed: navigateToFriendsPage,
                          style: AppStyles.buttonStyle.copyWith(
                              side: WidgetStatePropertyAll(BorderSide(color: AppStyles.thistleColor, width: 1.5)),
                              elevation: const WidgetStatePropertyAll(0),
                              backgroundColor: const WidgetStatePropertyAll(Colors.white),
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                          ),
                          child: Text('Find Friends', style: AppStyles.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: AppStyles.thistleColor)),
                        ))
                      ],
                    )
                  ],
                ),
              ),
              bottomNavigationBar: const ThistleNavBar(),
            );
          }
          if (userProfile == null) {
            return const CircularProgressIndicator(color: Colors.black); // or some loading widget
          }
          if (user == null) {
            return Scaffold(
              appBar: const ThistleAppbar(title: 'user'),
              endDrawer: MyDrawer(
                onSignOutTap: Provider.of<ApplicationState>(context, listen: false).signOut,
                onActivityTap: navigateToUserActivity,
                onSettingsTap: navigateToEditProfile,
              ),
              body: const SizedBox(height: double.infinity, width: double.infinity),
            );
          }
          return const CircularProgressIndicator(color: Colors.black);
        });
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.onSignOutTap,
    required this.onActivityTap,
    required this.onSettingsTap,
  });

  final void Function()? onSignOutTap;
  final void Function()? onActivityTap;
  final void Function()? onSettingsTap;

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
              Icons.settings,
              color: Colors.white,
            ),
            onTap: onSettingsTap,
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            onTap: onActivityTap,
            title: const Text(
              'Your activity',
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