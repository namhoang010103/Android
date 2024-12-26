import 'package:flutter/material.dart';
import 'package:dack/Login_Signup/service/authservice.dart';
import 'package:dack/Login_Signup/screen/home_screen.dart';
import 'package:dack/Login_Signup/screen/login_screen.dart';

import '../Widget/button.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
  }

  // Hàm xử lý đăng ký
  void signupUser() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passController.text.isEmpty) {
      showSnackBar(context, "Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (!emailController.text.contains('@')) {
      showSnackBar(context, "Vui lòng nhập email hợp lệ");
      return;
    }

    setState(() {
      isLoading = true;
    });

    String res = await AuthService().signupUser(
      email: emailController.text.trim(),
      password: passController.text.trim(),
      name: nameController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      // Hiển thị thông báo thành công
      showSnackBar(context, "Đăng ký thành công! Vui lòng đăng nhập.");

      // Chuyển người dùng đến LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      // Hiển thị lỗi
      showSnackBar(context, res);
    }
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(

      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Ẩn bàn phím khi nhấn vào màn hình
          },
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: height / 4,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  const SizedBox(height: 20),
                  TextFieldInput(
                    textEditingController: nameController,
                    hintText: "Nhập tên của bạn",
                    icon: Icons.person,
                  ),
                  TextFieldInput(
                    textEditingController: emailController,
                    hintText: "Nhập địa chỉ email",
                    icon: Icons.email,
                  ),
                  TextFieldInput(
                    textEditingController: passController,
                    hintText: "Nhập mật khẩu",
                    icon: Icons.lock,
                    isPass: true,
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.blue)
                      : MyButtons(
                    onTap: signupUser,
                    text: "Đăng ký",
                  ),
                  SizedBox(height: height / 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Bạn đã có tài khoản?",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          " Đăng nhập",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
