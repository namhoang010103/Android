import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Booking.dart';
import '../models/Movie.dart';

class TicketDetailScreen extends StatelessWidget {
  final Booking booking;

  const TicketDetailScreen({required this.booking, Key? key}) : super(key: key);

  Future<void> _cancelBooking(BuildContext context) async {
    if (booking.status != 'confirmed') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vé này không thể hủy.')),
      );
      return;
    }

    // Xác nhận hủy vé
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận hủy vé'),
        content: const Text('Bạn có chắc chắn muốn hủy vé này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Có'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Cập nhật trạng thái vé thành 'cancelled'
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(booking.id)
          .update({'status': 'cancelled'});

      // Cập nhật trạng thái ghế trong collection 'seats' thành 'available' (0)
      final seatDocId = _makeSeatDocId(booking.date, booking.time);
      final seatDocRef = FirebaseFirestore.instance.collection('seats').doc(seatDocId);
      final seatDocSnap = await seatDocRef.get();
      if (seatDocSnap.exists) {
        List<dynamic> seatList = List<dynamic>.from(seatDocSnap.data()!['seats'] ?? []);
        for (final seatIndex in booking.seats) {
          if (seatIndex >= 0 && seatIndex < seatList.length) {
            seatList[seatIndex] = 0; // available
          }
        }
        await seatDocRef.set({'seats': seatList}, SetOptions(merge: true));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vé đã được hủy thành công.')),
      );

      // Quay lại màn hình danh sách vé
      Navigator.pop(context);
    }
  }

  String _makeSeatDocId(String date, String time) {
    // Giả sử docId được tạo theo định dạng 'ddmmyyyy_hhmm'
    final parts = date.split('-'); // "2025-01-05"
    final dd = parts[2].padLeft(2, '0');
    final mm = parts[1].padLeft(2, '0');
    final yyyy = parts[0];
    final hhmm = time.replaceAll(':', '');
    return '${dd}${mm}${yyyy}_$hhmm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Vé Đặt'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Movie Title
            Text(
              booking.movieTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Showtime
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ngày Chiếu:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  booking.date,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Giờ Chiếu:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  booking.time,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Seats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ghế:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  booking.seats.join(', '),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng Tiền:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${booking.totalPrice} VND',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trạng Thái:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  booking.status == 'confirmed' ? 'Đã xác nhận' : 'Đã hủy',
                  style: TextStyle(
                    fontSize: 16,
                    color: booking.status == 'confirmed' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Cancel Booking Button (if status is confirmed)
            if (booking.status == 'confirmed')
              ElevatedButton(
                onPressed: () => _cancelBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Modify color if needed
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  'Hủy Vé',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
