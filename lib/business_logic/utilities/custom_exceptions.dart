import 'package:equatable/equatable.dart';

class CustomException extends Equatable implements Exception {
  final String message;

  const CustomException({this.message = ""});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NoInternetException extends CustomException {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ServerErrorException extends CustomException {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RefreshTokenException extends CustomException {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AccessTokenException extends CustomException {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NoResponseException extends CustomException {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}