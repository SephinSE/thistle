import 'package:flutter/material.dart';
import 'package:thistle/pages/profile_page/list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onHomeTap;
  final void Function()? onEditProfileTap;
  final void Function()? onSignOutTap;
  const MyDrawer({super.key, required this.onHomeTap, required this.onEditProfileTap, required this.onSignOutTap});


  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Color(0xFFC779FF),
      backgroundColor: Color(0xFF2B1A4E),
      child: Column(
        children: [
          //header
          const DrawerHeader(
            child: Icon(
              Icons.person,
              size: 64,
              color: Colors.white,
            ),
          ),
        //List Tiles
          MyListTile(
              icon: Icons.home,
              text: 'H O M E',
              onTap: onHomeTap,

          ),
          MyListTile(
              icon: Icons.person_2_outlined,
              text: 'E D I T  P R O F I L E',
              onTap: onEditProfileTap,
          ),

          MyListTile(
              icon: Icons.settings,
              text: 'S E T T I N G S',
              onTap: ()=>Navigator.pop(context) ,
          ),
          MyListTile(
            icon: Icons.logout,
            text: 'S I G N  O U T',
            onTap: onSignOutTap ,
          ),
        ],
      ),
    );
  }
}
