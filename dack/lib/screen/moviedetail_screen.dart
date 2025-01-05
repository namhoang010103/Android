import 'package:dack/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dack/Widget/movie_info.dart';
import 'package:dack/core/constants.dart';
import 'package:dack/models/Movie.dart';
import 'package:dack/screen/reservation_screen.dart'; // Giả sử đây là SeatBookingScreen

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Poster & Info
              SizedBox(
                height: 335,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster
                    Expanded(
                      flex: 2,
                      child: Hero(
                        tag: movie.poster,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            movie.poster,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 29),
                    // Info
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MovieInfo(
                            icon: Icons.videocam_off_rounded,
                            name: "Thể loại",
                            value: movie.genre,
                          ),
                          MovieInfo(
                            icon: Icons.timer,
                            name: "Thời lượng",
                            value: formatTime(Duration(minutes: movie.duration)),
                          ),
                          MovieInfo(
                            icon: Icons.star_outlined,
                            name: "Đánh giá",
                            value: "${movie.rating}/10",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Tên phim
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Phân cách
              Divider(
                color: Colors.white.withOpacity(0.1),
                thickness: 1,
              ),
              const SizedBox(height: 20),
              // Mô tả
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mô tả",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                movie.desc,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
      // Nút đặt vé
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xff1c1c27),
              blurRadius: 60,
              spreadRadius: 80,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          onPressed: () {}, // Sẽ dùng sự kiện của MaterialButton bên dưới
          label: MaterialButton(
            onPressed: () {
              // Kiểm tra đăng nhập:
              final currentUser = FirebaseAuth.instance.currentUser;

              if (currentUser == null) {
                // Nếu chưa đăng nhập => chuyển đến Login
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              } else {
                // Đã đăng nhập => sang màn hình đặt ghế, truyền Movie
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SeatBookingScreen(movie: movie),
                  ),
                );
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: buttonColor,
            height: 60,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                "Đặt vé",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

