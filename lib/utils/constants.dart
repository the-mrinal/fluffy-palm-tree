class AppConstants {
  // App information
  static const String appName = 'Paper Bulls';
  static const String appVersion = '1.0.0';

  // API endpoints
  static const String baseUrl = 'https://api.marketfeed.com';
  static const String loginEndpoint = '/auth/login';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String tradeIdeasEndpoint = '/trade-ideas';
  static const String pnlDataEndpoint = '/pnl-data';

  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userInfoKey = 'user_info';
  static const String capitalAmountKey = 'capital_amount';
  static const String tradingModeKey = 'trading_mode';
  static const String selectedDateRangeKey = 'selected_date_range';

  // Navigation routes
  static const String dashboardRoute = '/';
  static const String loginRoute = '/login';
  static const String getStartedRoute = '/get-started';
  static const String mockTradingOnboardingRoute = '/mock-trading-onboarding';
  static const String tradingOptionsSelectionRoute = '/trading-options-selection';
  static const String mockTradingDashboardRoute = '/mock-trading-dashboard';
  static const String pnlOverviewRoute = '/pnl-overview';
  static const String apiTestRoute = '/api-test';

  // External links
  static const String marketfeedWebsite = 'https://www.marketfeed.com';

  // Default values
  static const double defaultCapitalAmount = 100000.0;

  // Date formats
  static const String dateFormatDisplay = 'dd MMM yyyy';
  static const String dateFormatApi = 'yyyy-MM-dd';

  // Error messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String invalidInputErrorMessage = 'Please enter valid information.';
  static const String invalidMobileErrorMessage = 'Please enter a valid 10-digit mobile number.';
  static const String invalidOtpErrorMessage = 'Please enter a valid OTP.';
  static const String invalidAmountErrorMessage = 'Please enter a valid amount.';
  static const String invalidDateRangeErrorMessage = 'Please select a valid date range.';
}
