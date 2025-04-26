import 'package:equatable/equatable.dart';

enum TradingMode {
  backTesting,
  forwardTesting,
}

class TradingModel extends Equatable {
  final double capitalAmount;
  final TradingMode tradingMode;
  final DateTime? fromDate;
  final DateTime? toDate;

  const TradingModel({
    required this.capitalAmount,
    required this.tradingMode,
    this.fromDate,
    this.toDate,
  });

  factory TradingModel.initial() {
    return const TradingModel(
      capitalAmount: 400000.0,
      tradingMode: TradingMode.forwardTesting,
    );
  }

  factory TradingModel.fromJson(Map<String, dynamic> json) {
    return TradingModel(
      capitalAmount: json['capital_amount'] ?? 400000.0,
      tradingMode: TradingMode.values.firstWhere(
        (mode) => mode.toString() == json['trading_mode'],
        orElse: () => TradingMode.forwardTesting,
      ),
      fromDate: json['from_date'] != null ? DateTime.parse(json['from_date']) : null,
      toDate: json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'capital_amount': capitalAmount,
      'trading_mode': tradingMode.toString(),
      'from_date': fromDate?.toIso8601String(),
      'to_date': toDate?.toIso8601String(),
    };
  }

  TradingModel copyWith({
    double? capitalAmount,
    TradingMode? tradingMode,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return TradingModel(
      capitalAmount: capitalAmount ?? this.capitalAmount,
      tradingMode: tradingMode ?? this.tradingMode,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [capitalAmount, tradingMode, fromDate, toDate];
}
