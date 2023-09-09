class User {
  User({
    required this.kk,
    required this.phoneNumber,
    required this.password,
  });

  final String kk;
  final String phoneNumber;
  final String password;

  Map toJson() {
    return {
      'kk': kk,
      'tel': phoneNumber,
      'parola': password,
    };
  }
}
