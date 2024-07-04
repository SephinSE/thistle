import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> uploadImage(XFile image) async {
  final user = FirebaseAuth.instance.currentUser;
  final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${user!.uid}');
  final uploadTask = storageRef.putFile(File(image.path));
  final snapshot = await uploadTask.whenComplete(() => null);
  final url = await snapshot.ref.getDownloadURL();
  return url;
}
