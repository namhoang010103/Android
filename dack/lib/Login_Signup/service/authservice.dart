import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SignUp User

  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Tạo tài khoản
        UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Thêm thông tin người dùng vào Firestore
        await FirebaseFirestore.instance.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
        });

        res = "success";
      } else {
        res = "Vui lòng nhập đầy đủ thông tin";
      }
    } on FirebaseAuthException catch (err) {
      // Kiểm tra lỗi Firebase
      if (err.code == 'email-already-in-use') {
        res = "Email đã tồn tại. Vui lòng sử dụng email khác.";
      } else if (err.code == 'invalid-email') {
        res = "Email không hợp lệ. Vui lòng nhập email đúng định dạng.";
      } else if (err.code == 'weak-password') {
        res = "Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn.";
      } else {
        res = err.message ?? "Đã xảy ra lỗi. Vui lòng thử lại.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // logIn user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Đăng nhập người dùng
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        res = "success";
      } else {
        res = "Vui lòng nhập đầy đủ thông tin";
      }
    } on FirebaseAuthException catch (err) {
      // Kiểm tra lỗi từ Firebase
      if (err.code == 'user-not-found') {
        res = "Tài khoản không tồn tại. Vui lòng đăng ký.";
      } else if (err.code == 'wrong-password') {
        res = "Mật khẩu không chính xác. Vui lòng thử lại.";
      } else if (err.code == 'invalid-email') {
        res = "Email không hợp lệ. Vui lòng nhập email đúng định dạng.";
      } else {
        res = err.message ?? "Đã xảy ra lỗi. Vui lòng thử lại.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // for sighout
  signOut() async {
    // await _auth.signOut();
  }
}