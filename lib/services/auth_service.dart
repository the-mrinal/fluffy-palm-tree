import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paper_bulls/models/user_model.dart';
import 'package:paper_bulls/utils/constants.dart';

class AuthResult {
  final UserModel? user;
  final String token;
  
  AuthResult({
    this.user,
    required this.token,
  });
}

class AuthService {
  final http.Client _httpClient;
  
  AuthService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();
  
  // For demo purposes, we'll simulate API calls
  Future<bool> requestOtp(String mobileNumber) async {
    // In a real app, this would make an API call
    // For demo, we'll simulate a successful OTP request
    await Future.delayed(const Duration(seconds: 1));
    
    // Validate mobile number (simple validation)
    if (mobileNumber.length != 10) {
      throw Exception(AppConstants.invalidMobileErrorMessage);
    }
    
    return true;
  }
  
  Future<AuthResult> verifyOtp(String mobileNumber, String otp) async {
    // In a real app, this would make an API call
    // For demo, we'll simulate a successful verification
    await Future.delayed(const Duration(seconds: 1));
    
    // Validate OTP (simple validation)
    if (otp.length != 4) {
      throw Exception(AppConstants.invalidOtpErrorMessage);
    }
    
    // For demo, we'll accept any 4-digit OTP
    // Create a mock user
    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Demo User',
      mobileNumber: mobileNumber,
      isVerified: true,
    );
    
    // Create a mock token
    const token = 'mock_auth_token_123456789';
    
    return AuthResult(user: user, token: token);
  }
  
  // In a real app, you would have more methods like:
  // - refreshToken
  // - updateUserProfile
  // - changePassword
  // etc.
}
