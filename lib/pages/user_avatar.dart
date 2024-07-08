import 'package:flutter/material.dart';
import 'styles.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.changeProfileImage,
    required this.providerImage,
  });
  final Future<void> Function(BuildContext context) changeProfileImage;
  final ImageProvider providerImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppStyles.thistleColor,
                  width: 3.5
                )
              ),
            )
            ,
            CircleAvatar(
              backgroundImage: providerImage,
              radius: 45,
            ),
          ]
        ),
        Positioned(
          bottom: -8,
          right: -8,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceBright,
                ),
              ),
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyles.thistleColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: AppStyles.onThistleColor, size: 16),
                highlightColor: Colors.transparent,
                onPressed: () => changeProfileImage(context),
              )
            ],
          ),
        ),
      ],
    );
  }
}