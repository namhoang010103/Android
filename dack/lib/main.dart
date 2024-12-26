import 'package:dack/Login_Signup/screen/login_screen.dart';
import 'package:dack/Login_Signup/screen/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Khởi tạo Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return const MaterialApp(
        home: LoginScreen(),
      );
  }
}
