# Paper Bulls Mock API

This project includes a mock API implementation for the Paper Bulls application. The mock API is designed to mimic the behavior of the real API, allowing development and testing without requiring the actual backend.

## Testing the Mock API

To test if the mock API is working correctly, follow these steps:

1. Run the application:
   ```
   flutter run
   ```

2. The app will open with the API Test Page, which provides a UI to test various API endpoints.

3. Follow the authentication flow:
   - Enter a phone number (default: 9090909009)
   - Click "Request OTP" to get a hash
   - Enter an OTP (any value works, default: 123456)
   - Click "Verify OTP" to authenticate

4. Once authenticated, you can test other API endpoints:
   - Get User Profile
   - Allocate Capital
   - Start Forward Test
   - Get Fund Details
   - Get Trading Status
   - Get PnL data

5. The response from each API call will be displayed at the bottom of the screen.

## Mock API Implementation

The mock API implementation is located in the `lib/services/api` directory. Key files include:

- `api_constants.dart` - Contains all API endpoints and configuration
- `api_service.dart` - Base API service for making HTTP requests
- `api_client.dart` - Client that provides methods for all API endpoints
- `mock_api_service.dart` - Mock implementation of the API service
- `mock_responses.dart` - Mock response data for all endpoints

## Switching to Live API

When the live API is ready, simply change the `useMockApi` flag to `false` in `api_constants.dart`. You may also need to update the `prodBaseUrl` to point to the correct API endpoint.

## API Contract

The API contract is defined in `requireapi.md` and follows the OpenAPI specification in `openapi.json`.
