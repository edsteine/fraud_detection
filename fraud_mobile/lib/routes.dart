import 'package:flutter/material.dart';
import 'package:fraud_mobile/views/dashboard_view.dart';
import 'package:fraud_mobile/views/login_view.dart';
import 'package:fraud_mobile/views/splash_screen.dart';
import 'package:fraud_mobile/views/transaction_detail_view.dart';
// import 'package:fraud_mobile/views/forgot_password_view.dart'; // Add import for Forgot Password
import 'package:fraud_mobile/views/profile_view.dart'; // Add import for Profile
// import 'package:fraud_mobile/views/create_user_view.dart'; // Add import for Create User
// import 'package:fraud_mobile/views/create_transaction_view.dart'; // Add import for Create Transaction
// import 'package:fraud_mobile/views/logout_view.dart'; // Add import for Logout

class Routes {
  static const String loginRoute = '/';
  static const String dashboardRoute = '/dashboard';
  static const String transactionDetailRoute = '/transactionDetail';
  static const String splashRoute = '/splash';
  static const String forgotPasswordRoute = '/forgotPassword'; // Add Forgot Password route
  static const String profileRoute = '/profile'; // Add Profile route
  static const String createUserRoute = '/createUser'; // Add Create User route
  static const String createTransactionRoute = '/createTransaction'; // Add Create Transaction route
  static const String logoutRoute = '/logout'; // Add Logout route

  static Route<dynamic> generateRoute(RouteSettings settings,ValueNotifier<bool> isDarkTheme) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginRoute:
      return MaterialPageRoute(
        builder: (_) => LoginView(
          isDarkTheme: isDarkTheme, // Pass the ValueNotifier
        ),
      );
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => DashboardView());
      case transactionDetailRoute:
        final String transactionId = settings.arguments as String; // Expecting a transaction ID
        return MaterialPageRoute(
          builder: (_) => TransactionDetailView(transactionId: transactionId),
        );
      case forgotPasswordRoute:
        // return MaterialPageRoute(builder: (_) => ForgotPasswordView()); // Forgot Password
      case profileRoute:
        return MaterialPageRoute(builder: (_) => ProfileView()); // Profile
      case createUserRoute:
        // return MaterialPageRoute(builder: (_) => CreateUserView()); // Create User
      case createTransactionRoute:
        // return MaterialPageRoute(builder: (_) => CreateTransactionView()); // Create Transaction
      case logoutRoute:
        // return MaterialPageRoute(builder: (_) => LogoutView()); // Logout
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Error: Unknown Route'),
        ),
      ),
    );
  }
}
