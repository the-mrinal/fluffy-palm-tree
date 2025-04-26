import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_bloc.dart';
import 'package:paper_bulls/bloc/auth/auth_event.dart';
import 'package:paper_bulls/bloc/pnl/pnl_bloc.dart';
import 'package:paper_bulls/bloc/trading/trading_bloc.dart';
import 'package:paper_bulls/bloc/trading/trading_event.dart';
import 'package:paper_bulls/services/auth_service.dart';
import 'package:paper_bulls/services/navigation_service.dart';
import 'package:paper_bulls/services/pnl_service.dart';
import 'package:paper_bulls/services/storage_service.dart';
import 'package:paper_bulls/utils/constants.dart';
import 'package:paper_bulls/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final storageService = StorageService();
    final authService = AuthService();
    final pnlService = PnLService();

    // Create the TradingBloc first
    final tradingBloc = TradingBloc(
      storageService: storageService,
    )..add(TradingInitialized());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authService: authService,
            storageService: storageService,
          )..add(AuthCheckRequested()),
        ),
        BlocProvider<TradingBloc>(
          create: (context) => tradingBloc,
        ),
        BlocProvider<PnLBloc>(
          create: (context) => PnLBloc(
            pnlService: pnlService,
            tradingBloc: tradingBloc,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routerConfig: NavigationService.router,
      ),
    );
  }
}
