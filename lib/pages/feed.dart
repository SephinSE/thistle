import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';
import 'package:thistle/pages/chat.dart';
import 'package:thistle/pages/styles.dart';
import 'package:thistle/pages/1to1chat.dart';
import 'package:thistle/pages/chatList.dart';


class ThistleFeedPage extends StatefulWidget {
  const ThistleFeedPage({Key? key}) : super(key: key);

  @override
  State<ThistleFeedPage> createState() => _ThistleFeedPageState();
}

class _ThistleFeedPageState extends State<ThistleFeedPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  final List<DocumentSnapshot> _posts = [];
  bool _isLoading = false;
  bool _hasMorePosts = true;
  static const int _postsLimit = 6;
  DocumentSnapshot? _lastDocument;
  final Map<String, String> _userProfilePics = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadPosts() async {
    if (_isLoading || !_hasMorePosts) return;

    setState(() {
      _isLoading = true;
    });

    Query query = _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .limit(_postsLimit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isEmpty) {
      setState(() {
        _hasMorePosts = false;
      });
    } else {
      for (var doc in querySnapshot.docs) {
        final userId = doc['userId'];
        if (!_userProfilePics.containsKey(userId)) {
          final userDoc =
          await _firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            _userProfilePics[userId] =
                userDoc['photoURL'] ?? 'https://example.com/default_profile_pic.png';
          } else {
            _userProfilePics[userId] =
            'https://example.com/default_profile_pic.png';
            print("User document for userId $userId does not exist.");
          }
        }
      }

      setState(() {
        _posts.addAll(querySnapshot.docs);
        _lastDocument = querySnapshot.docs.last;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPosts();
    }
  }

  Future<void> _toggleLike(DocumentSnapshot post) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;
    final postRef = _firestore.collection('posts').doc(post.id);
    final postData = post.data() as Map<String, dynamic>;
    final likedBy = List<String>.from(postData['likedBy'] ?? []);
    final likeCount = postData['likes'] ?? 0;

    if (likedBy.contains(userId)) {
      await postRef.update({
        'likedBy': FieldValue.arrayRemove([userId]),
        'likes': likeCount - 1,
      });
    } else {
      await postRef.update({
        'likedBy': FieldValue.arrayUnion([userId]),
        'likes': likeCount + 1,
      });
    }

    setState(() {
      _posts[_posts.indexWhere((element) => element.id == post.id)] = post;
    });
  }

  Future<void> _showComments(DocumentSnapshot post) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final postRef = _firestore.collection('posts').doc(post.id);
    final commentsSnapshot =
    await postRef.collection('comments').orderBy('timestamp', descending: true).get();
    final List<Map<String, dynamic>> comments =
    commentsSnapshot.docs.map((doc) => doc.data()).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final TextEditingController _commentController =
            TextEditingController();

            Future<void> _addComment() async {
              if (_commentController.text.isEmpty) return;

              final newComment = {
                'userId': user.uid,
                'userName': user.displayName ?? 'Anonymous',
                'comment': _commentController.text,
                'timestamp': FieldValue.serverTimestamp(),
              };

              await postRef.collection('comments').add(newComment);

              setState(() {
                comments.insert(0, newComment);
              });

              _commentController.clear();
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final commentUser = comment['userName'] ?? 'Anonymous';
                        final commentText = comment['comment'] ?? '';

                        return ListTile(
                          title: Text(commentUser),
                          subtitle: Text(commentText),
                        );
                      },
                    ),
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Add a comment...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _addComment,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _generateChatRoomId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1\_$userId2'
        : '$userId2\_$userId1';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ThistleAppbar(
        title: 'Feed',
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: AppStyles.thistleColor,
              size: 30,
            ),
          ),
        ],
      ),
      body: _isLoading && _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == _posts.length) {
            return _hasMorePosts
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox();
          }

          final post = _posts[index].data() as Map<String, dynamic>;
          final imageUrl = post['imageURL'] ?? '';
          final userName = post['userName'] ?? 'Anonymous';
          final userId = post['userId'];
          final profilePicUrl =
              _userProfilePics[userId] ?? 'https://example.com/default_profile_pic.png';
          final timestamp = (post['timestamp'] as Timestamp).toDate();
          final caption = post['caption'] ?? '';
          final likes = post['likes'] ?? 0;
          final likedBy = List<String>.from(post['likedBy'] ?? []);
          final currentUser = FirebaseAuth.instance.currentUser;
          final isLiked =
              currentUser != null && likedBy.contains(currentUser.uid);
          const likeColor = Color(0xff2B1A4E);

          return Card(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilePicUrl),
                    ),
                    title: Text(userName),
                    subtitle: Text(timestamp.toString()),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? likeColor : Colors.grey,
                                ),
                                onPressed: () =>
                                    _toggleLike(_posts[index]),
                              ),
                              const SizedBox(width: 0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon:
                                const Icon(Icons.comment, color: Colors.grey),
                                onPressed: () => _showComments(_posts[index]),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 48,
                                height: 48,
                                child: IconButton(
                                  icon: Container(
                                    width: 24,
                                    height: 24,
                                    child: ImageIcon(
                                        AssetImage('assets/thistleLOGO.png')),
                                  ),
                                  onPressed: () async {
                                    // Navigate to ChatPage with boilerplate message
                                    final chatRoomId = _generateChatRoomId(currentUser!.uid, userId);
                                    final postText = "Hey $userName, I'm interested in your post: \"$caption\". Let's chat!";

                                    // Check if chat room already exists
                                    final chatRoomRef = _firestore.collection('chats').doc(chatRoomId);
                                    final chatRoomDoc = await chatRoomRef.get();

                                    if (!chatRoomDoc.exists) {
                                      // Create a new chat room document
                                      await chatRoomRef.set({
                                        'participants': [currentUser.uid, userId],
                                        'lastMessage': postText,
                                        'timestamp': FieldValue.serverTimestamp(),
                                        'swipestate': {
                                          currentUser.uid: 0,
                                          userId: 0,
                                        },
                                      });
                                    }

                                    // Navigate to ChatPage
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          userId: userId,
                                          postId: _posts[index].id,
                                          chatRoomId: chatRoomId,
                                          initialMessage: postText,
                                        ),
                                      ),
                                    );
                                  },

                                ),
                              ),
                              const SizedBox(width: 0),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 175),
                      Text(
                        "$likes",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(likes > 1 ? "Likes" : "Like"),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  if (caption.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          caption,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12.0),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const ThistleNavBar(),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFC5C7FF),
              ),
              child: Text(
                'Communication',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('CHAT ROOM'),
              onTap: () {
                context.go('/chat');
              },
            ),
            ListTile(
              title: Text('PERSONAL CHATS'),
              onTap: () {
                context.go('/chatList'); // Navigate to the personal chat page
              },
            ),
          ],
        ),
      ),
    );
  }
}