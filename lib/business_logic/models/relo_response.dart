class ReloResponse {
  final bool success;
  final dynamic message;

  ReloResponse({required this.success, required this.message});

  factory ReloResponse.fromJson(Map<String, dynamic> json) {
    return ReloResponse(success: json["success"], message: json["message"]);
  }

  String getLocalErrorMessage() {
    return "";
  }
}