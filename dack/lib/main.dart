import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dack/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'models/Seats.dart';
import 'service/firebase_service.dart';

void main() async {
  await FirebaseService.initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng Dụng Đặt Vé Xem Phim',
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashScreen(),

    );
  }
}
