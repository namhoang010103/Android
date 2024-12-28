import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/routes.dart'; // Make sure to define the appropriate route for home

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Tin Cá Nhân'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent, // Modify if needed
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user.photoURL ?? ''),
              backgroundColor: Colors.grey.shade200,
            ),
          const SizedBox(height: 24),

            // User Name
            Text(
              user.displayName ?? 'Không rõ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // User Email
            Text(
              user.email ?? 'Không có email',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
              
            ),
            const SizedBox(height: 100),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Navigate to Edit Profile screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text(
                'Chỉnh Sửa Hồ Sơ',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.home, // Ensure the route name is correct
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Modify color if needed
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text(
                'Đăng Xuất',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
