import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paper_bulls/bloc/pnl/pnl_event.dart';
import 'package:paper_bulls/bloc/pnl/pnl_state.dart';
import 'package:paper_bulls/bloc/trading/trading_bloc.dart';
import 'package:paper_bulls/bloc/trading/trading_state.dart';
import 'package:paper_bulls/services/pnl_service.dart';

class PnLBloc extends Bloc<PnLEvent, PnLState> {
  final PnLService _pnlService;
  final TradingBloc? _tradingBloc;

  PnLBloc({
    required PnLService pnlService,
    TradingBloc? tradingBloc,
  }) :
    _pnlService = pnlService,
    _tradingBloc = tradingBloc,
    super(PnLState.initial()) {
    on<PnLDataRequested>(_onPnLDataRequested);
    on<PnLTimeRangeSelected>(_onPnLTimeRangeSelected);
    on<PnLChartHighlightChanged>(_onPnLChartHighlightChanged);
    on<PnLMedianCapitalToggled>(_onPnLMedianCapitalToggled);
  }

  Future<void> _onPnLDataRequested(
    PnLDataRequested event,
    Emitter<PnLState> emit,
  ) async {
    emit(state.copyWith(status: PnLStatus.loading));

    try {
      final fromDate = event.fromDate;
      final toDate = event.toDate;

      // Get trading mode from trading bloc if available
      final tradingMode = _tradingBloc?.state.trading.tradingMode;

      final summary = await _pnlService.getPnLData(
        fromDate: fromDate,
        toDate: toDate,
        tradingMode: tradingMode,
      );

      emit(state.copyWith(
        status: PnLStatus.loaded,
        summary: summary,
        fromDate: fromDate,
        toDate: toDate,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PnLStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPnLTimeRangeSelected(
    PnLTimeRangeSelected event,
    Emitter<PnLState> emit,
  ) async {
    emit(state.copyWith(
      status: PnLStatus.loading,
      selectedTimeRange: event.timeRange,
    ));

    try {
      final now = DateTime.now();
      DateTime? fromDate;
      final toDate = now;

      // Calculate from date based on selected time range
      switch (event.timeRange) {
        case '1M':
          fromDate = DateTime(now.year, now.month - 1, now.day);
          break;
        case '3M':
          fromDate = DateTime(now.year, now.month - 3, now.day);
          break;
        case '6M':
          fromDate = DateTime(now.year, now.month - 6, now.day);
          break;
        case '1Y':
          fromDate = DateTime(now.year - 1, now.month, now.day);
          break;
        case 'All':
          fromDate = null; // Get all data
          break;
      }

      // Get trading mode from trading bloc if available
      final tradingMode = _tradingBloc?.state.trading.tradingMode;

      final summary = await _pnlService.getPnLData(
        fromDate: fromDate,
        toDate: toDate,
        tradingMode: tradingMode,
      );

      emit(state.copyWith(
        status: PnLStatus.loaded,
        summary: summary,
        fromDate: fromDate,
        toDate: toDate,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PnLStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onPnLChartHighlightChanged(
    PnLChartHighlightChanged event,
    Emitter<PnLState> emit,
  ) {
    emit(state.copyWith(
      chartHighlight: event.highlight,
    ));
  }

  void _onPnLMedianCapitalToggled(
    PnLMedianCapitalToggled event,
    Emitter<PnLState> emit,
  ) {
    emit(state.copyWith(
      showMedianCapital: event.showMedianCapital,
    ));
  }
}
