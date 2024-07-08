import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thistle/appbar/appbar.dart';
import 'package:thistle/appbar/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thistle/app_state.dart';
import 'package:thistle/pages/styles.dart';
import 'package:intl/intl.dart';

class ThistleCurrentUserActivityPage extends StatelessWidget {
  const ThistleCurrentUserActivityPage({super.key});

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
                .where('likedBy', arrayContains: currentUser.uid)
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

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index].data() as Map<String, dynamic>;
                    final userName = post['userName'] ?? 'Unknown User';
                    final timestamp = post['timestamp']?.toDate();
                    final postCaption = post['caption'] ?? 'No caption';
                    final postImageURL = post['imageURL'] ?? '';

                    return ListTile(
                      leading: SizedBox(
                        width: 85,
                        child: Image.network(postImageURL),
                      ),
                      title: Text('You liked $userName\'s post', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppStyles.thistleColor,
                        fontSize: 16,
                      ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text(postCaption, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          if (timestamp != null)
                            Text(
                              DateFormat('dd MMMM yyyy, hh:mm a').format(timestamp.toLocal()), // Format timestamp
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          bottomNavigationBar: ThistleNavBar(),
        );
      },
    );
  }
}
