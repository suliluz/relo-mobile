class SignUpObject {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String country;
  final String accountId;
  final String email;
  final String password;
  final bool optMarketing;

  SignUpObject({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.country,
    required this.accountId,
    required this.email,
    required this.password,
    this.optMarketing = true,
  });
}