import 'package:equatable/equatable.dart';
import 'package:paper_bulls/models/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;
  
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });
  
  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }
  
  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, user, errorMessage];
}
