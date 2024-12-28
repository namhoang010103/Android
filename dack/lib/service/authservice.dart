import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream để lắng nghe trạng thái xác thực của người dùng
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Lấy người dùng hiện tại
  User? get currentUser => _firebaseAuth.currentUser;

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
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi từ Firebase
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

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Tài khoản không tồn tại.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Mật khẩu không đúng.');
      } else {
        throw Exception('Đăng nhập thất bại. Vui lòng thử lại.');
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
      return userCredential.user;
    } catch (e) {
      throw Exception('Lỗi đăng nhập với Google: $e');
    }
  }

  /// Đăng xuất
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Lỗi đăng xuất: $e');
    }
  }
}
