import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_event.dart';
import 'package:paper_bulls/bloc/auth/auth_state.dart';
import 'package:paper_bulls/models/user_model.dart';
import 'package:paper_bulls/services/auth_service.dart';
import 'package:paper_bulls/services/storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final StorageService _storageService;
  
  AuthBloc({
    required AuthService authService,
    required StorageService storageService,
  }) : 
    _authService = authService,
    _storageService = storageService,
    super(AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthVerifyOtpRequested>(_onAuthVerifyOtpRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }
  
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      final userJson = await _storageService.getUserInfo();
      
      if (userJson != null) {
        final user = UserModel.fromJson(userJson);
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      final success = await _authService.requestOtp(event.mobileNumber);
      
      if (success) {
        emit(state.copyWith(status: AuthStatus.otpSent));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to send OTP',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  Future<void> _onAuthVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      final result = await _authService.verifyOtp(
        event.mobileNumber,
        event.otp,
      );
      
      if (result.user != null) {
        await _storageService.saveAuthToken(result.token);
        await _storageService.saveUserInfo(result.user!.toJson());
        
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: result.user,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid OTP',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      await _storageService.clearAuthToken();
      await _storageService.clearUserInfo();
      
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  void _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      user: event.user,
    ));
  }
}
