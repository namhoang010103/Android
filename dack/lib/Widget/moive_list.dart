import 'package:cloud_firestore/cloud_firestore.dart'; // Đảm bảo đường dẫn chính xác
import 'package:dack/screen/moviedetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dack/models/Movie.dart'; // Sử dụng chữ thường cho tên file

class MovieListWidget extends StatelessWidget {
  final String filter;

  const MovieListWidget({Key? key, required this.filter}) : super(key: key);

  Stream<List<Movie>> _fetchMovies() {
    final now = DateTime.now();
    final moviesRef = FirebaseFirestore.instance.collection('movies');

    if (filter == "now_showing") {
      // Lọc phim đã phát hành
      return moviesRef
          .where("releaseDate", isLessThanOrEqualTo: now.toIso8601String())
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => Movie.fromFirestore(doc.data(), doc.id))
          .toList());
    } else if (filter == "high_rating") {
      // Lọc phim có đánh giá cao
      return moviesRef
          .orderBy("rating", descending: true)
          .limit(6)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => Movie.fromFirestore(doc.data(), doc.id))
          .toList());
    } else if (filter == "upcoming") {
      // Lọc phim sắp chiếu
      return moviesRef
          .where("releaseDate", isGreaterThan: now.toIso8601String())
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => Movie.fromFirestore(doc.data(), doc.id))
          .toList());
    } else {
      return const Stream.empty(); // Trường hợp không xác định
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Movie>>(
      stream: _fetchMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có dữ liệu.'));
        }

        final movies = snapshot.data!;

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 2 / 3,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: movies.map((movie) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailPage(movie: movie),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8.0,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Stack(
                        children: [
                          Image.network(
                            movie.poster,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 50.0,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.black.withOpacity(0.6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "${movie.genre} • ${movie.duration} phút",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
