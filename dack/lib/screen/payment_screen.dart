import 'package:flutter/material.dart';
import '../models/Movie.dart';

class PaymentScreen extends StatefulWidget {
  final Movie movie;
  final List<int> selectedSeats;
  final DateTime selectedDate;
  final String selectedTime;

  const PaymentScreen({
    Key? key,
    required this.movie,
    required this.selectedSeats,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;

  // Giả lập quá trình thanh toán
  Future<bool> _processPayment() async {
    // Giả lập một quá trình thanh toán mất 2 giây
    await Future.delayed(const Duration(seconds: 2));

    // Ở đây, bạn có thể tích hợp các cổng thanh toán thực tế như Stripe, PayPal, v.v.
    // Ví dụ này sẽ giả lập thanh toán thành công luôn
    return true;

    // Nếu muốn giả lập thất bại:
    // return false;
  }

  void _onPay() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn phương thức thanh toán.')),
      );
      return;
    }

    // Hiển thị loading khi đang xử lý thanh toán
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final paymentSuccess = await _processPayment();

    // Đóng dialog loading
    Navigator.pop(context);

    if (paymentSuccess) {
      // Trả về kết quả thành công
      Navigator.pop(context, true);
    } else {
      // Trả về kết quả thất bại
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.selectedSeats.length * 100000; // Giả sử mỗi ghế 100,000 VND

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Phim: ${widget.movie.title}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Ngày: ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Giờ: ${widget.selectedTime}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Phương thức thanh toán:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('Thẻ tín dụng'),
              value: 'credit_card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('PayPal'),
              value: 'paypal',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Thanh toán khi nhận vé (COD)'),
              value: 'cod',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Tổng tiền: ${totalPrice.toString()} VND',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _onPay,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Thanh toán',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
