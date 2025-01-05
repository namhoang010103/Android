import 'package:cloud_firestore/cloud_firestore.dart';

class SeatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lắng nghe trạng thái ghế theo thời gian thực
  Stream<List<Map<String, dynamic>>> streamSeats(String showtime) {
    return _firestore
        .collection('seats')
        .where('showtime', isEqualTo: showtime)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Cập nhật trạng thái ghế sang "reserved"
  Future<void> reserveSeat(String seatNumber, String showtime) async {
    final seatDoc = await _firestore
        .collection('seats')
        .where('seatNumber', isEqualTo: seatNumber)
        .where('showtime', isEqualTo: showtime)
        .get();

    if (seatDoc.docs.isNotEmpty) {
      await seatDoc.docs.first.reference.update({'status': 'reserved'});
    }
  }
}
