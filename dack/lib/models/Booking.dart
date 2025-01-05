// lib/models/booking.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String movieId;
  final String movieTitle;
  final List<int> seats;
  final String date; // Định dạng: YYYY-MM-DD
  final String time; // Định dạng: HH:MM
  final int totalPrice;
  final String status; // 'confirmed' hoặc 'cancelled'
  final Timestamp timestamp;

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

  // Factory constructor để tạo Booking từ dữ liệu Firestore
  factory Booking.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Booking(
      id: documentId,
      userId: data['userId'] ?? '',
      movieId: data['movieId'] ?? '',
      movieTitle: data['movieTitle'] ?? 'Không rõ',
      seats: List<int>.from(data['seats'] ?? []),
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      totalPrice: data['totalPrice']?.toInt() ?? 0,
      status: data['status'] ?? 'confirmed',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Phương thức để chuyển đổi Booking thành Map để lưu vào Firestore
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
      'timestamp': timestamp,
    };
  }
}
