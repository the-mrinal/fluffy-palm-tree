import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paper_bulls/bloc/pnl/pnl_state.dart';
import 'package:paper_bulls/models/pnl_model.dart';
import 'package:paper_bulls/models/trading_model.dart';
import 'package:paper_bulls/utils/constants.dart';
import 'package:paper_bulls/utils/chart_colors.dart';
import 'package:paper_bulls/utils/theme.dart';

class DualAxisChart extends StatefulWidget {
  final List<PnLDataPoint> dataPoints;
  final ChartHighlight chartHighlight;
  final bool showMedianCapital;
  final double? medianCapital;
  final TradingMode tradingMode;

  const DualAxisChart({
    super.key,
    required this.dataPoints,
    required this.chartHighlight,
    required this.showMedianCapital,
    this.medianCapital,
    required this.tradingMode,
  });

  @override
  State<DualAxisChart> createState() => _DualAxisChartState();
}

class _DualAxisChartState extends State<DualAxisChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.dataPoints.isEmpty) {
      return const Center(
        child: Text('No data available for the selected time range'),
      );
    }

    // If in forward testing mode and no data, show waiting message
    if (widget.tradingMode == TradingMode.forwardTesting && widget.dataPoints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hourglass_empty,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Waiting for trading to begin',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your P&L data will appear here once trading starts',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Determine opacity based on chart highlight
    double pnlOpacity = 1.0;
    if (widget.chartHighlight == ChartHighlight.capital) {
      pnlOpacity = 0.4;
    }

    double capitalOpacity = 1.0;
    if (widget.chartHighlight == ChartHighlight.pnl) {
      capitalOpacity = 0.4;
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 24,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: Stack(
          children: [
            // Capital bars (drawn as custom painter)
            CustomPaint(
              size: Size.infinite,
              painter: CapitalBarPainter(
                dataPoints: widget.dataPoints,
                opacity: capitalOpacity,
              ),
            ),
            // P&L line chart
            LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: ChartColors.tooltipBackgroundColor,
                    tooltipRoundedRadius: 8,
                    tooltipBorder: BorderSide(
                      color: ChartColors.tooltipBorderColor.withOpacity(ChartColors.tooltipBorderOpacity),
                    ),
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      if (touchedBarSpots.isEmpty) return [];

                      final index = touchedBarSpots.first.x.toInt();
                      if (index >= 0 && index < widget.dataPoints.length) {
                        final point = widget.dataPoints[index];
                        final date = DateFormat(AppConstants.dateFormatDisplay).format(point.date);
                        final weekNumber = point.weekNumber;

                        return [
                          LineTooltipItem(
                            'Date: $date\nWeek: $weekNumber\n'
                            'P&L: ₹${(point.pnlValue / 1000).toStringAsFixed(2)}K\n'
                            'Capital: ₹${(point.fundValue / 100000).toStringAsFixed(2)}L',
                            const TextStyle(
                              color: ChartColors.tooltipTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ];
                      }
                      return [];
                    },
                  ),
                  touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          touchResponse == null ||
                          touchResponse.lineBarSpots == null ||
                          touchResponse.lineBarSpots!.isEmpty) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = touchResponse.lineBarSpots!.first.x.toInt();
                    });
                  },
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 100000, // 1 lakh interval
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: ChartColors.horizontalGridLineColor.withOpacity(ChartColors.horizontalGridLineOpacity),
                      strokeWidth: 1.5, // Slightly thicker
                      dashArray: [5, 5],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: ChartColors.verticalGridLineColor.withOpacity(ChartColors.verticalGridLineOpacity),
                      strokeWidth: 1,
                      dashArray: [3, 3], // Add dash pattern for distinction
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Show dates at regular intervals
                        final index = value.toInt();
                        if (index < 0 || index >= widget.dataPoints.length) {
                          return const SizedBox.shrink();
                        }

                        // Show dates at regular intervals (e.g., every 5th data point)
                        if (index % 5 == 0) {
                          final date = widget.dataPoints[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('MMM d').format(date),
                              style: const TextStyle(
                                color: ChartColors.chartSecondaryTextColor,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text(
                      'Capital (Lakhs)',
                      style: TextStyle(
                        color: ChartColors.chartTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Convert to lakhs for display
                        final valueInLakhs = value / 100000;
                        return Text(
                          '₹${valueInLakhs.toStringAsFixed(1)}L',
                          style: const TextStyle(
                            color: ChartColors.chartSecondaryTextColor,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    axisNameWidget: const Text(
                      'P&L (Thousands)',
                      style: TextStyle(
                        color: ChartColors.chartTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Convert to thousands for display
                        final valueInThousands = value / 1000;
                        return Text(
                          '₹${valueInThousands.toStringAsFixed(0)}K',
                          style: const TextStyle(
                            color: ChartColors.chartSecondaryTextColor,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: ChartColors.chartBorderColor.withOpacity(ChartColors.chartBorderOpacity),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: ChartColors.chartBorderColor.withOpacity(ChartColors.chartBorderOpacity),
                      width: 1,
                    ),
                    right: BorderSide(
                      color: ChartColors.chartBorderColor.withOpacity(ChartColors.chartBorderOpacity),
                      width: 1,
                    ),
                    top: BorderSide(
                      color: ChartColors.chartBorderColor.withOpacity(ChartColors.chartBorderOpacity),
                      width: 1,
                    ),
                  ),
                ),
                lineBarsData: [
                  // P&L Line
                  LineChartBarData(
                    spots: _buildPnLSpots(),
                    isCurved: true,
                    color: ChartColors.pnlLineColor.withOpacity(pnlOpacity),
                    barWidth: 4, // Slightly thicker line
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: ChartColors.pnlDotColor,
                          strokeWidth: 1,
                          strokeColor: ChartColors.pnlDotStrokeColor,
                        );
                      },
                      checkToShowDot: (spot, barData) => spot.x.toInt() % 5 == 0, // Show dots every 5 points
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: ChartColors.pnlAreaColor.withOpacity(ChartColors.pnlAreaOpacity * pnlOpacity),
                    ),
                  ),
                ],
                extraLinesData: _buildExtraLines(),
                minX: 0,
                maxX: (widget.dataPoints.length - 1).toDouble(),
                minY: _calculateMinY(),
                maxY: _calculateMaxY(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _buildPnLSpots() {
    return widget.dataPoints.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      return FlSpot(index.toDouble(), point.pnlValue);
    }).toList();
  }

  double _calculateMinY() {
    if (widget.dataPoints.isEmpty) return 0;

    double minY = double.infinity;
    for (final point in widget.dataPoints) {
      if (point.pnlValue < minY) minY = point.pnlValue;
      if (point.fundValue < minY) minY = point.fundValue;
    }

    // Add some padding
    return minY - (minY.abs() * 0.1);
  }

  double _calculateMaxY() {
    if (widget.dataPoints.isEmpty) return 1000000; // 10 lakhs default

    double maxY = double.negativeInfinity;
    for (final point in widget.dataPoints) {
      if (point.pnlValue > maxY) maxY = point.pnlValue;
      if (point.fundValue > maxY) maxY = point.fundValue;
    }

    // Add some padding
    return maxY + (maxY * 0.1);
  }

  ExtraLinesData _buildExtraLines() {
    // Create median capital line if enabled
    final medianCapitalLines = <HorizontalLine>[];
    if (widget.showMedianCapital && widget.medianCapital != null) {
      medianCapitalLines.add(
        HorizontalLine(
          y: widget.medianCapital!,
          color: ChartColors.medianLineColor.withOpacity(ChartColors.medianLineOpacity),
          strokeWidth: 2, // Thicker line
          dashArray: [5, 5],
          label: HorizontalLineLabel(
            show: true,
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(right: 8, bottom: 4),
            style: const TextStyle(
              color: ChartColors.medianLineLabelColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            labelResolver: (line) => 'Median Capital: ₹${(line.y / 100000).toStringAsFixed(2)}L',
          ),
        ),
      );
    }

    return ExtraLinesData(
      horizontalLines: medianCapitalLines,
      verticalLines: [
        if (touchedIndex != null && touchedIndex! >= 0)
          VerticalLine(
            x: touchedIndex!.toDouble(),
            color: ChartColors.chartBorderColor.withOpacity(0.5),
            strokeWidth: 1,
          ),
      ],
    );
  }
}

// Custom painter for drawing capital bars
class CapitalBarPainter extends CustomPainter {
  final List<PnLDataPoint> dataPoints;
  final double opacity;

  CapitalBarPainter({
    required this.dataPoints,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final barWidth = size.width / (dataPoints.length * 1.5);
    final maxY = _calculateMaxY() * 1.1; // Add 10% padding

    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final barHeight = (point.fundValue / maxY) * size.height;
      final left = i * (size.width / dataPoints.length) + (size.width / dataPoints.length - barWidth) / 2;

      final rect = Rect.fromLTWH(
        left,
        size.height - barHeight,
        barWidth,
        barHeight,
      );

      final paint = Paint()
        ..color = ChartColors.capitalBarColor.withOpacity(opacity * ChartColors.capitalBarOpacity)
        ..style = PaintingStyle.fill;

      // Add a border to the bars for better definition
      final borderPaint = Paint()
        ..color = ChartColors.capitalBarBorderColor.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Draw rounded top corners
      final radius = Radius.circular(barWidth / 4);
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: radius,
        topRight: radius,
      );

      // Draw the filled bar
      canvas.drawRRect(rrect, paint);

      // Draw the border
      canvas.drawRRect(rrect, borderPaint);
    }
  }

  double _calculateMaxY() {
    if (dataPoints.isEmpty) return 1000000; // 10 lakhs default

    double maxY = double.negativeInfinity;
    for (final point in dataPoints) {
      if (point.fundValue > maxY) maxY = point.fundValue;
    }

    return maxY;
  }

  @override
  bool shouldRepaint(covariant CapitalBarPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints || oldDelegate.opacity != opacity;
  }
}
