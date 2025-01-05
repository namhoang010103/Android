import 'package:dack/screen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Widget/banner.dart';
import '../Widget/moive_list.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Ứng dụng đặt vé xem phim',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: user),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 16.0),
            const BannerWidget(),
            const SizedBox(height: 16.0),
            const TabBar(
              indicatorColor: Colors.red,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: "Đang Chiếu"),
                Tab(text: "Đặc Biệt"),
                Tab(text: "Sắp Chiếu"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MovieListWidget(filter: "now_showing"), // Đang Chiếu
                  MovieListWidget(filter: "high_rating"), // Đặc Biệt
                  MovieListWidget(filter: "upcoming"), // Sắp Chiếu
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
