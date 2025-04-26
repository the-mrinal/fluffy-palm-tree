import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paper_bulls/services/api/api_constants.dart';
import 'package:paper_bulls/services/api/api_exception.dart';
import 'package:paper_bulls/services/api/mock_api_service.dart';

/// Base API Service for handling HTTP requests
class ApiService {
  final http.Client _client;
  
  ApiService({http.Client? client}) : _client = client ?? http.Client();
  
  /// Factory constructor to get either mock or real API service
  factory ApiService.create() {
    return ApiConstants.useMockApi 
        ? MockApiService() 
        : ApiService();
  }
  
  /// Perform a GET request
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await _client.get(url, headers: headers ?? ApiConstants.headers);
      return _processResponse(response);
    } catch (e) {
      throw ApiException('Failed to perform GET request: $e');
    }
  }
  
  /// Perform a POST request
  Future<dynamic> post(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await _client.post(
        url, 
        headers: headers ?? ApiConstants.headers,
        body: body != null ? json.encode(body) : null,
      );
      return _processResponse(response);
    } catch (e) {
      throw ApiException('Failed to perform POST request: $e');
    }
  }
  
  /// Perform a PUT request
  Future<dynamic> put(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await _client.put(
        url, 
        headers: headers ?? ApiConstants.headers,
        body: body != null ? json.encode(body) : null,
      );
      return _processResponse(response);
    } catch (e) {
      throw ApiException('Failed to perform PUT request: $e');
    }
  }
  
  /// Process the HTTP response
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw ApiException(
        'Request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
}
