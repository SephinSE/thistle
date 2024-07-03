import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thistle/app_state.dart';

import '../pages/styles.dart';

class ThistleNavBar extends StatefulWidget{
  const ThistleNavBar({super.key});

  @override
  State<ThistleNavBar> createState() => _ThistleNavBarState();
}

class _ThistleNavBarState extends State<ThistleNavBar> {
  @override
  Widget build(BuildContext context) {
    Color color = AppStyles.thistleColor;

    return NavigationBar(
      destinations: [
        NavigationDestination(icon: Icon(Icons.home, color: color), label: 'Feed'),
        NavigationDestination(icon: Icon(Icons.location_on, color: color), label: 'Map'),
        NavigationDestination(icon: Icon(Icons.add_box, color: color), label: 'Post'),
        NavigationDestination(icon: Icon(Icons.favorite, color: color), label: 'Activity'),
        NavigationDestination(icon: Icon(Icons.person, color: color), label: 'Profile'),
      ],
      backgroundColor: AppStyles.onThistleColor,
      selectedIndex: Provider.of<ApplicationState>(context).selectedIndex,
      onDestinationSelected: Provider.of<ApplicationState>(context, listen: false).onNavBarTap,
    );
  }
}