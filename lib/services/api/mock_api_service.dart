import 'dart:async';
import 'dart:convert';
import 'package:paper_bulls/services/api/api_constants.dart';
import 'package:paper_bulls/services/api/api_exception.dart';
import 'package:paper_bulls/services/api/api_service.dart';
import 'package:paper_bulls/services/api/mock_responses.dart';

/// Mock implementation of the API Service for development and testing
class MockApiService extends ApiService {
  // Simulate network delay
  final Duration _delay = const Duration(milliseconds: 500);
  
  // Store the auth token
  String? _authToken;
  
  @override
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    await Future.delayed(_delay);
    
    // Check authentication for protected endpoints
    if (_requiresAuth(endpoint) && !_isAuthenticated(headers)) {
      return MockResponses.errorResponse('UNAUTHORIZED', 'Authentication required');
    }
    
    // Handle different endpoints
    if (endpoint == ApiConstants.authUserProfile) {
      return MockResponses.userProfileResponse;
    } else if (endpoint == ApiConstants.tradingFunds) {
      return MockResponses.fundDetailsResponse;
    } else if (endpoint == ApiConstants.tradingBundle) {
      return MockResponses.bundleResponse;
    } else if (endpoint == ApiConstants.tradingPnl) {
      return MockResponses.pnlOverviewResponse;
    } else if (endpoint.contains('/api/mock-trading/') && endpoint.contains('/lifetime-pnl')) {
      return MockResponses.lifetimePnlResponse;
    }
    
    // Default error for unknown endpoints
    return MockResponses.errorResponse('NOT_FOUND', 'Endpoint not found');
  }
  
  @override
  Future<dynamic> post(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    await Future.delayed(_delay);
    
    // Parse the request body if it's a string
    final requestBody = body is String ? json.decode(body) : body;
    
    // Handle different endpoints
    if (endpoint == ApiConstants.authOtpLogin) {
      return _handleOtpLogin(requestBody);
    } else if (endpoint == ApiConstants.authVerifyOtp) {
      return _handleVerifyOtp(requestBody);
    } else if (endpoint == ApiConstants.authUserStatus) {
      // Check authentication
      if (!_isAuthenticated(headers)) {
        return MockResponses.errorResponse('UNAUTHORIZED', 'Authentication required');
      }
      return MockResponses.userProfileResponse;
    } else if (endpoint == ApiConstants.tradingAllocateCapital) {
      // Check authentication
      if (!_isAuthenticated(headers)) {
        return MockResponses.errorResponse('UNAUTHORIZED', 'Authentication required');
      }
      return _handleAllocateCapital(requestBody);
    } else if (endpoint == ApiConstants.tradingForwardTest) {
      // Check authentication
      if (!_isAuthenticated(headers)) {
        return MockResponses.errorResponse('UNAUTHORIZED', 'Authentication required');
      }
      return MockResponses.forwardTestResponse;
    } else if (endpoint == ApiConstants.tradingPnl) {
      // Check authentication
      if (!_isAuthenticated(headers)) {
        return MockResponses.errorResponse('UNAUTHORIZED', 'Authentication required');
      }
      return MockResponses.calculatePnlResponse;
    }
    
    // Default error for unknown endpoints
    return MockResponses.errorResponse('NOT_FOUND', 'Endpoint not found');
  }
  
  @override
  Future<dynamic> put(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    await Future.delayed(_delay);
    
    // Check authentication for protected endpoints
    if (_requiresAuth(endpoint) && !_isAuthenticated(headers)) {
      return MockResponses.errorResponse('UNAUTHORIZED', 'Authentication required');
    }
    
    // Parse the request body if it's a string
    final requestBody = body is String ? json.decode(body) : body;
    
    // Handle different endpoints
    if (endpoint == ApiConstants.authUserStatus) {
      return MockResponses.userProfileResponse;
    }
    
    // Default error for unknown endpoints
    return MockResponses.errorResponse('NOT_FOUND', 'Endpoint not found');
  }
  
  // Helper methods
  Map<String, dynamic> _handleOtpLogin(dynamic requestBody) {
    if (requestBody == null || !requestBody.containsKey('phone_number')) {
      return MockResponses.errorResponse('INVALID_INPUT', 'Phone number is required');
    }
    
    final phoneNumber = requestBody['phone_number'];
    if (phoneNumber == null || phoneNumber.toString().isEmpty) {
      return MockResponses.errorResponse('INVALID_INPUT', 'Phone number is required');
    }
    
    return MockResponses.otpLoginResponse;
  }
  
  Map<String, dynamic> _handleVerifyOtp(dynamic requestBody) {
    if (requestBody == null || 
        !requestBody.containsKey('otp') || 
        !requestBody.containsKey('hash')) {
      return MockResponses.errorResponse('INVALID_INPUT', 'OTP and hash are required');
    }
    
    final otp = requestBody['otp'];
    final hash = requestBody['hash'];
    
    if (otp == null || otp.toString().isEmpty || 
        hash == null || hash.toString().isEmpty) {
      return MockResponses.errorResponse('INVALID_INPUT', 'OTP and hash are required');
    }
    
    // For testing, accept any OTP for the mock hash
    if (hash == MockResponses.otpLoginResponse['data']['hash']) {
      // Store the token for future requests
      _authToken = MockResponses.verifyOtpResponse['data']['token'];
      return MockResponses.verifyOtpResponse;
    }
    
    return MockResponses.errorResponse('INVALID_INPUT', 'Invalid OTP or hash');
  }
  
  Map<String, dynamic> _handleAllocateCapital(dynamic requestBody) {
    if (requestBody == null || !requestBody.containsKey('capital')) {
      return MockResponses.errorResponse('INVALID_INPUT', 'Capital amount is required');
    }
    
    final capital = requestBody['capital'];
    if (capital == null || capital <= 0) {
      return MockResponses.errorResponse('INVALID_INPUT', 'Capital amount must be positive');
    }
    
    // Update the response with the provided capital
    final response = Map<String, dynamic>.from(MockResponses.allocateCapitalResponse);
    response['data']['capitalAmount'] = capital;
    
    return response;
  }
  
  bool _requiresAuth(String endpoint) {
    // All endpoints except OTP login and verify require authentication
    return endpoint != ApiConstants.authOtpLogin && 
           endpoint != ApiConstants.authVerifyOtp;
  }
  
  bool _isAuthenticated(Map<String, String>? headers) {
    if (headers == null) return false;
    
    // Check for Authorization header
    final authHeader = headers['Authorization'];
    if (authHeader == null) return false;
    
    // Check if the token matches our stored token
    final token = authHeader.replaceFirst('Bearer ', '');
    return token == _authToken;
  }
}
