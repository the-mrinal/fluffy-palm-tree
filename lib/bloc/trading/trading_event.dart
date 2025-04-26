import 'package:equatable/equatable.dart';
import 'package:paper_bulls/models/trading_model.dart';

abstract class TradingEvent extends Equatable {
  const TradingEvent();
  
  @override
  List<Object?> get props => [];
}

class TradingInitialized extends TradingEvent {}

class TradingCapitalUpdated extends TradingEvent {
  final double capitalAmount;
  
  const TradingCapitalUpdated({required this.capitalAmount});
  
  @override
  List<Object?> get props => [capitalAmount];
}

class TradingModeSelected extends TradingEvent {
  final TradingMode tradingMode;
  
  const TradingModeSelected({required this.tradingMode});
  
  @override
  List<Object?> get props => [tradingMode];
}

class TradingDateRangeUpdated extends TradingEvent {
  final DateTime fromDate;
  final DateTime toDate;
  
  const TradingDateRangeUpdated({
    required this.fromDate,
    required this.toDate,
  });
  
  @override
  List<Object?> get props => [fromDate, toDate];
}
