import 'dart:ui';
import 'package:flutter/material.dart'; // Import this for Color usage

class AppConfig {
  static const String appName = 'Fraud Detection App';
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api'; // Replace with your actual API base URL

  // Debug flag
  static const bool isDebug = true; // Change to false for production

  // Default padding
  static const double defaultPadding = 16.0;

  // API endpoints
  static String get registerUrl => '$apiBaseUrl/register/';
  static String get loginUrl => '$apiBaseUrl/login/';
  static String get logoutUrl => '$apiBaseUrl/logout/';
  static String get profileUrl => '$apiBaseUrl/profile/';
  static String get transactionsUrl => '$apiBaseUrl/transactions/';
  static String get transactionCreateUrl => '$apiBaseUrl/transactions/create/';
  static String transactionDetailUrl(String id) => '$apiBaseUrl/transactions/$id/';
  static String transactionProcessUrl(String id) => '$apiBaseUrl/process/$id/';
  static String fraudCheckUrl(String id) => '$apiBaseUrl/checkfraud/$id/';

  // Theme colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFFF0000); // Optional: Error color

  // Optional: Add a function to validate URLs
  static bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
  }

  // Other configurations or utility functions can be added here as needed

  // Helper method to show Snackbar
  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
