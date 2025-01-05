// lib/screens/ticket_detail_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng thời gian
import '../models/Booking.dart';

class TicketDetailScreen extends StatelessWidget {
  final Booking booking;

  const TicketDetailScreen({required this.booking, Key? key}) : super(key: key);

  // Hàm tạo Document ID giống như trong BookedTicketsScreen và SeatBookingScreen
  String _makeSeatDocId(String movieId, String date, String time) {
    try {
      final parts = date.split('-'); // Format: yyyy-mm-dd
      final dd = parts[2].padLeft(2, '0');
      final mm = parts[1].padLeft(2, '0');
      final yyyy = parts[0];
      final hhmm = time.replaceAll(':', '');
      return '${movieId}_$dd$mm$yyyy$hhmm';
    } catch (e) {
      debugPrint('Lỗi khi tạo docId: $e');
      return 'invalid_doc_id';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Định dạng thời gian đặt vé
    String formattedBookingTime = '';
    if (booking.timestamp != null) {
      DateTime bookingDateTime = booking.timestamp.toDate();
      formattedBookingTime = DateFormat('dd/MM/yyyy HH:mm').format(bookingDateTime);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Vé Đặt'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề phim
            Center(
              child: Text(
                booking.movieTitle,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Chi tiết vé đặt
            _detailRow('Ngày Chiếu:', booking.date),
            _detailRow('Giờ Chiếu:', booking.time),
            _detailRow('Ghế:', booking.seats.map((s) => 'Ghế ${s + 1}').join(', ')),
            _detailRow('Tổng Tiền:', '${booking.totalPrice} VND'),
            _detailRow('Thời Gian Đặt Vé:', formattedBookingTime),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị chi tiết từng hàng
  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style:
            TextStyle(fontSize: 16, color: valueColor ?? Colors.black),
          ),
        ],
      ),
    );
  }

}
