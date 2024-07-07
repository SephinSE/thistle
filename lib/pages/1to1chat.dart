import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String postId;
  final String chatRoomId;
  final String? initialMessage;

  const ChatPage({
    Key? key,
    required this.userId,
    required this.postId,
    required this.chatRoomId,
    this.initialMessage,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference<Map<String, dynamic>> _messagesCollection;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _messagesCollection = _firestore.collection('chats').doc(widget.chatRoomId).collection('messages');

    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      _sendMessage(widget.initialMessage!);
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    await _messagesCollection.add({
      'senderId': _currentUserId,
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
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
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
