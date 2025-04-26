import 'package:intl/intl.dart';

class TradingUtils {
  /// Calculates the next valid trading day, excluding weekends and after trading hours
  static DateTime getNextTradingDay() {
    DateTime today = DateTime.now();
    
    // Skip to next day if current day is after trading hours (4 PM)
    if (today.hour >= 16) {
      today = today.add(const Duration(days: 1));
    }
    
    // Skip weekends
    while (today.weekday == DateTime.saturday || today.weekday == DateTime.sunday) {
      today = today.add(const Duration(days: 1));
    }
    
    // TODO: Add holiday check logic here if needed
    
    return today;
  }
  
  /// Formats a date for display
  static String formatDateForDisplay(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }
  
  /// Checks if trading should be started based on current time
  static bool isTradingStarted() {
    final now = DateTime.now();
    final tradingStartHour = 9; // 9 AM
    
    // If it's a weekend, trading hasn't started
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      return false;
    }
    
    // If it's before trading hours, trading hasn't started
    if (now.hour < tradingStartHour) {
      return false;
    }
    
    // TODO: Add holiday check logic here if needed
    
    return true;
  }
}
