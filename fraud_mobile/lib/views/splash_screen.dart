import 'package:flutter/material.dart';
import 'package:fraud_mobile/routes.dart';
import 'package:provider/provider.dart';
import 'package:fraud_mobile/providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  void _checkUserAuthentication() async {
    // Optionally, you could show a splash screen longer based on API loading
    await Future.delayed(const Duration(seconds: 2));

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    try {
      // Using the new isAuthenticated method
      bool isAuthenticated = await userProvider.isAuthenticated();

      // Navigate based on authentication status
      if (isAuthenticated) {
        Navigator.of(context).pushReplacementNamed(Routes.dashboardRoute);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
      }
    } catch (e) {
      // Handle error, maybe navigate to an error page or show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking authentication: $e')),
      );
      // Optionally navigate to login if authentication fails
      Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
