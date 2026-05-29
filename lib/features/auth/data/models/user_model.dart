import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharyan/features/auth/domain/entities/user_entity.dart';

/// Data model for a donor user.
/// Extends [UserEntity] and handles serialization to/from Firestore.
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.phone,
    required super.bloodType,
    required super.gender,
    required super.age,
    required super.city,
    required super.area,
    super.lastDonationDate,
    required super.createdAt,
    super.donationsCount = 0,
    super.points = 0,
  });

  /// تحويل من Firestore document إلى Model
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    int parsedAge = 0;
    if (data['age'] != null) {
      if (data['age'] is num) {
        parsedAge = (data['age'] as num).toInt();
      } else if (data['age'] is String) {
        parsedAge = int.tryParse(data['age'] as String) ?? 0;
      }
    }

    return UserModel(
      uid: uid,
      email:     (data['email']     ?.toString() ?? '').trim(),
      name:      (data['name']      ?.toString() ?? '').trim(),
      phone:     (data['phone']     ?.toString() ?? '').trim(),
      bloodType: (data['bloodType'] ?.toString() ?? '').trim(),
      gender:    (data['gender']    ?.toString() ?? '').trim(),
      age:       parsedAge,
      city:      (data['city']      ?.toString() ?? '').trim(),
      area:      (data['area']      ?.toString() ?? '').trim(),
      lastDonationDate: data['lastDonationDate']?.toString().trim(),
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      donationsCount: (data['donationsCount'] as num?)?.toInt() ?? 0,
      points:         (data['points']         as num?)?.toInt() ?? 0,
    );
  }

  /// تحويل من Entity إلى Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'bloodType': bloodType,
      'gender': gender,
      'age': age,
      'city': city,
      'area': area,
      'lastDonationDate': lastDonationDate,
      'createdAt': Timestamp.fromDate(createdAt),
      'isAvailableToDonate': true,   // ← يُضاف تلقائياً عند التسجيل
      'donationsCount': 0,           // ← عداد التبرعات يبدأ من صفر
      'points': 0,                   // ← النقاط تبدأ من صفر
    };
  }

  /// تحويل من Entity عادي إلى Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      phone: entity.phone,
      bloodType: entity.bloodType,
      gender: entity.gender,
      age: entity.age,
      city: entity.city,
      area: entity.area,
      lastDonationDate: entity.lastDonationDate,
      createdAt: entity.createdAt,
      donationsCount: entity.donationsCount,
      points: entity.points,
    );
  }
}
