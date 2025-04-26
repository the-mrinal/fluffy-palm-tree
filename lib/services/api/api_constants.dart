/// API Constants for the Paper Bulls application
class ApiConstants {
  // Base URLs
  static const String mockBaseUrl = 'https://mock-api.paperbulls.com';
  static const String prodBaseUrl = 'https://api.paperbulls.com';
  
  // Set this to false to use the production API
  static const bool useMockApi = true;
  
  // Get the active base URL based on the useMockApi flag
  static String get baseUrl => useMockApi ? mockBaseUrl : prodBaseUrl;
  
  // API Endpoints
  static const String authOtpLogin = '/api/auth/v1/otp-login';
  static const String authVerifyOtp = '/api/auth/verify-otp';
  static const String authUserProfile = '/api/auth/user/profile';
  static const String authUserStatus = '/api/auth/user/status';
  
  static const String tradingAllocateCapital = '/api/mock-trading/allocate-capital';
  static const String tradingForwardTest = '/api/mock-trading/forward-test';
  static const String tradingFunds = '/api/mock-trading/funds';
  static const String tradingBundle = '/api/mock-trading/bundle';
  static const String tradingPnl = '/api/mock-trading/pnl';
  
  // Parameterized endpoints
  static String tradingLifetimePnl(String userType) => '/api/mock-trading/$userType/lifetime-pnl';
  
  // HTTP Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> authHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
