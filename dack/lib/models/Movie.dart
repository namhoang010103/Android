import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  final String title;
  final String imageUrl;
  final String genre;
  final double rating;

  Movie({required this.id, required this.title, required this.imageUrl, required this.genre, required this.rating});

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Movie(
      id: doc.id,
      title: data['title'],
      imageUrl: data['image'],
      genre: data['genre'],
      rating: data['rating'],
    );
  }
}
