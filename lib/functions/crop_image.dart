import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

Future<CroppedFile?> cropImage(XFile image, BuildContext context) async {
  final croppedImage = await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    compressQuality: 80,
    compressFormat: ImageCompressFormat.jpg,
    uiSettings: [
      WebUiSettings(
        context: context,
      ),
    ]
  );
  return croppedImage;
}
