import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/routes.dart';

class MovieDetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String genre;
  final double rating;

  const MovieDetailScreen({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Danh sách các thời gian chiếu
    final List<String> showtimes = [
      '10:00 AM',
      '1:00 PM',
      '4:00 PM',
      '7:00 PM',
      '10:00 PM'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              genre,
              style: const TextStyle(color: Colors.grey, fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20.0),
                Text(
                  rating.toString(),
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Chọn thời gian chiếu:',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            // Hiển thị danh sách thời gian chiếu
            Column(
              children: showtimes.map((time) {
                return GestureDetector(
                  onTap: () {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // Nếu đã đăng nhập, chuyển đến màn hình chọn ghế
                      Navigator.pushNamed(context, Routes.seatSelection, arguments: time);
                    } else {
                      // Nếu chưa đăng nhập, chuyển đến màn hình đăng nhập
                      Navigator.pushNamed(context, Routes.login);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
