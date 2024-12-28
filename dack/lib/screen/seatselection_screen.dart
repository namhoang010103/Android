import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatelessWidget {
  final String time;

  const SeatSelectionScreen({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn Ghế - $time'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chọn ghế cho suất chiếu lúc $time',
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 20),
            // Giả sử đây là lựa chọn ghế
            ElevatedButton(
              onPressed: () {
                // Xử lý chọn ghế tại đây
                // Ví dụ: Chuyển sang trang xác nhận đặt vé
              },
              child: const Text('Chọn Ghế'),
            ),
          ],
        ),
      ),
    );
  }
}
