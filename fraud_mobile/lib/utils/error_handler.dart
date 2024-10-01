import 'package:flutter/material.dart';

class ErrorHandling {
  // Display a snackbar with the error message
  static void showErrorSnackbar(BuildContext context, String message, {Duration duration = const Duration(seconds: 3)}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: duration, // Set duration for the snackbar
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Handle API errors based on status code and return a user-friendly message
  static String handleApiError(int statusCode, {String? serverMessage}) {
    // Log the error (optional, can be expanded to log to a server)
    debugPrint('API Error: Status Code $statusCode');

    // Return server-specific message if available
    if (serverMessage != null && serverMessage.isNotEmpty) {
      return serverMessage;
    }

    // Handle common HTTP status codes
    switch (statusCode) {
      case 400:
        return 'Bad Request: The server could not understand the request.';
      case 401:
        return 'Unauthorized: Access is denied due to invalid credentials.';
      case 403:
        return 'Forbidden: You do not have permission to access this resource.';
      case 404:
        return 'Not Found: The requested resource could not be found.';
      case 408:
        return 'Request Timeout: The server took too long to respond.';
      case 429:
        return 'Too Many Requests: Please try again later.';
      case 500:
        return 'Internal Server Error: An error occurred on the server.';
      case 502:
        return 'Bad Gateway: The server received an invalid response.';
      case 503:
        return 'Service Unavailable: The server is temporarily unable to handle the request.';
      case 504:
        return 'Gateway Timeout: The server took too long to respond.';
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }

  // Handle errors with the option to retry
  static void showErrorSnackbarWithRetry(BuildContext context, String message, VoidCallback onRetry) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'Retry',
        onPressed: onRetry, // Call the provided retry function
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Optionally parse and handle error messages from the server's response body (assuming it's JSON)
  static String parseServerError(dynamic responseBody) {
    try {
      if (responseBody is Map && responseBody.containsKey('message')) {
        return responseBody['message'];
      }
      return 'An error occurred, but no message was provided by the server.';
    } catch (e) {
      debugPrint('Error parsing server response: $e');
      return 'An error occurred, and the response could not be parsed.';
    }
  }
}
