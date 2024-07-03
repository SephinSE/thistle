import 'package:flutter/material.dart';
import '../pages/styles.dart';

class ThistleAppbar extends StatelessWidget implements PreferredSizeWidget {

  const ThistleAppbar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppStyles.textStyle;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
      titleTextStyle: textStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}