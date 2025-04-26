import 'dart:math';
import 'package:paper_bulls/models/pnl_model.dart';
import 'package:paper_bulls/models/trading_model.dart';

class PnLService {
  // For demo purposes, we'll generate mock data
  Future<PnLSummary> getPnLData({
    DateTime? fromDate,
    DateTime? toDate,
    TradingMode? tradingMode,
  }) async {
    // Default to backTesting if no trading mode is provided
    final mode = tradingMode ?? TradingMode.backTesting;
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock data
    final random = Random();
    final now = DateTime.now();

    // Default to 1 year of data if no dates provided
    final startDate = fromDate ?? DateTime(now.year - 1, now.month, now.day);
    final endDate = toDate ?? now;

    // Generate data points
    final dataPoints = <PnLDataPoint>[];

    // Initial fund value (starting capital)
    double fundValue = 400000.0; // 4 lakhs initial capital
    double pnlValue = 0.0;

    // Generate daily data points
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      // Skip weekends
      if (currentDate.weekday != DateTime.saturday && currentDate.weekday != DateTime.sunday) {
        // Random daily change (-2% to +2%)
        final dailyChangePercent = (random.nextDouble() * 4) - 2;
        final dailyChange = fundValue * (dailyChangePercent / 100);

        fundValue += dailyChange;
        pnlValue += dailyChange;

        dataPoints.add(PnLDataPoint(
          date: currentDate,
          pnlValue: pnlValue,
          fundValue: fundValue,
        ));
      }

      // Move to next day
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Calculate summary metrics
    final netProfit = dataPoints.isNotEmpty ? dataPoints.last.pnlValue : 0.0;
    final growthPercentage = (netProfit / 400000.0) * 100; // Calculate based on initial capital
    final tradeCount = random.nextInt(50) + 20; // Random number of trades
    final currentValue = dataPoints.isNotEmpty ? dataPoints.last.fundValue : 400000.0;

    // Calculate median capital
    final medianCapital = PnLSummary.calculateMedianCapital(dataPoints);

    // Generate monthly and weekly data - ensure we have data to display
    final monthlyData = PnLPeriodData.generateSampleData(PnLPeriodType.monthly);
    final weeklyData = PnLPeriodData.generateSampleData(PnLPeriodType.weekly);

    // Make sure we have at least some data
    if (monthlyData.isEmpty) {
      monthlyData.add(
        PnLPeriodData(
          period: "Current Month",
          tradeCount: 5,
          amount: 25000.0,
          percentage: 2.5,
        )
      );
    }

    if (weeklyData.isEmpty) {
      weeklyData.add(
        PnLPeriodData(
          period: "Current Week",
          tradeCount: 2,
          amount: 8000.0,
          percentage: 0.8,
        )
      );
    }

    return PnLSummary(
      netProfit: netProfit,
      growthPercentage: growthPercentage,
      tradeCount: tradeCount,
      currentValue: currentValue,
      dataPoints: dataPoints,
      monthlyData: monthlyData,
      weeklyData: weeklyData,
      medianCapital: medianCapital,
    );
  }

  // Normalize data for dual-axis visualization
  List<PnLDataPoint> normalizeDataForDualAxis(List<PnLDataPoint> dataPoints) {
    if (dataPoints.isEmpty) return [];

    // Find min and max values for both series
    double minPnL = double.infinity;
    double maxPnL = double.negativeInfinity;
    double minFund = double.infinity;
    double maxFund = double.negativeInfinity;

    for (final point in dataPoints) {
      if (point.pnlValue < minPnL) minPnL = point.pnlValue;
      if (point.pnlValue > maxPnL) maxPnL = point.pnlValue;
      if (point.fundValue < minFund) minFund = point.fundValue;
      if (point.fundValue > maxFund) maxFund = point.fundValue;
    }

    // Calculate normalization factors
    final pnlRange = maxPnL - minPnL;
    final fundRange = maxFund - minFund;

    // Avoid division by zero
    if (pnlRange == 0 || fundRange == 0) return dataPoints;

    // Create normalized data points
    final normalizedPoints = <PnLDataPoint>[];

    for (final point in dataPoints) {
      // Normalize values to a common scale (0-1)
      final normalizedPnL = (point.pnlValue - minPnL) / pnlRange;
      final normalizedFund = (point.fundValue - minFund) / fundRange;

      // Scale back to original ranges for visualization
      normalizedPoints.add(PnLDataPoint(
        date: point.date,
        pnlValue: normalizedPnL * pnlRange + minPnL,
        fundValue: normalizedFund * fundRange + minFund,
      ));
    }

    return normalizedPoints;
  }
}
