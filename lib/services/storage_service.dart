import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paper_bulls/utils/constants.dart';

class StorageService {
  // Auth token methods
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authTokenKey, token);
  }
  
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.authTokenKey);
  }
  
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.authTokenKey);
  }
  
  // User info methods
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userInfoKey, jsonEncode(userInfo));
  }
  
  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoString = prefs.getString(AppConstants.userInfoKey);
    
    if (userInfoString != null) {
      return jsonDecode(userInfoString) as Map<String, dynamic>;
    }
    
    return null;
  }
  
  Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userInfoKey);
  }
  
  // Trading info methods
  Future<void> saveTradingInfo(Map<String, dynamic> tradingInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.capitalAmountKey, jsonEncode(tradingInfo));
  }
  
  Future<Map<String, dynamic>?> getTradingInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final tradingInfoString = prefs.getString(AppConstants.capitalAmountKey);
    
    if (tradingInfoString != null) {
      return jsonDecode(tradingInfoString) as Map<String, dynamic>;
    }
    
    return null;
  }
  
  Future<void> clearTradingInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.capitalAmountKey);
  }
  
  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
