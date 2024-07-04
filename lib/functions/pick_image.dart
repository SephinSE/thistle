import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage(BuildContext context) async {
  final imagePicker = ImagePicker();
  final XFile? image;
  // Display an option sheet to choose camera or gallery
  final source = await showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      children: [
        ListTile(
          title: const Text('Take Picture'),
          onTap: () => Navigator.pop(context, ImageSource.camera),
        ),
        ListTile(
          title: const Text('Choose from Gallery'),
          onTap: () => Navigator.pop(context, ImageSource.gallery),
        ),
      ],
    ),
  );

  if (source == null) {
    return null;
  }

  image = await imagePicker.pickImage(source: source);
  return image;
}
