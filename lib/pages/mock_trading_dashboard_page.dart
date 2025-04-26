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
import 'package:paper_bulls/utils/chart_colors.dart';
import 'package:paper_bulls/utils/constants.dart';
import 'package:paper_bulls/utils/responsive.dart';
import 'package:paper_bulls/utils/theme.dart';
import 'package:paper_bulls/widgets/chart_toggle.dart';
import 'package:paper_bulls/widgets/dual_axis_chart.dart';

class MockTradingDashboardPage extends StatefulWidget {
  const MockTradingDashboardPage({super.key});

  @override
  State<MockTradingDashboardPage> createState() => _MockTradingDashboardPageState();
}

class _MockTradingDashboardPageState extends State<MockTradingDashboardPage> {
  @override
  void initState() {
    super.initState();

    // Load PnL data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PnLBloc>().add(const PnLDataRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Trading Dashboard'),
        automaticallyImplyLeading: false,
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
              child: Responsive.responsiveBuilder(
                context: context,
                mobile: _buildMobileLayout(context, authState),
                tablet: _buildTabletLayout(context, authState),
                desktop: _buildDesktopLayout(context, authState),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthState authState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(authState),
          const SizedBox(height: 24),
          _buildPnLBanner(context),
          const SizedBox(height: 24),
          _buildManageFundsWidget(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, AuthState authState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(authState),
          const SizedBox(height: 32),
          _buildPnLBanner(context),
          const SizedBox(height: 32),
          _buildManageFundsWidget(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AuthState authState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(authState),
          const SizedBox(height: 40),
          _buildPnLBanner(context),
          const SizedBox(height: 40),
          _buildManageFundsWidget(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTopBar(AuthState authState) {
    final userName = authState.user?.name ?? 'User';

    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, tradingState) {
        final fromDate = tradingState.trading.fromDate;
        final dateFormat = DateFormat('d MMM yyyy');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const CircleAvatar(
                  backgroundColor: AppTheme.primaryLightColor,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (fromDate != null)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Since ${dateFormat.format(fromDate)}",
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPnLBanner(BuildContext context) {
    return BlocBuilder<PnLBloc, PnLState>(
      builder: (context, pnlState) {
        return BlocBuilder<TradingBloc, TradingState>(
          builder: (context, tradingState) {
            final tradingMode = tradingState.trading.tradingMode;

            return GestureDetector(
              onTap: () {
                NavigationService.navigateTo(context, AppConstants.pnlOverviewRoute);
              },
              child: Container(
                padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 24),
                decoration: BoxDecoration(
                  color: ChartColors.chartBackgroundColor, // Using the centralized color constant
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lifetime P&L',
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.trending_up,
                                color: AppTheme.primaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${pnlState.summary.growthPercentage.toStringAsFixed(2)}%',
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${pnlState.summary.netProfit.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppTheme.textPrimaryColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.bar_chart,
                                    color: AppTheme.primaryColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${pnlState.summary.tradeCount} Trades',
                                    style: const TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              tradingMode == TradingMode.backTesting ? 'Backtesting' : 'Forward Testing',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Chart toggle buttons with white text
                    Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: Theme.of(context).textTheme.apply(
                          bodyColor: AppTheme.textPrimaryColor,
                          displayColor: AppTheme.textPrimaryColor,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.isMobile(context) ? 0 : 8,
                        ),
                        child: ChartToggle(
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
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dual-axis chart - responsive height based on screen size
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? 200
                          : Responsive.isTablet(context)
                              ? 300
                              : 350,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.apply(
                            bodyColor: AppTheme.textPrimaryColor,
                            displayColor: AppTheme.textPrimaryColor,
                          ),
                        ),
                        child: DualAxisChart(
                          dataPoints: pnlState.summary.dataPoints,
                          chartHighlight: pnlState.chartHighlight,
                          showMedianCapital: pnlState.showMedianCapital,
                          medianCapital: pnlState.summary.medianCapital,
                          tradingMode: tradingMode,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: AppTheme.textSecondaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tap to view detailed P&L',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // This method is no longer used as we've removed the chart
  // Keeping an empty implementation to avoid compilation errors in case it's referenced elsewhere
  Widget _buildPnLChart(PnLState pnlState) {
    return const SizedBox.shrink();
  }

  Widget _buildManageFundsWidget() {
    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, tradingState) {
        return BlocBuilder<PnLBloc, PnLState>(
          builder: (context, pnlState) {
            final capitalAmount = tradingState.trading.capitalAmount;
            final currentValue = pnlState.summary.currentValue;
            final netProfit = pnlState.summary.netProfit;

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Manage Funds',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildFundInfoItem(
                      title: 'Total Invested Capital',
                      value: '₹${capitalAmount.toStringAsFixed(2)}',
                      description: 'This is the amount you initially invested for mock trading.',
                    ),
                    const Divider(height: 32),
                    _buildFundInfoItem(
                      title: 'Current Portfolio Value',
                      value: '₹${currentValue.toStringAsFixed(2)}',
                      description: 'This is the current value of your portfolio including profits/losses.',
                    ),
                    const Divider(height: 32),
                    _buildFundInfoItem(
                      title: 'Withdrawable Amount',
                      value: '₹${netProfit > 0 ? netProfit.toStringAsFixed(2) : '0.00'}',
                      description: 'This is the amount you can withdraw from your profits.',
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFundInfoItem({
    required String title,
    required String value,
    required String description,
    bool isHighlighted = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isHighlighted ? AppTheme.successColor : AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
