import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:paper_bulls/bloc/auth/auth_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_state.dart';
import 'package:paper_bulls/bloc/pnl/pnl_bloc.dart';
import 'package:paper_bulls/bloc/pnl/pnl_event.dart';
import 'package:paper_bulls/bloc/pnl/pnl_state.dart';
import 'package:paper_bulls/bloc/trading/trading_bloc.dart';
import 'package:paper_bulls/bloc/trading/trading_state.dart';
import 'package:paper_bulls/models/pnl_model.dart';
import 'package:paper_bulls/models/trading_model.dart';
import 'package:paper_bulls/services/navigation_service.dart';
import 'package:paper_bulls/utils/constants.dart';
import 'package:paper_bulls/utils/responsive.dart';
import 'package:paper_bulls/utils/theme.dart';
import 'package:paper_bulls/widgets/chart_toggle.dart';
import 'package:paper_bulls/widgets/dual_axis_chart.dart';

class PnLOverviewPage extends StatefulWidget {
  const PnLOverviewPage({super.key});

  @override
  State<PnLOverviewPage> createState() => _PnLOverviewPageState();
}

class _PnLOverviewPageState extends State<PnLOverviewPage> {
  DateTime? _customFromDate;
  DateTime? _customToDate;
  bool _showMonthlyView = true; // Toggle between monthly and weekly view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'P&L Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Updated every Friday 10:30 am',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => NavigationService.navigateTo(context, AppConstants.mockTradingDashboardRoute),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.help_outline, size: 18),
              label: const Text('Need Help?'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                // Help action
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState.status != AuthStatus.authenticated) {
            // Redirect to login if not authenticated
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NavigationService.navigateTo(context, AppConstants.loginRoute);
            });
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: Responsive.getScreenPadding(context),
              child: BlocBuilder<PnLBloc, PnLState>(
                builder: (context, pnlState) {
                  // Use a simpler layout approach to avoid layout issues
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 1100) {
                        // Desktop layout
                        return _buildDesktopLayout(context, pnlState);
                      } else if (constraints.maxWidth >= 650) {
                        // Tablet layout
                        return _buildTabletLayout(context, pnlState);
                      } else {
                        // Mobile layout
                        return _buildMobileLayout(context, pnlState);
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, PnLState pnlState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimeRangeSelector(context, pnlState),
          const SizedBox(height: 24),
          _buildKeyMetrics(pnlState),
          const SizedBox(height: 24),
          _buildCurrentValuesBox(pnlState),
          const SizedBox(height: 24),
          _buildPnLTable(context, pnlState),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, PnLState pnlState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimeRangeSelector(context, pnlState),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildKeyMetrics(pnlState)),
              const SizedBox(width: 24),
              Expanded(child: _buildCurrentValuesBox(pnlState)),
            ],
          ),
          const SizedBox(height: 32),
          _buildPnLTable(context, pnlState),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, PnLState pnlState) {
    // Use SingleChildScrollView to avoid layout issues
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimeRangeSelector(context, pnlState),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildKeyMetrics(pnlState)),
              const SizedBox(width: 24),
              Expanded(child: _buildCurrentValuesBox(pnlState)),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            height: 500, // Fixed height container
            child: _buildPnLTable(context, pnlState),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context, PnLState pnlState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Time Range',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeRangeButton(context, '1M', pnlState),
                  _buildTimeRangeButton(context, '3M', pnlState),
                  _buildTimeRangeButton(context, '6M', pnlState),
                  _buildTimeRangeButton(context, '1Y', pnlState),
                  _buildTimeRangeButton(context, 'All', pnlState),
                  _buildCustomRangeButton(context),
                ],
              ),
            ),
          ),
          if (_customFromDate != null && _customToDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Custom: ${DateFormat(AppConstants.dateFormatDisplay).format(_customFromDate!)} - ${DateFormat(AppConstants.dateFormatDisplay).format(_customToDate!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(BuildContext context, String range, PnLState pnlState) {
    final isSelected = pnlState.selectedTimeRange == range;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        range,
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildCustomRangeButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
        onPressed: () => _showDateRangePicker(context),
      ),
    );
  }

  Widget _buildKeyMetrics(PnLState pnlState) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Profit header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Net Profit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Profit amount row
            Row(
              children: [
                Text(
                  '₹${(pnlState.summary.netProfit / 100000).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  ' lakh',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.profitColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        pnlState.summary.growthPercentage >= 0 ? Icons.trending_up : Icons.trending_down,
                        color: pnlState.summary.growthPercentage >= 0 ? AppTheme.profitColor : AppTheme.errorColor,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${pnlState.summary.growthPercentage >= 0 ? '+' : ''}${pnlState.summary.growthPercentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: pnlState.summary.growthPercentage >= 0 ? AppTheme.profitColor : AppTheme.errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Date range and trades
            Text(
              '${DateFormat('yyyy MMM').format(DateTime.now().subtract(const Duration(days: 365)))} to ${DateFormat('yyyy MMM').format(DateTime.now())} | ${pnlState.summary.tradeCount} trades',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String value,
    required bool isPositive,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        Row(
          children: [
            if (title != 'Trade Count')
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? AppTheme.profitColor : AppTheme.errorColor,
                size: 16,
              ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: title != 'Trade Count'
                    ? (isPositive ? AppTheme.profitColor : AppTheme.errorColor)
                    : AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentValuesBox(PnLState pnlState) {
    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, tradingState) {
        final tradingMode = tradingState.trading.tradingMode;

        return Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateFormat('dd MMM yyyy').format(DateTime.now())} | Week ${(DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays / 7).ceil()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  // Trading mode indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tradingMode == TradingMode.backTesting
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : AppTheme.accent1.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tradingMode == TradingMode.backTesting ? 'Backtesting' : 'Forward Testing',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: tradingMode == TradingMode.backTesting
                            ? AppTheme.primaryColor
                            : AppTheme.accent1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppTheme.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'P&L:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(pnlState.summary.netProfit / 100000).toStringAsFixed(2)} lakh',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fund:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '₹${(pnlState.summary.currentValue / 100000).toStringAsFixed(2)} lakh',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              if (pnlState.summary.medianCapital != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Median Capital:',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '₹${pnlState.summary.medianCapitalInLakhs.toStringAsFixed(2)} lakh',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // Chart toggle buttons
              ChartToggle(
                chartHighlight: pnlState.chartHighlight,
                onToggleChanged: (highlight) {
                  context.read<PnLBloc>().add(
                    PnLChartHighlightChanged(highlight: highlight),
                  );
                },
                showMedianCapital: pnlState.showMedianCapital,
                onMedianCapitalToggled: (show) {
                  context.read<PnLBloc>().add(
                    PnLMedianCapitalToggled(showMedianCapital: show),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Dual-axis chart
              SizedBox(
                height: 300,
                child: DualAxisChart(
                  dataPoints: pnlState.summary.dataPoints,
                  chartHighlight: pnlState.chartHighlight,
                  showMedianCapital: pnlState.showMedianCapital,
                  medianCapital: pnlState.summary.medianCapital,
                  tradingMode: tradingMode,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentValueItem({
    required String title,
    required String value,
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isHighlighted ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPnLTable(BuildContext context, PnLState pnlState) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'P&L Table',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                _buildViewToggle(context),
              ],
            ),
            const SizedBox(height: 16),
            if (pnlState.status == PnLStatus.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                ),
              )
            else
              // Use a fixed height container instead of Flexible to avoid layout issues
              SizedBox(
                height: 300,
                child: _buildPnLTableContent(context, pnlState),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showMonthlyView = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _showMonthlyView ? AppTheme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Monthly',
                style: TextStyle(
                  color: _showMonthlyView ? Colors.white : AppTheme.textSecondaryColor,
                  fontWeight: _showMonthlyView ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showMonthlyView = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: !_showMonthlyView ? AppTheme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Weekly',
                style: TextStyle(
                  color: !_showMonthlyView ? Colors.white : AppTheme.textSecondaryColor,
                  fontWeight: !_showMonthlyView ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPnLTableContent(BuildContext context, PnLState pnlState) {
    final data = _showMonthlyView ? pnlState.summary.monthlyData : pnlState.summary.weeklyData;

    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available for the selected time range',
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
      );
    }

    // Add a header row to explain the columns
    return Column(
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Period',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Trades',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'P&L',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Divider
        Divider(color: Colors.grey.withOpacity(0.3)),
        // List of items
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return _buildPnLListItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPnLListItem(PnLPeriodData item) {
    final isPositive = item.amount >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Period column
          Expanded(
            flex: 3,
            child: Text(
              item.period,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Trade count column
          Expanded(
            flex: 2,
            child: Text(
              '${item.tradeCount} trades',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // P&L amount and percentage column
          Expanded(
            flex: 4, // Increased flex to give more space
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min, // Use minimum space needed
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppTheme.profitColor : AppTheme.errorColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '₹${item.amount.toStringAsFixed(0)}', // Removed decimal places to save space
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isPositive ? AppTheme.profitColor : AppTheme.errorColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${isPositive ? '+' : ''}${item.percentage.toStringAsFixed(1)}%)', // Reduced decimal places
                  style: TextStyle(
                    fontSize: 12,
                    color: isPositive ? AppTheme.profitColor : AppTheme.errorColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Removed old _buildPnLChart method as we're now using DualAxisChart

  Future<void> _showDateRangePicker(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: _customFromDate ?? DateTime.now().subtract(const Duration(days: 30)),
      end: _customToDate ?? DateTime.now(),
    );

    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimaryColor,
              surface: AppTheme.surfaceColor,
              secondary: AppTheme.secondaryColor,
            ),
            dialogBackgroundColor: AppTheme.surfaceColor,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() {
        _customFromDate = pickedRange.start;
        _customToDate = pickedRange.end;
      });

      context.read<PnLBloc>().add(
            PnLDataRequested(
              fromDate: pickedRange.start,
              toDate: pickedRange.end,
            ),
          );
    }
  }
}

class _BuildChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _BuildChartLegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
