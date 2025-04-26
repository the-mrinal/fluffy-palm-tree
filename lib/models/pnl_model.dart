import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

enum PnLPeriodType {
  weekly,
  monthly
}

class PnLPeriodData extends Equatable {
  final String period;
  final int tradeCount;
  final double amount;
  final double percentage;

  const PnLPeriodData({
    required this.period,
    required this.tradeCount,
    required this.amount,
    required this.percentage,
  });

  factory PnLPeriodData.fromJson(Map<String, dynamic> json) {
    return PnLPeriodData(
      period: json['period'] ?? '',
      tradeCount: json['trade_count'] ?? 0,
      amount: json['amount']?.toDouble() ?? 0.0,
      percentage: json['percentage']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'trade_count': tradeCount,
      'amount': amount,
      'percentage': percentage,
    };
  }

  @override
  List<Object?> get props => [period, tradeCount, amount, percentage];

  // Helper method to generate sample data
  static List<PnLPeriodData> generateSampleData(PnLPeriodType type) {
    final now = DateTime.now();
    final result = <PnLPeriodData>[];

    if (type == PnLPeriodType.monthly) {
      // Generate 6 months of data
      for (int i = 0; i < 6; i++) {
        final month = now.month - i;
        final year = now.year - (month <= 0 ? 1 : 0);
        final adjustedMonth = month <= 0 ? month + 12 : month;

        final date = DateTime(year, adjustedMonth);
        final formatter = DateFormat('MMM yyyy');
        final period = formatter.format(date);

        result.add(PnLPeriodData(
          period: period,
          tradeCount: 5 + (i * 2),
          amount: 25000.0 + (i * 10000.0),
          percentage: 2.5 + (i * 0.8),
        ));
      }
    } else {
      // Generate 8 weeks of data
      for (int i = 0; i < 8; i++) {
        final date = now.subtract(Duration(days: i * 7));
        final weekNumber = (date.difference(DateTime(date.year, 1, 1)).inDays / 7).ceil();
        final period = 'Week $weekNumber, ${date.year}';

        result.add(PnLPeriodData(
          period: period,
          tradeCount: 2 + i,
          amount: 8000.0 + (i * 3000.0),
          percentage: 0.8 + (i * 0.3),
        ));
      }
    }

    return result;
  }
}

class PnLDataPoint extends Equatable {
  final DateTime date;
  final double pnlValue;
  final double fundValue;

  const PnLDataPoint({
    required this.date,
    required this.pnlValue,
    required this.fundValue,
  });

  // Get capital value in lakhs (1 lakh = 100,000)
  double get capitalValueInLakhs => fundValue / 100000;

  // Get P&L value in thousands
  double get pnlValueInThousands => pnlValue / 1000;

  // Get week number for the date
  int get weekNumber => (date.difference(DateTime(date.year, 1, 1)).inDays / 7).ceil();

  factory PnLDataPoint.fromJson(Map<String, dynamic> json) {
    return PnLDataPoint(
      date: DateTime.parse(json['date']),
      pnlValue: json['pnl_value']?.toDouble() ?? 0.0,
      fundValue: json['fund_value']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'pnl_value': pnlValue,
      'fund_value': fundValue,
    };
  }

  @override
  List<Object?> get props => [date, pnlValue, fundValue];
}

class PnLSummary extends Equatable {
  final double netProfit;
  final double growthPercentage;
  final int tradeCount;
  final double currentValue;
  final List<PnLDataPoint> dataPoints;
  final List<PnLPeriodData> monthlyData;
  final List<PnLPeriodData> weeklyData;
  final double? medianCapital;

  const PnLSummary({
    required this.netProfit,
    required this.growthPercentage,
    required this.tradeCount,
    required this.currentValue,
    required this.dataPoints,
    this.monthlyData = const [],
    this.weeklyData = const [],
    this.medianCapital,
  });

  // Get median capital in lakhs
  double get medianCapitalInLakhs => (medianCapital ?? 0) / 100000;

  // Calculate median capital from data points
  static double calculateMedianCapital(List<PnLDataPoint> dataPoints) {
    if (dataPoints.isEmpty) return 0;

    // Extract fund values and sort them
    final fundValues = dataPoints.map((point) => point.fundValue).toList()..sort();

    // Calculate median
    if (fundValues.length % 2 == 0) {
      // Even number of elements - average the middle two
      final middle1 = fundValues[fundValues.length ~/ 2 - 1];
      final middle2 = fundValues[fundValues.length ~/ 2];
      return (middle1 + middle2) / 2;
    } else {
      // Odd number of elements - take the middle one
      return fundValues[fundValues.length ~/ 2];
    }
  }

  factory PnLSummary.initial() {
    return const PnLSummary(
      netProfit: 0.0,
      growthPercentage: 0.0,
      tradeCount: 0,
      currentValue: 0.0,
      dataPoints: [],
      monthlyData: [],
      weeklyData: [],
      medianCapital: null,
    );
  }

  factory PnLSummary.fromJson(Map<String, dynamic> json) {
    final dataPoints = (json['data_points'] as List?)
        ?.map((point) => PnLDataPoint.fromJson(point))
        .toList() ?? [];

    return PnLSummary(
      netProfit: json['net_profit']?.toDouble() ?? 0.0,
      growthPercentage: json['growth_percentage']?.toDouble() ?? 0.0,
      tradeCount: json['trade_count'] ?? 0,
      currentValue: json['current_value']?.toDouble() ?? 0.0,
      dataPoints: dataPoints,
      monthlyData: (json['monthly_data'] as List?)
          ?.map((data) => PnLPeriodData.fromJson(data))
          .toList() ?? [],
      weeklyData: (json['weekly_data'] as List?)
          ?.map((data) => PnLPeriodData.fromJson(data))
          .toList() ?? [],
      medianCapital: json['median_capital']?.toDouble() ?? calculateMedianCapital(dataPoints),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'net_profit': netProfit,
      'growth_percentage': growthPercentage,
      'trade_count': tradeCount,
      'current_value': currentValue,
      'data_points': dataPoints.map((point) => point.toJson()).toList(),
      'monthly_data': monthlyData.map((data) => data.toJson()).toList(),
      'weekly_data': weeklyData.map((data) => data.toJson()).toList(),
      'median_capital': medianCapital,
    };
  }

  @override
  List<Object?> get props => [
    netProfit,
    growthPercentage,
    tradeCount,
    currentValue,
    dataPoints,
    monthlyData,
    weeklyData,
    medianCapital,
  ];
}
