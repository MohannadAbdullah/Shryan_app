import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharyan/features/auth/domain/entities/user_entity.dart';
import 'package:sharyan/features/auth/domain/repository_interfaces/auth_repository.dart';
import 'package:sharyan/features/auth/data/models/user_model.dart';

/// Firebase implementation of [AuthRepository].
/// Handles donor registration and sign-in via FirebaseAuth + Firestore.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _usersCollection = 'users';

  @override
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
  }) async {
    // 1. إنشاء الحساب في Firebase Auth
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user!.uid;

    // 2. تحديث اسم المستخدم في Auth profile
    await credential.user!.updateDisplayName(name);

    // 3. بناء الـ model وحفظه في Firestore
    final userModel = UserModel(
      uid: uid,
      email: email.trim(),
      name: name,
      phone: phone,
      bloodType: bloodType,
      gender: gender,
      age: age,
      city: city,
      area: area,
      lastDonationDate: lastDonationDate,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .set(userModel.toFirestore());

    return userModel;
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user!.uid;
    final doc = await _firestore.collection(_usersCollection).doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('لم يتم العثور على بيانات المستخدم');
    }

    return UserModel.fromFirestore(doc.data()!, uid);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection(_usersCollection).doc(user.uid).get();
    if (!doc.exists || doc.data() == null) return null;

    return UserModel.fromFirestore(doc.data()!, user.uid);
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('المستخدم غير مسجّل الدخول');

    // حذف بيانات المستخدم من Firestore أولاً
    await _firestore.collection(_usersCollection).doc(user.uid).delete();

    // ثم حذف الحساب من Firebase Auth
    await user.delete();
  }
}
