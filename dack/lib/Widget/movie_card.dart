import 'package:flutter/material.dart';
import '../screen/moviedetail_screen.dart';  // Import MovieDetailScreen

class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String genre;
  final double rating;

  const MovieCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Chuyển đến màn hình chi tiết phim
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(
              title: title,
              imageUrl: imageUrl,
              genre: genre,
              rating: rating,
            ),
          ),
        );
      },
      child: Container(
        width: 150.0,
        margin: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                height: 180.0,
                width: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(genre, style: const TextStyle(color: Colors.grey)),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16.0),
                Text(rating.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
