import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_event.dart';
import 'package:paper_bulls/bloc/auth/auth_state.dart';
import 'package:paper_bulls/services/navigation_service.dart';
import 'package:paper_bulls/utils/constants.dart';
import 'package:paper_bulls/utils/responsive.dart';
import 'package:paper_bulls/utils/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _otpSent = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService.navigateBack(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.otpSent) {
            setState(() {
              _otpSent = true;
            });
            _showSnackBar('OTP sent successfully!');
          } else if (state.status == AuthStatus.authenticated) {
            NavigationService.navigateAfterLogin(context);
          } else if (state.status == AuthStatus.error) {
            _showSnackBar(state.errorMessage ?? AppConstants.genericErrorMessage);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: Responsive.getScreenPadding(context),
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.isMobile(context) ? double.infinity : 400,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.account_circle,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Login to continue to Paper Bulls',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          _buildMobileInput(),
                          const SizedBox(height: 16),
                          if (_otpSent) _buildOtpInput(),
                          const SizedBox(height: 24),
                          _buildActionButton(state),
                          if (state.status == AuthStatus.loading)
                            const Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
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

  Widget _buildMobileInput() {
    return TextFormField(
      controller: _mobileController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Mobile Number',
        hintText: 'Enter your 10-digit mobile number',
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(),
      ),
      maxLength: 10,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your mobile number';
        }
        if (value.length != 10) {
          return 'Please enter a valid 10-digit mobile number';
        }
        return null;
      },
      enabled: !_otpSent,
    );
  }

  Widget _buildOtpInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter OTP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter the 4-digit OTP',
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(),
          ),
          maxLength: 4,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the OTP';
            }
            if (value.length != 4) {
              return 'OTP must be 4 digits';
            }
            return null;
          },
        ),
        TextButton(
          onPressed: () {
            if (_mobileController.text.length == 10) {
              context.read<AuthBloc>().add(
                    AuthLoginRequested(
                      mobileNumber: _mobileController.text,
                    ),
                  );
            } else {
              _showSnackBar('Please enter a valid mobile number');
            }
          },
          child: const Text('Resend OTP'),
        ),
      ],
    );
  }

  Widget _buildActionButton(AuthState state) {
    return ElevatedButton(
      onPressed: state.status == AuthStatus.loading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                if (!_otpSent) {
                  context.read<AuthBloc>().add(
                        AuthLoginRequested(
                          mobileNumber: _mobileController.text,
                        ),
                      );
                } else {
                  context.read<AuthBloc>().add(
                        AuthVerifyOtpRequested(
                          mobileNumber: _mobileController.text,
                          otp: _otpController.text,
                        ),
                      );
                }
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
      child: Text(
        _otpSent ? 'Verify OTP' : 'Send OTP',
        style: const TextStyle(fontSize: 16),
      ),
    );
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
