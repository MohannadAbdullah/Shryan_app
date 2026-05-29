class HospitalRequest {
  final String hospitalName;
  final String bloodType;
  final int requiredDonors;
  final int availableDonors;
  final DateTime timeLimit;

  HospitalRequest({
    required this.hospitalName,
    required this.bloodType,
    required this.requiredDonors,
    required this.availableDonors,
    required this.timeLimit,
  });

  factory HospitalRequest.fromJson(Map<String, dynamic> json) {
    return HospitalRequest(
      hospitalName: json['hospitalName'] as String,
      bloodType: json['bloodType'] as String,
      requiredDonors: json['requiredDonors'] as int,
      availableDonors: json['availableDonors'] as int,
      timeLimit: DateTime.parse(json['timeLimit'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hospitalName': hospitalName,
      'bloodType': bloodType,
      'requiredDonors': requiredDonors,
      'availableDonors': availableDonors,
      'timeLimit': timeLimit.toIso8601String(),
    };
  }
}
