// lib/screens/seat_booking_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_screen.dart'; // Đảm bảo đường dẫn đúng
import '../models/Movie.dart'; // Đảm bảo đường dẫn đúng

enum SeatStatus { available, selected, booked }

class SeatBookingScreen extends StatefulWidget {
  final Movie movie; // Nhận Movie

  const SeatBookingScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  State<SeatBookingScreen> createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  final List<DateTime> _dates =
  List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
  final List<String> _times = [
    '09:00',
    '11:30',
    '14:00',
    '16:30',
    '19:00',
    '21:30'
  ];

  late DateTime _selectedDate;
  late String _selectedTime;

  final int rows = 4;
  final int cols = 6;
  int get seatCount => rows * cols;

  // Danh sách ghế đã chọn tạm thời
  List<int> _selectedSeats = [];

  @override
  void initState() {
    super.initState();

    _selectedDate = _dates.first;
    _selectedTime = _times.first;
  }

  // Hàm tạo Document ID giống như trong BookedTicketsScreen
  String _makeDocId(String movieId, DateTime date, String time) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    final hhmm = time.replaceAll(':', '');
    return '${movieId}_$dd$mm$yyyy$hhmm';
  }

  // Hàm lấy trạng thái ghế từ Firestore theo thời gian thực
  Stream<List<SeatStatus>> _fetchSeatStatus() {
    final docId = _makeDocId(widget.movie.id, _selectedDate, _selectedTime);
    return FirebaseFirestore.instance
        .collection('seats')
        .doc(docId)
        .snapshots()
        .map((docSnap) {
      if (docSnap.exists) {
        final seatList = docSnap.get('seats') as List<dynamic>? ?? [];
        return seatList.map((val) {
          if (val == 0) return SeatStatus.available;
          if (val == 2) return SeatStatus.booked;
          return SeatStatus.available; // Mặc định
        }).toList();
      } else {
        return List.generate(seatCount, (_) => SeatStatus.available);
      }
    });
  }

  // Hàm xử lý khi người dùng nhấn chọn ghế
  void _onSeatTap(int index, List<SeatStatus> seats) {
    final status = seats[index];
    if (status == SeatStatus.booked) return; // Không chọn ghế đã booked

    setState(() {
      if (_selectedSeats.contains(index)) {
        _selectedSeats.remove(index);
      } else {
        _selectedSeats.add(index);
      }
    });
  }

  // Hàm xác nhận đặt ghế
  Future<void> _onConfirmSeats() async {
    if (_selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất một ghế để đặt.')),
      );
      return;
    }

    // Lấy UID của người dùng hiện tại
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Bạn chưa đăng nhập. Vui lòng đăng nhập để đặt vé.')),
      );
      return;
    }

    // Chuyển sang trang PaymentScreen và chờ kết quả
    final paymentResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          movie: widget.movie,
          selectedSeats: _selectedSeats,
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
        ),
      ),
    );

    if (paymentResult == true) {
      try {
        // Sử dụng transaction để đảm bảo tính nguyên tử
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final docId = _makeDocId(widget.movie.id, _selectedDate, _selectedTime);
          final seatDocRef =
          FirebaseFirestore.instance.collection('seats').doc(docId);

          final seatDocSnap = await transaction.get(seatDocRef);
          List<dynamic> seatList = [];
          if (seatDocSnap.exists && seatDocSnap.get('seats') != null) {
            seatList = List<dynamic>.from(seatDocSnap.get('seats'));
          } else {
            seatList = List<dynamic>.generate(seatCount, (_) => 0);
          }

          // Kiểm tra xem các ghế đã chọn có còn available không
          for (final seatIndex in _selectedSeats) {
            if (seatList[seatIndex] != 0) {
              throw Exception('Ghế ${seatIndex + 1} đã được đặt.');
            }
          }

          // Cập nhật các ghế đã chọn thành booked (2)
          for (final seatIndex in _selectedSeats) {
            seatList[seatIndex] = 2;
          }

          // Cập nhật vào Firestore
          transaction.set(seatDocRef, {
            'movie': widget.movie.title, // Thêm thông tin phim
            'seats': seatList,
            'timestamp': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        });

        // Tạo một booking mới
        await FirebaseFirestore.instance.collection('bookings').add({
          'userId': user.uid,
          'movieId': widget.movie.id,
          'movieTitle': widget.movie.title,
          'seats': _selectedSeats,
          'date':
          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
          'time': _selectedTime,
          'totalPrice': _selectedSeats.length * 100000, // Giả sử mỗi ghế 100,000 VND
          'status': 'confirmed',
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Cập nhật trạng thái ghế trong local state
        setState(() {
          _selectedSeats.clear();
        });

        // Thông báo thành công
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Thành công'),
            content: const Text('Bạn đã đặt ghế thành công!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Xử lý lỗi khi đặt ghế
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    } else {
      // Nếu thanh toán không thành công hoặc bị hủy, giữ trạng thái ghế không đổi
      setState(() {
        _selectedSeats.clear();
      });

      // Thông báo không thành công hoặc bị hủy
      if (paymentResult == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thanh toán không thành công. Vui lòng thử lại.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đặt ghế đã bị hủy.')),
        );
      }
    }
  }

  // Hàm xây dựng lưới ghế
  Widget _buildSeatGrid(List<SeatStatus> seats) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seatCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (_, index) {
        final st = seats[index];
        Color color;

        // Kiểm tra xem ghế này có nằm trong danh sách ghế đã chọn hay không
        if (_selectedSeats.contains(index)) {
          color = Colors.yellow; // Ghế đang được chọn
        } else {
          switch (st) {
            case SeatStatus.available:
              color = Colors.green;
              break;
            case SeatStatus.booked:
              color = Colors.red;
              break;
            default:
              color = Colors.green;
          }
        }

        return GestureDetector(
          onTap: () => _onSeatTap(index, seats),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              'Ghế\n${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  // Hàm xây dựng bộ chọn ngày
  Widget _buildDatePicker() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _dates.map((date) {
          final isSelected = date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text('${date.day}/${date.month}'),
              selected: isSelected,
              selectedColor: Colors.blue,
              onSelected: (_) {
                setState(() {
                  _selectedDate = date;
                  _selectedSeats.clear(); // Xóa danh sách ghế đã chọn khi thay đổi ngày
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // Hàm xây dựng bộ chọn giờ
  Widget _buildTimePicker() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _times.map((time) {
          final isSelected = time == _selectedTime;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(time),
              selected: isSelected,
              selectedColor: Colors.blue,
              onSelected: (_) {
                setState(() {
                  _selectedTime = time;
                  _selectedSeats.clear(); // Xóa danh sách ghế đã chọn khi thay đổi giờ
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt ghế - ${widget.movie.title}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Chọn ngày:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDatePicker(),
            const SizedBox(height: 16),
            const Text(
              'Chọn giờ:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTimePicker(),
            const SizedBox(height: 16),
            const Text(
              'Chọn ghế:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<SeatStatus>>(
              stream: _fetchSeatStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
                }
                final seats = snapshot.data ??
                    List.generate(seatCount, (_) => SeatStatus.available);
                return _buildSeatGrid(seats);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onConfirmSeats,
              child: const Text('Xác nhận đặt ghế'),
            ),
          ],
        ),
      ),
    );
  }
}
