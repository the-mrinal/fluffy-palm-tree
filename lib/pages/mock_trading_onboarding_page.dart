import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_state.dart';
import 'package:paper_bulls/bloc/trading/trading_bloc.dart';
import 'package:paper_bulls/bloc/trading/trading_event.dart';
import 'package:paper_bulls/services/navigation_service.dart';
import 'package:paper_bulls/utils/constants.dart';
import 'package:paper_bulls/utils/responsive.dart';
import 'package:paper_bulls/utils/theme.dart';

class MockTradingOnboardingPage extends StatefulWidget {
  const MockTradingOnboardingPage({super.key});

  @override
  State<MockTradingOnboardingPage> createState() => _MockTradingOnboardingPageState();
}

class _MockTradingOnboardingPageState extends State<MockTradingOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _capitalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _capitalController.text = AppConstants.defaultCapitalAmount.toString();
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
        title: const Text('Mock Trading Setup'),
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

          return SafeArea(
            child: Padding(
              padding: Responsive.getScreenPadding(context),
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.isMobile(context) ? double.infinity : 500,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 64,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Set Your Capital',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Enter the amount you want to invest in mock trading',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          _buildCapitalInput(),
                          const SizedBox(height: 16),
                          _buildCapitalSlider(),
                          const SizedBox(height: 24),
                          _buildInfoBox(),
                          const SizedBox(height: 32),
                          _buildContinueButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCapitalInput() {
    return TextFormField(
      controller: _capitalController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Capital Amount',
        hintText: 'Enter amount in INR',
        prefixIcon: Icon(Icons.currency_rupee),
        border: OutlineInputBorder(),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a capital amount';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Please enter a valid amount';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Widget _buildCapitalSlider() {
    final capitalValue = double.tryParse(_capitalController.text) ?? AppConstants.defaultCapitalAmount;

    return Column(
      children: [
        Slider(
          value: capitalValue.clamp(10000, 1000000),
          min: 10000,
          max: 1000000,
          divisions: 99,
          label: '₹${capitalValue.toStringAsFixed(0)}',
          onChanged: (value) {
            setState(() {
              _capitalController.text = value.toInt().toString();
            });
          },
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('₹10,000', style: TextStyle(color: AppTheme.textSecondaryColor)),
            Text('₹1,000,000', style: TextStyle(color: AppTheme.textSecondaryColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.infoColor.withOpacity(0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.infoColor),
              SizedBox(width: 8),
              Text(
                'Important Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.infoColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'This is a mock trading platform. The capital you set here is virtual and does not involve real money. Use this platform to practice and refine your trading strategies without any financial risk.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final capitalAmount = double.parse(_capitalController.text);

          // Update trading state with capital amount
          context.read<TradingBloc>().add(
                TradingCapitalUpdated(capitalAmount: capitalAmount),
              );

          // Navigate to trading options selection
          // We don't use navigateAndRemoveUntil here because we want to allow
          // the user to go back to the onboarding page from the trading options selection
          NavigationService.navigateTo(
            context,
            AppConstants.tradingOptionsSelectionRoute,
          );
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
}
