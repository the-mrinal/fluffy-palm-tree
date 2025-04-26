import 'package:equatable/equatable.dart';
import 'package:paper_bulls/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String mobileNumber;
  
  const AuthLoginRequested({required this.mobileNumber});
  
  @override
  List<Object?> get props => [mobileNumber];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String mobileNumber;
  final String otp;
  
  const AuthVerifyOtpRequested({
    required this.mobileNumber,
    required this.otp,
  });
  
  @override
  List<Object?> get props => [mobileNumber, otp];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthUserUpdated extends AuthEvent {
  final UserModel user;
  
  const AuthUserUpdated({required this.user});
  
  @override
  List<Object?> get props => [user];
}
