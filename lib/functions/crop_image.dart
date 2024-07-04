import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

Future<CroppedFile?> cropImage(XFile image) async {
  final croppedImage = await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    compressQuality: 80,
    compressFormat: ImageCompressFormat.jpg,
  );
  return croppedImage;
}
