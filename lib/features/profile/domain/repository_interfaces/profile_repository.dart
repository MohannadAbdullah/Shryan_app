import 'package:sharyan/features/auth/domain/entities/user_entity.dart';

/// واجهة مجردة لعمليات البروفايل
abstract class ProfileRepository {
  /// جلب بيانات المستخدم مرة واحدة
  Future<UserEntity?> getUserData(String uid);

  /// تحديث بيانات المستخدم في Firestore
  Future<void> updateUserData({
    required String uid,
    required Map<String, dynamic> data,
  });

  /// Stream للاستماع للتغييرات في الوقت الفعلي
  Stream<UserEntity?> listenToUserData(String uid);
}
