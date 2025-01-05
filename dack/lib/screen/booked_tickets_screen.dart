// lib/screens/booked_tickets_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Booking.dart';
import 'ticket_detail_screen.dart';

class BookedTicketsScreen extends StatelessWidget {
  final User user;

  const BookedTicketsScreen({required this.user, Key? key}) : super(key: key);

  // Hàm tạo Document ID giống như trong SeatBookingScreen
  String _makeSeatDocId(String movieId, String date, String time) {
    try {
      final parts = date.split('-'); // Format: yyyy-mm-dd
      final dd = parts[2].padLeft(2, '0');
      final mm = parts[1].padLeft(2, '0');
      final yyyy = parts[0];
      final hhmm = time.replaceAll(':', '');
      return '${movieId}_${dd}${mm}${yyyy}_$hhmm';
    } catch (e) {
      debugPrint('Lỗi khi tạo docId: $e');
      return 'invalid_doc_id';
    }
  }

  // Hàm lấy danh sách booking từ Firestore
  Stream<List<Booking>> _fetchBookings() {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      debugPrint('Snapshot length: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        debugPrint('Booking data: ${doc.data()}');
        return Booking.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vé Đã Đặt'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<Booking>>(
        stream: _fetchBookings(),
        builder: (context, snapshot) {
          // Hiển thị loading spinner khi đang tải dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Xử lý lỗi
          if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          }

          // Xử lý khi không có dữ liệu hoặc dữ liệu rỗng
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            debugPrint('No bookings found for user: ${user.uid}');
            return const Center(child: Text('Bạn chưa đặt vé nào.'));
          }

          // Dữ liệu có sẵn
          final bookings = snapshot.data!;
          debugPrint('Number of bookings: ${bookings.length}');

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.movie,
                      color: Colors.blueAccent, size: 40),
                  title: Text(booking.movieTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ngày: ${booking.date}'),
                      Text('Giờ: ${booking.time}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TicketDetailScreen(booking: booking),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
