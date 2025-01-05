import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dack/models/movie.dart';

class MovieService {
  Future<List<Movie>> fetchMoviesFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('movies').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Movie(
          poster: data['poster'] ?? '',
          title: data['title'] ?? '',
          genre: data['genre'] ?? '',
          desc: data['desc'] ?? '',
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
          duration: (data['duration'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (e) {
      print("Lỗi khi tải danh sách phim: $e");
      throw Exception("Không thể tải dữ liệu từ Firestore");
    }
  }
}
