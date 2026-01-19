class User {
  final int id;
  final String? email;
  final String nickname;
  final String? bio;
  final String authType;
  final String createdAt;

  User({
    required this.id,
    this.email,
    required this.nickname,
    this.bio,
    required this.authType,
    required this.createdAt,
  });
}
