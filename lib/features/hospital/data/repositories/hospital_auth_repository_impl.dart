import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharyan/features/hospital/domain/entities/hospital_entity.dart';
import 'package:sharyan/features/hospital/domain/repository_interfaces/hospital_auth_repository.dart';

/// Firebase/Firestore implementation of [HospitalAuthRepository].
/// Hospitals are authenticated via plain Firestore credentials (not FirebaseAuth).
class HospitalAuthRepositoryImpl implements HospitalAuthRepository {
  final FirebaseFirestore _firestore;

  HospitalAuthRepositoryImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'hospital';
  static const String _hospitalIdKey = 'hospital_id';

  // ─── signIn ───────────────────────────────────────────────────────────────
  @override
  Future<HospitalEntity> signIn({
    required String email,
    required String password,
  }) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('email', isEqualTo: email.trim())
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('invalid_credentials');
    }

    final doc = querySnapshot.docs.first;
    final uid = doc.id;

    // حفظ معرّف المستشفى في الجهاز للحفاظ على الجلسة
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hospitalIdKey, uid);

    return _fromDoc(doc.data(), uid);
  }

  // ─── signOut ──────────────────────────────────────────────────────────────
  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hospitalIdKey);
  }

  // ─── getCurrentHospital ───────────────────────────────────────────────────
  @override
  Future<HospitalEntity?> getCurrentHospital() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(_hospitalIdKey);
    if (uid == null) return null;

    final doc = await _firestore.collection(_collection).doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      await prefs.remove(_hospitalIdKey);
      return null;
    }

    return _fromDoc(doc.data()!, uid);
  }

  // ─── تحويل بيانات Firestore ───────────────────────────────────────────────
  HospitalEntity _fromDoc(Map<String, dynamic> data, String uid) {
    return HospitalEntity(
      uid: uid,
      email: (data['email'] as String? ?? '').trim(),
      name: (data['name'] as String? ?? 'مستشفى').trim(),
    );
  }
}
