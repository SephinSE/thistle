import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String userId; // Pass the user ID of the post owner here
  final String postId; // Pass the post ID here

  const ChatPage({Key? key, required this.userId, required this.postId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference<Map<String, dynamic>> _messagesCollection;
  late String _currentUserId;
  late String _chatRoomId;

  @override
  void initState() {
    super.initState();
    _messagesCollection = _firestore.collection('chats');
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _chatRoomId = _generateChatRoomId();
  }

  String _generateChatRoomId() {
    // Generate a unique chat room ID based on user IDs
    List<String> userIds = [_currentUserId, widget.userId];
    userIds.sort(); // Sort user IDs to maintain consistency
    return userIds.join('_');
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    await _messagesCollection.doc(_chatRoomId).collection('messages').add({
      'senderId': _currentUserId,
      'receiverId': widget.userId,
      'postId': widget.postId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _messagesCollection.doc(_chatRoomId).collection('messages').orderBy('timestamp').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
                    bool isMe = data['senderId'] == _currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(data['message']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
