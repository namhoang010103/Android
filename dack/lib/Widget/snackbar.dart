import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.black, // Màu chữ
        fontSize: 16, // Kích thước chữ
      ),
    ),
    backgroundColor: Colors.white, // Màu nền snackbar
    behavior: SnackBarBehavior.floating, // Hiển thị nổi
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Bo góc snackbar
    ),
    margin: const EdgeInsets.all(16), // Khoảng cách tới các cạnh
    duration: const Duration(seconds: 3), // Thời gian hiển thị
  );

  ScaffoldMessenger.of(context).clearSnackBars(); // Xóa các snackbar cũ
  ScaffoldMessenger.of(context).showSnackBar(snackBar); // Hiển thị snackbar mới
}