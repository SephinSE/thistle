import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thistle/app_state.dart';
import 'package:thistle/pages/styles.dart';
import 'package:intl/intl.dart';

class ThistleActivityPage extends StatelessWidget {
  const ThistleActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) {
        final currentUser = appState.currentUser;
        if (currentUser == null) {
          return const Center(child: Text('Please log in to view activity'));
        }

        return Scaffold(
          appBar: const ThistleAppbar(title: 'Activity'),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where('userId', isEqualTo: currentUser.uid)
                .where('likedBy', isNotEqualTo: [])
                .orderBy('likedBy')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No activity'));
              }

              final posts = snapshot.data!.docs;

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index].data() as Map<String, dynamic>;
                  final likedBy = List<String>.from(post['likedBy'] ?? []);
                  final postCaption = post['caption'] ?? 'No caption';
                  final postImageURL = post['imageURL'] ?? '';
                  final timestamp = post['timestamp']?.toDate();

                  return Column(
                    children: likedBy.map((userId) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return const ListTile(title: Text('Loading...'));
                          }

                          final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
                          final userName = userData?['username'] ?? 'Unknown User';
                          final userPhotoURL = userData?['photoURL'] ?? '';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: userPhotoURL.isNotEmpty
                                  ? NetworkImage(userPhotoURL)
                                  : null,
                              child: userPhotoURL.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            trailing: SizedBox(
                              child: Image.network(postImageURL),
                              width: 45,
                            ),
                            title: Text('$userName liked your post',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppStyles.thistleColor,
                              fontSize: 16,
                            ),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 220,
                                    child: Text(postCaption, maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                if (timestamp != null)
                                  Text(
                                    DateFormat('dd MMMM yyyy, hh:mm a').format(timestamp.toLocal()), // Format timestamp
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
          bottomNavigationBar: ThistleNavBar(),
        );
      },
    );
  }
}