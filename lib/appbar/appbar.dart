import 'package:flutter/material.dart';

class ThistleAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ThistleAppbar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}