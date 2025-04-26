/// Mock API responses for development and testing
class MockResponses {
  // Authentication responses
  static Map<String, dynamic> otpLoginResponse = {
    "success": true,
    "message": "OTP sent successfully",
    "data": {
      "hash": "mock_hash_value_12345"
    }
  };
  
  static Map<String, dynamic> verifyOtpResponse = {
    "success": true,
    "message": "OTP verified successfully",
    "data": {
      "token": "mock_jwt_token_12345",
      "token_type": "bearer",
      "user_id": "1",
      "username": "Test User"
    }
  };
  
  static Map<String, dynamic> userProfileResponse = {
    "success": true,
    "data": {
      "id": "user_123",
      "name": "Test User",
      "mobileNumber": "9090909009",
      "email": "test.user@testing.com",
      "profilePicture": "https://example.com/profile.jpg",
      "isVerified": true
    }
  };
  
  // Trading responses
  static Map<String, dynamic> allocateCapitalResponse = {
    "success": true,
    "data": {
      "tradingId": "trading_account_123",
      "capitalAmount": 400000.0
    }
  };
  
  static Map<String, dynamic> forwardTestResponse = {
    "success": true,
    "message": "Forward testing started successfully",
    "status": "CAPITAL_ALLOCATED"
  };
  
  static Map<String, dynamic> fundDetailsResponse = {
    "success": true,
    "data": {
      "totalInvested": 400000.0,
      "currentValue": 450000.0,
      "netProfit": 50000.0,
      "growthPercentage": 12.5
    }
  };
  
  static Map<String, dynamic> bundleResponse = {
    "success": true,
    "data": {
      "bundleId": "bundle_123",
      "tradingId": "trading_account_123",
      "tradingMode": "backTesting",
      "fromDate": "2023-01-01T00:00:00Z",
      "toDate": "2023-12-31T00:00:00Z",
      "capitalAmount": 400000.0,
      "status": "ACTIVE",
      "lastUpdated": "2023-12-31T10:30:00Z"
    }
  };
  
  // PnL responses
  static Map<String, dynamic> lifetimePnlResponse = {
    "success": true,
    "data": {
      "netProfit": 50000.0,
      "growthPercentage": 12.5,
      "tradeCount": 35,
      "currentValue": 450000.0,
      "medianCapital": 425000.0,
      "dataPoints": _generateDataPoints(),
      "monthlyData": _generateMonthlyData(),
      "weeklyData": _generateWeeklyData()
    }
  };
  
  static Map<String, dynamic> pnlOverviewResponse = {
    "success": true,
    "data": [
      {
        "monthIdentifier": "Jan 2023",
        "history": [
          {
            "label": "Jan 2023",
            "realised_pnl": 15000.0,
            "realised_percentage": 3.75,
            "trade_count": 7,
            "charges": 350.0,
            "breakdown": _generateWeeklyBreakdown()
          }
        ]
      },
      {
        "monthIdentifier": "Feb 2023",
        "history": [
          {
            "label": "Feb 2023",
            "realised_pnl": 18000.0,
            "realised_percentage": 4.5,
            "trade_count": 9,
            "charges": 420.0,
            "breakdown": _generateWeeklyBreakdown()
          }
        ]
      }
    ]
  };
  
  static Map<String, dynamic> calculatePnlResponse = {
    "success": true,
    "data": {
      "netProfit": 50000.0,
      "growthPercentage": 12.5,
      "tradeCount": 35,
      "dataPoints": _generateDataPoints()
    }
  };
  
  // Helper methods to generate mock data
  static List<Map<String, dynamic>> _generateDataPoints() {
    final List<Map<String, dynamic>> dataPoints = [];
    final startDate = DateTime(2023, 1, 1);
    double fundValue = 400000.0;
    double pnlValue = 0.0;
    
    for (int i = 0; i < 30; i++) {
      final date = startDate.add(Duration(days: i));
      
      // Skip weekends
      if (date.weekday != DateTime.saturday && date.weekday != DateTime.sunday) {
        // Random daily change (-2% to +2%)
        final dailyChange = (fundValue * (i % 5 - 2) / 100);
        
        fundValue += dailyChange;
        pnlValue += dailyChange;
        
        dataPoints.add({
          "date": date.toIso8601String(),
          "pnlValue": pnlValue,
          "fundValue": fundValue
        });
      }
    }
    
    return dataPoints;
  }
  
  static List<Map<String, dynamic>> _generateMonthlyData() {
    return [
      {
        "period": "Jan 2023",
        "tradeCount": 7,
        "amount": 15000.0,
        "percentage": 3.75
      },
      {
        "period": "Feb 2023",
        "tradeCount": 9,
        "amount": 18000.0,
        "percentage": 4.5
      },
      {
        "period": "Mar 2023",
        "tradeCount": 6,
        "amount": 12000.0,
        "percentage": 3.0
      }
    ];
  }
  
  static List<Map<String, dynamic>> _generateWeeklyData() {
    return [
      {
        "period": "Week 1, 2023",
        "tradeCount": 2,
        "amount": 5000.0,
        "percentage": 1.25
      },
      {
        "period": "Week 2, 2023",
        "tradeCount": 3,
        "amount": 7000.0,
        "percentage": 1.75
      },
      {
        "period": "Week 3, 2023",
        "tradeCount": 2,
        "amount": 3000.0,
        "percentage": 0.75
      }
    ];
  }
  
  static List<Map<String, dynamic>> _generateWeeklyBreakdown() {
    return [
      {
        "label": "Week 1, 2023",
        "realised_pnl": 5000.0,
        "realised_percentage": 1.25,
        "fund": 405000.0
      },
      {
        "label": "Week 2, 2023",
        "realised_pnl": 7000.0,
        "realised_percentage": 1.75,
        "fund": 412000.0
      },
      {
        "label": "Week 3, 2023",
        "realised_pnl": 3000.0,
        "realised_percentage": 0.75,
        "fund": 415000.0
      }
    ];
  }
  
  // Error responses
  static Map<String, dynamic> errorResponse(String code, String message) {
    return {
      "success": false,
      "error": {
        "code": code,
        "message": message
      }
    };
  }
}
