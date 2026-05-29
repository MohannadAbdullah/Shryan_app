import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharyan/features/auth/domain/entities/user_entity.dart';
import 'package:sharyan/features/donor_profile/domain/repository_interfaces/profile_repository.dart';
import 'package:sharyan/features/auth/data/models/user_model.dart';

/// Firebase implementation of [ProfileRepository].
/// Manages real-time and one-time reads/writes of donor profile data.
class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  static const String _usersCollection = 'users';

  // ─── جلب UID المستخدم الحالي ──────────────────────────────────────────────
  String? get _currentUid => _auth.currentUser?.uid;

  // ─── getUserData ──────────────────────────────────────────────────────────
  @override
  Future<UserEntity?> getUserData(String uid) async {
    final doc = await _firestore.collection(_usersCollection).doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromFirestore(doc.data()!, uid);
  }

  // ─── updateUserData ───────────────────────────────────────────────────────
  @override
  Future<void> updateUserData({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(_usersCollection).doc(uid).update(data);

    // مزامنة displayName في FirebaseAuth إن تم تعديل الاسم
    if (data.containsKey('name') && _auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(data['name'] as String);
    }
  }

  // ─── listenToUserData (Real-time Stream) ─────────────────────────────────
  @override
  Stream<UserEntity?> listenToUserData(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .snapshots()
        .map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return UserModel.fromFirestore(snap.data()!, uid);
    });
  }

  /// مساعدة — UID المستخدم المسجّل حالياً (قد يكون null)
  String? getCurrentUid() => _currentUid;
}
