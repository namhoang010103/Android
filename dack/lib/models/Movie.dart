class Movie {
  final String id;
  final String poster;
  final String title;
  final String genre;
  final String desc;
  final double rating;
  final int duration;
  final DateTime releaseDate;

  Movie({
    required this.id,
    required this.poster,
    required this.title,
    required this.genre,
    required this.desc,
    required this.rating,
    required this.duration,
    required this.releaseDate,
  });

  factory Movie.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Movie(
      id: documentId,
      poster: data['poster'] ?? '',
      title: data['title'] ?? '',
      genre: data['genre'] ?? '',
      desc: data['desc'] ?? '',
      rating: (data['rating'] as num).toDouble(),
      duration: data['duration'],
      releaseDate: DateTime.parse(data['releaseDate']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'poster': poster,
      'title': title,
      'genre': genre,
      'desc': desc,
      'rating': rating,
      'duration': duration,
      'releaseDate': releaseDate.toIso8601String(),
    };
  }
}
