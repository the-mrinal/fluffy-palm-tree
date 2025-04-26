import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_state.dart';
import 'package:paper_bulls/services/navigation_service.dart';
import 'package:paper_bulls/utils/constants.dart';
import 'package:paper_bulls/utils/responsive.dart';
import 'package:paper_bulls/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Responsive.getScreenPadding(context),
          child: Responsive.responsiveBuilder(
            context: context,
            mobile: _buildMobileLayout(context),
            tablet: _buildTabletLayout(context),
            desktop: _buildDesktopLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          _buildLogo(),
          const SizedBox(height: 40),
          _buildWelcomeText(),
          const SizedBox(height: 40),
          _buildAppBanner(context),
          const SizedBox(height: 40),
          _buildLoginButton(context),
          const SizedBox(height: 16),
          _buildExploreButton(),
          const SizedBox(height: 16),
          _buildApiTestButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),
          _buildLogo(),
          const SizedBox(height: 60),
          _buildWelcomeText(),
          const SizedBox(height: 60),
          _buildAppBanner(context),
          const SizedBox(height: 60),
          Row(
            children: [
              Expanded(child: _buildLoginButton(context)),
              const SizedBox(width: 16),
              Expanded(child: _buildExploreButton()),
            ],
          ),
          const SizedBox(height: 16),
          _buildApiTestButton(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 40),
              _buildWelcomeText(),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: _buildLoginButton(context)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildExploreButton()),
                ],
              ),
              const SizedBox(height: 16),
              _buildApiTestButton(context),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 1,
          child: _buildAppBanner(context),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return const Text(
      'Paper Bulls',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Paper Bulls',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Practice trading without risking real money. Perfect your strategy with our mock trading platform.',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAppBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(AppConstants.marketfeedWebsite),
      child: Container(
        height: Responsive.isMobile(context) ? 200 : 300,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_up,
                size: 64,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Visit Marketfeed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Learn more about our products and services',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return ElevatedButton(
            onPressed: () {
              NavigationService.navigateTo(
                context,
                AppConstants.getStartedRoute,
              );
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
              'Continue to Dashboard',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ElevatedButton(
          onPressed: () {
            NavigationService.navigateTo(
              context,
              AppConstants.loginRoute,
            );
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
            'Login',
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  Widget _buildExploreButton() {
    return OutlinedButton(
      onPressed: () {
        // Non-functional as per requirements
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primaryColor,
        side: const BorderSide(color: AppTheme.primaryColor),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Explore Products',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildApiTestButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        NavigationService.navigateTo(
          context,
          AppConstants.apiTestRoute,
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.purple,
        side: const BorderSide(color: Colors.purple),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'API Test Page',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
