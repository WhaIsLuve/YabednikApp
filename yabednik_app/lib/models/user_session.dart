class UserSession {
  final String username;
  final String password;
  final String role; // "student" или "teacher"

  UserSession({
    required this.username,
    required this.password,
    required this.role,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      username: json['username'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'role': role,
    };
  }
}