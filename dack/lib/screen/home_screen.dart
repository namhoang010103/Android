import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Widget/banner.dart';
import '../Widget/moive_list.dart';
import '../utils/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ứng dụng đặt vé xem phim', style: TextStyle(color: Colors.white,),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                // Chuyển đến màn hình đăng nhập
                Navigator.pushNamed(context, Routes.login);
              } else {
                // Chuyển đến màn hình thông tin cá nhân
                Navigator.pushNamed(context, Routes.profile, arguments: user);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Chào mừng đến Cinemas!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const BannerWidget(),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Phim đang chiếu',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            const MovieListWidget(),
          ],
        ),
      ),
    );
  }
}
