import 'package:paper_bulls/services/api/api_constants.dart';
import 'package:paper_bulls/services/api/api_service.dart';
import 'package:paper_bulls/services/storage_service.dart';

/// API Client for the Paper Bulls application
/// This class provides methods for all API endpoints
class ApiClient {
  final ApiService _apiService;
  final StorageService _storageService;
  
  ApiClient({
    ApiService? apiService,
    StorageService? storageService,
  }) : 
    _apiService = apiService ?? ApiService.create(),
    _storageService = storageService ?? StorageService();
  
  // Authentication methods
  
  /// Request OTP for login
  Future<Map<String, dynamic>> requestOtp(String phoneNumber) async {
    final response = await _apiService.post(
      ApiConstants.authOtpLogin,
      body: {'phone_number': phoneNumber},
    );
    return response;
  }
  
  /// Verify OTP and get auth token
  Future<Map<String, dynamic>> verifyOtp(String otp, String hash) async {
    final response = await _apiService.post(
      ApiConstants.authVerifyOtp,
      body: {'otp': otp, 'hash': hash},
    );
    
    // Store the token if successful
    if (response['success'] == true && response['data'] != null) {
      final token = response['data']['token'];
      if (token != null) {
        await _storageService.saveAuthToken(token);
      }
    }
    
    return response;
  }
  
  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await _storageService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    final response = await _apiService.get(
      ApiConstants.authUserProfile,
      headers: ApiConstants.authHeaders(token),
    );
    return response;
  }
  
  /// Update user status
  Future<Map<String, dynamic>> updateUserStatus(String status) async {
    final token = await _storageService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    final response = await _apiService.post(
      ApiConstants.authUserStatus,
      headers: ApiConstants.authHeaders(token),
      body: {'status': status},
    );
    return response;
  }
  
  // Trading methods
  
  /// Allocate capital to trading account
  Future<Map<String, dynamic>> allocateCapital(double capital) async {
    final token = await _storageService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    final response = await _apiService.post(
      ApiConstants.tradingAllocateCapital,
      headers: ApiConstants.authHeaders(token),
      body: {'capital': capital},
    );
    return response;
  }
  
  /// Start forward testing
  Future<Map<String, dynamic>> startForwardTest() async {
    final token = await _storageService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    final response = await _apiService.post(
      ApiConstants.tradingForwardTest,
      headers: ApiConstants.authHeaders(token),
    );
    return response;
  }
  
  /// Get fund details
  Future<Map<String, dynamic>> getFundDetails() async {
    final token = await _storageService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    final response = await _apiService.get(
      ApiConstants.tradingFunds,
      headers: ApiConstants.authHeaders(token),
    );
    return response;
  }
  
  /// Get trading status (from bundle info)
  Future<Map<String, dynamic>> getTradingStatus() async {
    final token = await _storageService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    final response = await _apiService.get(
      ApiConstants.tradingBundle,
      headers: ApiConstants.authHeaders(token),
    );
    return response;
  }
  
  // PnL methods
  
  /// Get PnL summary (lifetime PnL)
  Future<Map<String, dynamic>> getPnLSummary({
    required String userType,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final token = await _storageService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    // Build query parameters
    final queryParams = <String, String>{};
    if (fromDate != null) {
      queryParams['fromDate'] = fromDate.toIso8601String();
    }
    if (toDate != null) {
      queryParams['toDate'] = toDate.toIso8601String();
    }
    
    // Build the endpoint with query parameters
    String endpoint = ApiConstants.tradingLifetimePnl(userType);
    if (queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      endpoint = '$endpoint?$queryString';
    }
    
    final response = await _apiService.get(
      endpoint,
      headers: ApiConstants.authHeaders(token),
    );
    return response;
  }
  
  /// Get PnL detailed data
  Future<Map<String, dynamic>> getPnLDetailed({String? period}) async {
    final token = await _storageService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    // Build the endpoint with query parameters
    String endpoint = ApiConstants.tradingPnl;
    if (period != null) {
      endpoint = '$endpoint?period=${Uri.encodeComponent(period)}';
    }
    
    final response = await _apiService.get(
      endpoint,
      headers: ApiConstants.authHeaders(token),
    );
    return response;
  }
  
  /// Calculate PnL for date range
  Future<Map<String, dynamic>> calculatePnL({
    required DateTime fromDate,
    required DateTime toDate,
    String? bundleId,
  }) async {
    final token = await _storageService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    
    final body = {
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
    };
    
    if (bundleId != null) {
      body['bundleId'] = bundleId;
    }
    
    final response = await _apiService.post(
      ApiConstants.tradingPnl,
      headers: ApiConstants.authHeaders(token),
      body: body,
    );
    return response;
  }
}
