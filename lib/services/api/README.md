# Mock API Implementation for Paper Bulls

This directory contains a mock API implementation for the Paper Bulls application. The mock API is designed to mimic the behavior of the real API, allowing development and testing without requiring the actual backend.

## Key Features

- Centralized API constants in `api_constants.dart`
- Easy switching between mock and real API by changing a single flag
- Consistent error handling
- Mock responses that match the expected API contract
- Simulated network delay for realistic testing

## How to Use

### 1. Configure the API

The API configuration is in `api_constants.dart`. To switch between mock and real API, change the `useMockApi` flag:

```dart
// Set this to false to use the production API
static const bool useMockApi = true;
```

### 2. Create an API Client

```dart
final apiClient = ApiClient();
```

### 3. Make API Calls

```dart
// Authentication
final otpResponse = await apiClient.requestOtp('9090909009');
final verifyResponse = await apiClient.verifyOtp('123456', otpResponse['data']['hash']);

// Trading
final capitalResponse = await apiClient.allocateCapital(400000.0);
final forwardResponse = await apiClient.startForwardTest();
final fundsResponse = await apiClient.getFundDetails();

// PnL Data
final pnlResponse = await apiClient.getPnLSummary(
  userType: 'backtest',
  fromDate: DateTime(2023, 1, 1),
  toDate: DateTime(2023, 12, 31),
);
```

## Files Overview

- `api_constants.dart` - Contains all API endpoints and configuration
- `api_exception.dart` - Custom exception class for API errors
- `api_service.dart` - Base API service for making HTTP requests
- `api_client.dart` - Client that provides methods for all API endpoints
- `mock_api_service.dart` - Mock implementation of the API service
- `mock_responses.dart` - Mock response data for all endpoints
- `api_usage_example.dart` - Examples of how to use the API client

## Switching to Live API

When the live API is ready, simply change the `useMockApi` flag to `false` in `api_constants.dart`. You may also need to update the `prodBaseUrl` to point to the correct API endpoint.

## Response Format

All API responses follow this format:

```json
{
  "success": true,
  "message": "Optional success message",
  "data": {
    // Response data
  }
}
```

For errors:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message"
  }
}
```

## Testing Credentials

For testing with the mock API, you can use:

- Phone: 9090909009
- OTP: Any value (the mock API accepts any OTP)
