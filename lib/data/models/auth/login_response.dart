class LoginResponse {
  final String token;
  final String username;
  final String empName;
  final String empEmail;
  final String empId;
  final int id;
  final String position;
  final String division;

  const LoginResponse({
    required this.token,
    required this.username,
    required this.empName,
    required this.empEmail,
    required this.empId,
    required this.id,
    required this.position,
    required this.division,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      username: json['username'] as String,
      empName: json['empName'] as String,
      empEmail: json['empEmail'] as String,
      empId: json['empId'] as String,
      id: json['id'] as int,
      position: json['position'] as String,
      division: json['division'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'empName': empName,
      'empEmail': empEmail,
      'empId': empId,
      'id': id,
      'position': position,
      'division': division,
    };
  }
}
