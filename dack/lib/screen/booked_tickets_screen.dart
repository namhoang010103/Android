import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Booking.dart';
import 'ticket_detail_screen.dart'; // Màn hình chi tiết vé đặt

class BookedTicketsScreen extends StatelessWidget {
  final User user;

  const BookedTicketsScreen({required this.user, Key? key}) : super(key: key);

  Stream<List<Booking>> _fetchBookings() {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Booking.fromFirestore(doc.data(), doc.id)).toList());
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // No bookings
            return const Center(child: Text('Bạn chưa đặt vé nào.'));
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.movie, color: Colors.blueAccent, size: 40),
                  title: Text(booking.movieTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ngày: ${booking.date}'),
                      Text('Giờ: ${booking.time}'),
                      Text('Ghế: ${booking.seats.join(', ')}'),
                      Text('Tổng tiền: ${booking.totalPrice} VND'),
                      Text('Trạng thái: ${booking.status}'),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Ticket Detail Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TicketDetailScreen(booking: booking),
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

