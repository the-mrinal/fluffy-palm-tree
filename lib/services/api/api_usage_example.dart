import 'package:paper_bulls/services/api/api_client.dart';

/// Example of how to use the API client
class ApiUsageExample {
  final ApiClient _apiClient = ApiClient();
  
  /// Example of authentication flow
  Future<void> authenticateUser(String phoneNumber) async {
    try {
      // Step 1: Request OTP
      final otpResponse = await _apiClient.requestOtp(phoneNumber);
      if (otpResponse['success'] == true) {
        final hash = otpResponse['data']['hash'];
        
        // In a real app, the user would enter the OTP they received
        final otp = '123456'; // This would come from user input
        
        // Step 2: Verify OTP
        final verifyResponse = await _apiClient.verifyOtp(otp, hash);
        if (verifyResponse['success'] == true) {
          print('Authentication successful!');
          
          // Step 3: Get user profile
          final profileResponse = await _apiClient.getUserProfile();
          if (profileResponse['success'] == true) {
            final userData = profileResponse['data'];
            print('User: ${userData['name']}');
          }
        } else {
          print('OTP verification failed: ${verifyResponse['error']['message']}');
        }
      } else {
        print('OTP request failed: ${otpResponse['error']['message']}');
      }
    } catch (e) {
      print('Authentication error: $e');
    }
  }
  
  /// Example of trading flow
  Future<void> startTrading() async {
    try {
      // Step 1: Allocate capital
      final capitalResponse = await _apiClient.allocateCapital(400000.0);
      if (capitalResponse['success'] == true) {
        print('Capital allocated: ${capitalResponse['data']['capitalAmount']}');
        
        // Step 2: Start forward testing
        final forwardResponse = await _apiClient.startForwardTest();
        if (forwardResponse['success'] == true) {
          print('Forward testing started: ${forwardResponse['status']}');
          
          // Step 3: Get fund details
          final fundsResponse = await _apiClient.getFundDetails();
          if (fundsResponse['success'] == true) {
            final fundsData = fundsResponse['data'];
            print('Current value: ${fundsData['currentValue']}');
            print('Net profit: ${fundsData['netProfit']}');
          }
        }
      }
    } catch (e) {
      print('Trading error: $e');
    }
  }
  
  /// Example of PnL data retrieval
  Future<void> getPnLData() async {
    try {
      // Get PnL summary for backtesting
      final pnlResponse = await _apiClient.getPnLSummary(
        userType: 'backtest',
        fromDate: DateTime(2023, 1, 1),
        toDate: DateTime(2023, 12, 31),
      );
      
      if (pnlResponse['success'] == true) {
        final pnlData = pnlResponse['data'];
        print('Net profit: ${pnlData['netProfit']}');
        print('Growth: ${pnlData['growthPercentage']}%');
        print('Trade count: ${pnlData['tradeCount']}');
        
        // Get detailed PnL data
        final detailedResponse = await _apiClient.getPnLDetailed(period: '1M');
        if (detailedResponse['success'] == true) {
          final monthlyData = detailedResponse['data'];
          print('Monthly PnL data: $monthlyData');
        }
      }
    } catch (e) {
      print('PnL data error: $e');
    }
  }
}
