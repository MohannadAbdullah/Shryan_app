/// Entity للمستشفى — وثيقة في collection "hospital"
/// الحقول: uid (Document ID) + email فقط
/// كلمة المرور تُدار بواسطة Firebase Authentication
class HospitalEntity {
  final String uid;
  final String email;

  const HospitalEntity({
    required this.uid,
    required this.email,
  });
}
