// UI에서 사용자가 입력한 데이터를 나르는 순수 객체
class RegisterCommand {
  final String email;
  final String password;
  final String nickname;
  final String? bio;

  RegisterCommand(
      {required this.email,
      required this.password,
      required this.nickname,
      this.bio});
}
