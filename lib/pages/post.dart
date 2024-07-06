import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thistle/pages/feed.dart'; // Ensure this import is correct

class ThistlePostPage extends StatefulWidget {
  const ThistlePostPage({super.key});

  @override
  _ThistlePostPageState createState() => _ThistlePostPageState();
}

class _ThistlePostPageState extends State<ThistlePostPage> {
  File? _image;
  String? _imageName;
  final TextEditingController _captionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPersistentBottomSheet();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPersistentBottomSheet();
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageName = pickedFile.name;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || _captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select an image and enter a caption'),
      ));
      return;
    }

    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = imagesRef.putFile(_image!);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadURL = await snapshot.ref.getDownloadURL();

      // Get user info
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not logged in';

      // Store data to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'imageURL': downloadURL,
        'caption': _captionController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image uploaded successfully'),
      ));
      setState(() {
        _image = null;
        _captionController.clear();
        _imageName = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload image: $e'),
      ));
    }
  }

  void _showPersistentBottomSheet() {
    _scaffoldKey.currentState?.showBottomSheet((BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6, // 60% of the screen height
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_image != null)
              Image.file(
                _image!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    // Navigate to ThistleFeedPage in the next frame
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ThistleFeedPage()),
                      );
                    });
                  },
                  icon: Icon(Icons.close),
                ),
                const SizedBox(height: 20, width: 215),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: Text('Publish'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(labelText: 'Enter caption'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            if (_imageName != null)
              Text(
                'Selected Image: $_imageName',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      );
    },
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const ThistleAppbar(
        title: 'Post',
      ),
      body: const Center(
        child: Text('This is the Thistle Post Page'),
      ),
      bottomNavigationBar: ThistleNavBar(),
    );
  }
}
