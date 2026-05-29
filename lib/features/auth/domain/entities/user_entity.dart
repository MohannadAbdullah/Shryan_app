class UserEntity {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String bloodType;
  final String gender;
  final int age;
  final String city;
  final String area;
  final String? lastDonationDate;
  final DateTime createdAt;
  final int donationsCount;
  final int points;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.bloodType,
    required this.gender,
    required this.age,
    required this.city,
    required this.area,
    this.lastDonationDate,
    required this.createdAt,
    this.donationsCount = 0,
    this.points = 0,
  });
}
