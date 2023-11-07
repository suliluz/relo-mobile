class AgentVerificationObject {
  final String identificationNumber;
  final String bankNumber;
  final List<int> frontIc;
  final List<int> backIc;
  final List<int> selfieWithIc;
  final List<int> passport;
  final List<int> drivingLicense;

  AgentVerificationObject({
    required this.identificationNumber,
    required this.bankNumber,
    required this.frontIc,
    required this.backIc,
    required this.selfieWithIc,
    required this.passport,
    required this.drivingLicense
  });
}