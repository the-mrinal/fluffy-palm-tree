import 'package:equatable/equatable.dart';
import 'package:paper_bulls/bloc/pnl/pnl_state.dart';

abstract class PnLEvent extends Equatable {
  const PnLEvent();

  @override
  List<Object?> get props => [];
}

class PnLDataRequested extends PnLEvent {
  final DateTime? fromDate;
  final DateTime? toDate;

  const PnLDataRequested({
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [fromDate, toDate];
}

class PnLTimeRangeSelected extends PnLEvent {
  final String timeRange; // '1M', '3M', '6M', '1Y', 'All'

  const PnLTimeRangeSelected({required this.timeRange});

  @override
  List<Object?> get props => [timeRange];
}

class PnLChartHighlightChanged extends PnLEvent {
  final ChartHighlight highlight;

  const PnLChartHighlightChanged({required this.highlight});

  @override
  List<Object?> get props => [highlight];
}

class PnLMedianCapitalToggled extends PnLEvent {
  final bool showMedianCapital;

  const PnLMedianCapitalToggled({required this.showMedianCapital});

  @override
  List<Object?> get props => [showMedianCapital];
}
