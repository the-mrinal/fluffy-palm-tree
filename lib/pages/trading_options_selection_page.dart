import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paper_bulls/bloc/auth/auth_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_state.dart';
import 'package:paper_bulls/bloc/trading/trading_bloc.dart';
import 'package:paper_bulls/bloc/trading/trading_event.dart';
import 'package:paper_bulls/bloc/trading/trading_state.dart';
import 'package:paper_bulls/models/trading_model.dart';
import 'package:paper_bulls/services/navigation_service.dart';
import 'package:paper_bulls/utils/constants.dart';
import 'package:paper_bulls/utils/responsive.dart';
import 'package:paper_bulls/utils/theme.dart';

class TradingOptionsSelectionPage extends StatefulWidget {
  const TradingOptionsSelectionPage({super.key});

  @override
  State<TradingOptionsSelectionPage> createState() => _TradingOptionsSelectionPageState();
}

class _TradingOptionsSelectionPageState extends State<TradingOptionsSelectionPage> {
  TradingMode? _selectedMode;
  DateTime? _fromDate;
  DateTime? _toDate;
  final _capitalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize capital amount from trading bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tradingState = context.read<TradingBloc>().state;
      _capitalController.text = tradingState.trading.capitalAmount.toString();
    });
  }

  @override
  void dispose() {
    _capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trading Options'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService.navigateBack(context),
        ),
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

          return BlocBuilder<TradingBloc, TradingState>(
            builder: (context, tradingState) {
              if (_capitalController.text.isEmpty) {
                _capitalController.text = tradingState.trading.capitalAmount.toString();
              }

              return SafeArea(
                child: Padding(
                  padding: Responsive.getScreenPadding(context),
                  child: Form(
                    key: _formKey,
                    child: Responsive.responsiveBuilder(
                      context: context,
                      mobile: _buildMobileLayout(),
                      tablet: _buildTabletLayout(),
                      desktop: _buildDesktopLayout(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _buildCapitalDisplay(),
          const SizedBox(height: 24),
          _buildTradingModeSelector(),
          const SizedBox(height: 24),
          // Only show date selection after a trading mode is selected
          // For backtesting, show date selection; for forward testing, show info
          if (_selectedMode != null) _buildBacktestingSection(),
          const SizedBox(height: 32),
          _buildContinueButton(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          _buildCapitalDisplay(),
          const SizedBox(height: 32),
          _buildTradingModeSelector(),
          const SizedBox(height: 32),
          // Only show date selection after a trading mode is selected
          // For backtesting, show date selection; for forward testing, show info
          if (_selectedMode != null) _buildBacktestingSection(),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 300,
              child: _buildContinueButton(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              _buildCapitalDisplay(),
              const SizedBox(height: 40),
              _buildTradingModeSelector(),
              const SizedBox(height: 40),
              // Only show date selection after a trading mode is selected
              // For backtesting, show date selection; for forward testing, show info
              if (_selectedMode != null) _buildBacktestingSection(),
              const SizedBox(height: 48),
              Center(
                child: SizedBox(
                  width: 300,
                  child: _buildContinueButton(),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapitalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Capital Amount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _capitalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Capital Amount',
                  hintText: 'Enter amount in INR',
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a capital amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  // Validate minimum amount and increment
                  if (amount < 400000) {
                    return 'Minimum capital amount is ₹4 lakhs';
                  }
                  if (amount % 100000 != 0) {
                    return 'Amount must be in increments of ₹1 lakh';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                _buildIncrementButton(true),
                const SizedBox(height: 4),
                _buildIncrementButton(false),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Note: Minimum ₹4 lakhs, increments of ₹1 lakh only',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildIncrementButton(bool isIncrement) {
    return InkWell(
      onTap: () {
        final currentValue = double.tryParse(_capitalController.text) ?? 400000.0;
        double newValue;

        if (isIncrement) {
          newValue = currentValue + 100000.0;
        } else {
          newValue = currentValue - 100000.0;
          // Don't go below minimum
          if (newValue < 400000.0) {
            newValue = 400000.0;
          }
        }

        setState(() {
          _capitalController.text = newValue.toString();
        });
      },
      child: Container(
        width: 40,
        height: 30,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTradingModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Trading Mode',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                title: 'Backtesting',
                description: 'Test strategies on historical data',
                icon: Icons.history,
                isSelected: _selectedMode == TradingMode.backTesting,
                onTap: () {
                  setState(() {
                    _selectedMode = TradingMode.backTesting;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModeCard(
                title: 'Forward Testing',
                description: 'Test strategies on current market',
                icon: Icons.trending_up,
                isSelected: _selectedMode == TradingMode.forwardTesting,
                onTap: () {
                  setState(() {
                    _selectedMode = TradingMode.forwardTesting;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 48,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppTheme.primaryColor.withOpacity(0.8) : AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Non-interactive capital display for Trading Options page
  Widget _buildCapitalDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Capital Amount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.currency_rupee,
                color: AppTheme.textPrimaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                _capitalController.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Initial capital amount set during onboarding',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildBacktestingSection() {
    final dateFormat = DateFormat(AppConstants.dateFormatDisplay);
    final now = DateTime.now();

    // Set default dates if not already set
    if (_fromDate == null || _toDate == null) {
      // From date should be at least 10 days before current date
      _fromDate = now.subtract(const Duration(days: 15));
      _toDate = now;
    }

    // For Forward Testing, we don't need date selection
    if (_selectedMode == TradingMode.forwardTesting) {
      // Calculate next trading day
      final nextTradingDay = _getNextTradingDay();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Forward Testing Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Forward testing will begin from the next valid trading day. No date selection is needed.',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.infoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.infoColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.infoColor),
                    const SizedBox(width: 8),
                    const Text(
                      'Trading Start Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.infoColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Trading will begin on: ${DateFormat('EEEE, MMMM d, yyyy').format(nextTradingDay)}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Note: Trading starts at 9:00 AM on trading days. Weekends and holidays are excluded.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // For Backtesting, show date selection
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date Range',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose a date range for backtesting. The from-date must be at least 10 days before current date, and there must be at least 10 days between from and to dates.',
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateSelector(
                label: 'From Date',
                date: _fromDate,
                onTap: () => _selectDate(context, isFromDate: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateSelector(
                label: 'To Date',
                date: _toDate,
                onTap: () => _selectDate(context, isFromDate: false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_fromDate != null && _toDate != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.infoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.infoColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Trade ideas will be fetched for ${_getNextThursday(_fromDate!)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Calculate the next valid trading day
  DateTime _getNextTradingDay() {
    DateTime today = DateTime.now();

    // Skip to next day if current day is after trading hours (4 PM)
    if (today.hour >= 16) {
      today = today.add(const Duration(days: 1));
    }

    // Skip weekends
    while (today.weekday == DateTime.saturday || today.weekday == DateTime.sunday) {
      today = today.add(const Duration(days: 1));
    }

    // TODO: Add holiday check logic here if needed

    return today;
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final dateFormat = DateFormat(AppConstants.dateFormatDisplay);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.textSecondaryColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null ? dateFormat.format(date) : 'Select Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: date != null ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
                  ),
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Validate testing mode selection
          if (_selectedMode == null) {
            _showSnackBar('Please select a testing mode');
            return;
          }

          // For backtesting, validate date selection
          if (_selectedMode == TradingMode.backTesting) {
            // Validate date selection
            if (_fromDate == null || _toDate == null) {
              _showSnackBar('Please select both from and to dates');
              return;
            }

            // Validate date range
            if (!isValidDateRange()) {
              return; // Error message is shown in isValidDateRange method
            }
          } else {
            // For forward testing, set fromDate to next trading day
            _fromDate = _getNextTradingDay();
            _toDate = _fromDate!.add(const Duration(days: 30)); // Set a default range of 30 days
          }

          // Update trading state
          final capitalAmount = double.parse(_capitalController.text);

          context.read<TradingBloc>().add(
                TradingCapitalUpdated(capitalAmount: capitalAmount),
              );

          context.read<TradingBloc>().add(
                TradingModeSelected(tradingMode: _selectedMode!),
              );

          context.read<TradingBloc>().add(
                TradingDateRangeUpdated(
                  fromDate: _fromDate!,
                  toDate: _toDate!,
                ),
              );

          // Navigate to dashboard and remove all previous routes
          // This prevents returning to the setup screens
          NavigationService.navigateToMockTradingDashboard(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Continue',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isFromDate}) async {
    final now = DateTime.now();

    // For backtesting, from date must be at least 10 days before current date
    final minFromDate = now.subtract(const Duration(days: 10));

    // Determine date constraints based on testing mode and which date is being selected
    DateTime initialDate;
    DateTime firstDate;
    DateTime lastDate;

    if (isFromDate) {
      initialDate = _fromDate ?? minFromDate;
      firstDate = DateTime(now.year - 1, now.month, now.day); // Allow up to 1 year back
      lastDate = _selectedMode == TradingMode.backTesting
          ? minFromDate  // For backtesting, from date must be at least 10 days before current
          : now;         // For forward testing, can select up to current date
    } else {
      // For to date, ensure it's at least 10 days after from date
      final minToDate = _fromDate != null
          ? _fromDate!.add(const Duration(days: 10))
          : minFromDate.add(const Duration(days: 10));

      initialDate = _toDate ?? now;
      firstDate = minToDate;
      lastDate = now;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;

          // If to date is not set or doesn't meet the 10-day difference requirement
          if (_toDate == null || _toDate!.difference(_fromDate!).inDays < 10) {
            // Set to date to be 10 days after from date, or current date if that would be in the future
            final newToDate = _fromDate!.add(const Duration(days: 10));
            _toDate = newToDate.isAfter(now) ? now : newToDate;
          }
        } else {
          _toDate = picked;
        }
      });
    }
  }

  // Validate date range according to requirements
  bool isValidDateRange() {
    if (_fromDate == null || _toDate == null) return false;

    final now = DateTime.now();
    final minFromDate = now.subtract(const Duration(days: 10));

    // For backtesting, from date must be at least 10 days before current date
    if (_selectedMode == TradingMode.backTesting && _fromDate!.isAfter(minFromDate)) {
      _showSnackBar('From date must be at least 10 days before current date');
      return false;
    }

    // Ensure there's at least 10 days between from date and to date
    final difference = _toDate!.difference(_fromDate!).inDays;
    if (difference < 10) {
      _showSnackBar('There must be at least 10 days between from and to dates');
      return false;
    }

    return true;
  }

  String _getNextThursday(DateTime fromDate) {
    final dateFormat = DateFormat(AppConstants.dateFormatDisplay);

    // Find the next Thursday after from date
    DateTime nextThursday = fromDate;
    while (nextThursday.weekday != DateTime.thursday) {
      nextThursday = nextThursday.add(const Duration(days: 1));
    }

    return dateFormat.format(nextThursday);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
