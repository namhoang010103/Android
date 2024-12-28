import 'package:flutter/material.dart';
import 'service/firebase_service.dart';
import 'utils/routes.dart';

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
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
