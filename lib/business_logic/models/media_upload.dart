class MediaUpload {
  final String referenceId;
  final String mediaType;
  final String extension;
  final bool isPrivate;
  final String purpose;

  MediaUpload({
    required this.referenceId,
    required this.mediaType,
    required this.extension,
    required this.isPrivate,
    required this.purpose,
  });

  factory MediaUpload.fromJson(Map<String, dynamic> json) {
    return MediaUpload(
      referenceId: json['reference_id'],
      mediaType: json['media_type'],
      extension: json['extension'],
      isPrivate: json['visibility'] == 'private' ? true : false,
      purpose: json['purpose'],
    );
  }
}