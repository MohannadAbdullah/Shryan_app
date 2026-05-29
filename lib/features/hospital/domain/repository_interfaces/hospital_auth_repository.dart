import '../entities/hospital_entity.dart';

abstract class HospitalAuthRepository {
  /// تسجيل دخول المستشفى — يتحقق من collection "hospital" في Firestore
  Future<HospitalEntity> signIn({
    required String email,
    required String password,
  });

  /// تسجيل الخروج
  Future<void> signOut();

  /// المستشفى المسجّل حالياً (null إذا لم يكن مسجلاً)
  Future<HospitalEntity?> getCurrentHospital();
}
