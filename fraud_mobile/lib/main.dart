import 'package:flutter/material.dart';
import 'package:fraud_mobile/services/api_service.dart';
import 'package:fraud_mobile/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:fraud_mobile/providers/user_provider.dart';
import 'package:fraud_mobile/providers/transaction_provider.dart';
import 'package:fraud_mobile/routes.dart';
import 'package:fraud_mobile/services/auth_service.dart';
import 'package:fraud_mobile/services/token_service.dart';
import 'globals.dart';

void main() {
  // Create an instance of DashboardController

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(AuthService(TokenService())), // Provide instances of AuthService and TokenService
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(ApiService(TokenService())), // Provide DashboardController instance to TransactionProvider
        ),
        // Add other providers here if necessary
      ],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

final ValueNotifier<bool> isDarkTheme = ValueNotifier(false);

  @override
Widget build(BuildContext context) {
  return ValueListenableBuilder<bool>(
    valueListenable: isDarkTheme,
    builder: (context, isDark, child) {
      return MaterialApp(
        title: 'Fraud Detection App',
        scaffoldMessengerKey: scaffoldMessengerKey,
        initialRoute: '/splash',
        theme: isDark ? AppThemes.darkTheme : AppThemes.lightTheme,
        onGenerateRoute: (settings) => Routes.generateRoute(settings, isDarkTheme),
      );
    },
  );
}
}
