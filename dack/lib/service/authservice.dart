import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lưu thông tin người dùng vào Firestore
  Future<void> saveUserToFirestore(User user, {String? name}) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);

      // Kiểm tra xem user đã tồn tại trong Firestore chưa
      final doc = await userRef.get();
      if (!doc.exists) {
        await userRef.set({
          'uid': user.uid,
          'name': name ?? user.displayName ?? '',
          'email': user.email ?? '',
          'avatarUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Lỗi lưu dữ liệu vào Firestore: $e');
    }
  }

  /// Đăng ký với Email và Password
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Cập nhật tên người dùng
      await userCredential.user?.updateDisplayName(name);

      // Lưu thông tin người dùng vào Firestore
      await saveUserToFirestore(userCredential.user!, name: name);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email này đã được sử dụng.');
      } else if (e.code == 'weak-password') {
        throw Exception('Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn.');
      } else {
        throw Exception('Đăng ký thất bại. Vui lòng thử lại.');
      }
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  /// Đăng nhập với Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Người dùng hủy đăng nhập với Google');
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _firebaseAuth.signInWithCredential(credential);

      // Lưu thông tin người dùng vào Firestore (nếu chưa tồn tại)
      await saveUserToFirestore(userCredential.user!);

      return userCredential.user;
    } catch (e) {
      throw Exception('Lỗi đăng nhập với Google: $e');
    }
  }
}
