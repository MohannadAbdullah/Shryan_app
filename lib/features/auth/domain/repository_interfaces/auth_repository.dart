import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// تسجيل مستخدم جديد بالبريد وكلمة المرور وحفظ بياناته في Firestore
  Future<UserEntity> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String bloodType,
    required String gender,
    required int age,
    required String city,
    required String area,
    String? lastDonationDate,
  });

  /// تسجيل الدخول
  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  /// تسجيل الخروج
  Future<void> signOut();

  /// المستخدم الحالي (null إذا لم يكن مسجلاً)
  Future<UserEntity?> getCurrentUser();

  /// إرسال رابط إعادة تعيين كلمة المرور إلى البريد الإلكتروني
  Future<void> sendPasswordReset({required String email});

  /// حذف حساب المستخدم الحالي نهائياً من Firebase Auth و Firestore
  Future<void> deleteAccount();
}
