class LoginCommand {
  final String authType;
  final String? email;
  final String? password;
  final String? token;

  LoginCommand({
    required this.authType,
    this.email,
    this.password,
    this.token,
  });
}
