import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paper_bulls/bloc/trading/trading_event.dart';
import 'package:paper_bulls/bloc/trading/trading_state.dart';
import 'package:paper_bulls/models/trading_model.dart';
import 'package:paper_bulls/services/storage_service.dart';
import 'package:paper_bulls/utils/constants.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final StorageService _storageService;
  
  TradingBloc({
    required StorageService storageService,
  }) : 
    _storageService = storageService,
    super(TradingState.initial()) {
    on<TradingInitialized>(_onTradingInitialized);
    on<TradingCapitalUpdated>(_onTradingCapitalUpdated);
    on<TradingModeSelected>(_onTradingModeSelected);
    on<TradingDateRangeUpdated>(_onTradingDateRangeUpdated);
  }
  
  Future<void> _onTradingInitialized(
    TradingInitialized event,
    Emitter<TradingState> emit,
  ) async {
    emit(state.copyWith(status: TradingStatus.loading));
    
    try {
      final tradingJson = await _storageService.getTradingInfo();
      
      if (tradingJson != null) {
        final trading = TradingModel.fromJson(tradingJson);
        emit(state.copyWith(
          status: TradingStatus.loaded,
          trading: trading,
        ));
      } else {
        // Use default values
        final defaultTrading = TradingModel.initial();
        await _storageService.saveTradingInfo(defaultTrading.toJson());
        
        emit(state.copyWith(
          status: TradingStatus.loaded,
          trading: defaultTrading,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TradingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  Future<void> _onTradingCapitalUpdated(
    TradingCapitalUpdated event,
    Emitter<TradingState> emit,
  ) async {
    try {
      final updatedTrading = state.trading.copyWith(
        capitalAmount: event.capitalAmount,
      );
      
      await _storageService.saveTradingInfo(updatedTrading.toJson());
      
      emit(state.copyWith(
        trading: updatedTrading,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TradingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  Future<void> _onTradingModeSelected(
    TradingModeSelected event,
    Emitter<TradingState> emit,
  ) async {
    try {
      final updatedTrading = state.trading.copyWith(
        tradingMode: event.tradingMode,
      );
      
      await _storageService.saveTradingInfo(updatedTrading.toJson());
      
      emit(state.copyWith(
        trading: updatedTrading,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TradingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  Future<void> _onTradingDateRangeUpdated(
    TradingDateRangeUpdated event,
    Emitter<TradingState> emit,
  ) async {
    try {
      final updatedTrading = state.trading.copyWith(
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      
      await _storageService.saveTradingInfo(updatedTrading.toJson());
      
      emit(state.copyWith(
        trading: updatedTrading,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TradingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
