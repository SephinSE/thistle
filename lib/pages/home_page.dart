import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../pages/feed.dart';
import '../pages/map.dart';
import '../pages/post.dart';
import '../pages/activity.dart';
import '../pages/profile.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  final List<Widget> pages =  const [
    ThistleFeedPage(),
    ThistleMapPage(),
    ThistlePostPage(),
    ThistleActivityPage(),
    ThistleProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return pages[context.watch<ApplicationState>().selectedIndex];
  }
}
