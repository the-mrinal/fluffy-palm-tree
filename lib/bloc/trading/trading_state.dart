import 'package:equatable/equatable.dart';
import 'package:paper_bulls/models/trading_model.dart';

enum TradingStatus {
  initial,
  loading,
  loaded,
  error,
}

class TradingState extends Equatable {
  final TradingStatus status;
  final TradingModel trading;
  final String? errorMessage;
  
  const TradingState({
    required this.status,
    required this.trading,
    this.errorMessage,
  });
  
  factory TradingState.initial() {
    return TradingState(
      status: TradingStatus.initial,
      trading: TradingModel.initial(),
    );
  }
  
  TradingState copyWith({
    TradingStatus? status,
    TradingModel? trading,
    String? errorMessage,
  }) {
    return TradingState(
      status: status ?? this.status,
      trading: trading ?? this.trading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, trading, errorMessage];
}
