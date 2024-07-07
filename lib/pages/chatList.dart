import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '1to1chat.dart';

class PersonalChatsPage extends StatefulWidget {
  @override
  _PersonalChatsPageState createState() => _PersonalChatsPageState();
}

class _PersonalChatsPageState extends State<PersonalChatsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.uid;
  }

  Future<List<DocumentSnapshot>> _getPersonalChats() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('chats')
        .where('participants', arrayContains: _currentUserId)
        .get();

    return querySnapshot.docs;
  }

  void _openChatPage(String userId, String chatRoomId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          userId: userId,
          chatRoomId: chatRoomId,
          postId: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Chats'),
      ),
      body: FutureBuilder(
        future: _getPersonalChats(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No personal chats yet.'));
          }

          List<DocumentSnapshot> chats = snapshot.data!;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              DocumentSnapshot chat = chats[index];
              List<dynamic> participants = chat['participants'];
              String otherUserId = participants.firstWhere(
                    (id) => id != _currentUserId,
                orElse: () => '',
              );

              if (otherUserId.isEmpty) return SizedBox.shrink();

              // Example to fetch user's display name from 'users' collection
              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(otherUserId).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink(); // or show loading indicator
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return SizedBox.shrink(); // or show error message
                  }

                  String userName = userSnapshot.data!['displayName'] ?? 'Unknown';

                  return ListTile(
                    title: Text(userName),
                    onTap: () => _openChatPage(otherUserId, chat.id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
