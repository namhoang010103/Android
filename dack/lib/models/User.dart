class UserModel {
  final String uid;
  final String name;
  final String email;
  final String avatarUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  // Từ Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
    );
  }

  // Lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}
