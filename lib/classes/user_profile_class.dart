class UserProfileClass {
  UserProfileClass({
    required this.username,
    required this.photoURL,
    required this.friendsCount,
    required this.thistleCount,
    required this.fullName,
    required this.departmentID,
    required this.department,
    required this.bio,
  });

  final String username;
  final String? photoURL;
  final int friendsCount;
  final int thistleCount;
  final String fullName;
  final int departmentID;
  final String department;
  final String bio;

}