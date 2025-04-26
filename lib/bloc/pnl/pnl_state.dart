import 'package:equatable/equatable.dart';
import 'package:paper_bulls/models/pnl_model.dart';

enum PnLStatus {
  initial,
  loading,
  loaded,
  error,
}

enum ChartHighlight {
  both,
  pnl,
  capital,
}

class PnLState extends Equatable {
  final PnLStatus status;
  final PnLSummary summary;
  final String selectedTimeRange;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? errorMessage;
  final ChartHighlight chartHighlight;
  final bool showMedianCapital;

  const PnLState({
    required this.status,
    required this.summary,
    required this.selectedTimeRange,
    this.fromDate,
    this.toDate,
    this.errorMessage,
    this.chartHighlight = ChartHighlight.both,
    this.showMedianCapital = true,
  });

  factory PnLState.initial() {
    return PnLState(
      status: PnLStatus.initial,
      summary: PnLSummary.initial(),
      selectedTimeRange: 'All',
    );
  }

  PnLState copyWith({
    PnLStatus? status,
    PnLSummary? summary,
    String? selectedTimeRange,
    DateTime? fromDate,
    DateTime? toDate,
    String? errorMessage,
    ChartHighlight? chartHighlight,
    bool? showMedianCapital,
  }) {
    return PnLState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      errorMessage: errorMessage ?? this.errorMessage,
      chartHighlight: chartHighlight ?? this.chartHighlight,
      showMedianCapital: showMedianCapital ?? this.showMedianCapital,
    );
  }

  @override
  List<Object?> get props => [
    status,
    summary,
    selectedTimeRange,
    fromDate,
    toDate,
    errorMessage,
    chartHighlight,
    showMedianCapital,
  ];
}
