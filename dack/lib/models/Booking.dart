// lib/models/Booking.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String movieId;
  final String movieTitle;
  final List<int> seats;
  final String date; // Định dạng: yyyy-mm-dd
  final String time; // Định dạng: hh:mm
  final int totalPrice;
  final String status;
  final Timestamp timestamp; // Thêm trường timestamp

  Booking({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.movieTitle,
    required this.seats,
    required this.date,
    required this.time,
    required this.totalPrice,
    required this.status,
    required this.timestamp,
  });

  factory Booking.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Booking(
      id: documentId,
      userId: data['userId'] ?? '',
      movieId: data['movieId'] ?? '',
      movieTitle: data['movieTitle'] ?? '',
      seats: List<int>.from(data['seats'] ?? []),
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      totalPrice: data['totalPrice'] ?? 0,
      status: data['status'] ?? 'confirmed',
      timestamp: data['timestamp'] ?? Timestamp.now(), // Thêm trường timestamp
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'seats': seats,
      'date': date,
      'time': time,
      'totalPrice': totalPrice,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(), // Sử dụng server timestamp
    };
  }
}
