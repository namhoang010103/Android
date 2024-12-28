import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class MovieRepository {
  final CollectionReference _movieCollection = FirebaseFirestore.instance.collection('movies');

  Stream<List<Movie>> getMovies() {
    return _movieCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Movie.fromFirestore(doc)).toList());
  }
}
