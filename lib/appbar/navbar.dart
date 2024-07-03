import 'package:flutter/material.dart';

import '../pages/styles.dart';
import '../pages/home_page.dart';
import '../pages/map.dart';
import '../pages/post.dart';
import '../pages/activity.dart';
import '../pages/profile.dart';

class ThistleNavBar extends StatefulWidget{
  const ThistleNavBar({super.key});

  @override
  State<ThistleNavBar> createState() => _ThistleNavBarState();
}

class _ThistleNavBarState extends State<ThistleNavBar> {
  // int _selectedIndex = 0;
  // void _onItemTapped(int index) {
  //   List<Widget> pages = [
  //     const MyHomePage(),
  //     const ThistleMapPage(),
  //     const ThistlePostPage(),
  //     const ThistleActivityPage(),
  //     const ThistleActivityPage(),
  //   ];
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.location_on), label: 'Map'),
        NavigationDestination(icon: Icon(Icons.add_box), label: 'Post'),
        NavigationDestination(icon: Icon(Icons.favorite), label: 'Activity'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
      backgroundColor: AppStyles.onThistleColor,
      // selectedIndex: _selectedIndex,
      // onDestinationSelected: _onItemTapped,
    );
  }
}