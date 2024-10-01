import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'user_token';

  // Save token to shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Retrieve token from shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove token from shared preferences (e.g., on logout)
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  
  // Build headers for API requests
  Future<Map<String, String>> _buildHeaders() async {
    String? token = await getToken();
    return {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };
  }
 // Generic method to make HTTP requests
Future<http.Response> makeRequest({
  required String url,
  required String method,
  bool useHeaders = true,
  Map<String, dynamic>? body,
}) async {
  final uri = Uri.parse(url);
  
  // Build headers if useHeaders is true and ensure Content-Type is set to application/json
  final Map<String, String> requestHeaders = {};
  if (useHeaders) {
    requestHeaders.addAll(await _buildHeaders());
  }

  // Set the Content-Type to application/json if a body is provided
  if (body != null) {
    requestHeaders['Content-Type'] = 'application/json';
  }

  final String? jsonBody = body != null ? jsonEncode(body) : null;

  // Debugging prints

  // Send the request and get the response
  late http.Response response;
  switch (method.toUpperCase()) {
    case 'POST':
      response = await http.post(uri, headers: requestHeaders, body: jsonBody);
      break;
    case 'GET':
      response = await http.get(uri, headers: requestHeaders);
      break;
    case 'DELETE':
      response = await http.delete(uri, headers: requestHeaders);
      break;
    case 'PUT':
      response = await http.put(uri, headers: requestHeaders, body: jsonBody);
      break;
    default:
      print('Invalid HTTP method');
      throw Exception('Invalid HTTP method');
  }

  // Print the response
  print("url: $url");
  print("method: $method");
  print("requestHeaders: $requestHeaders");
  print("jsonBody: $jsonBody");
  print("response.statusCode: ${response.statusCode}");
  print('response.body: ${response.body}');

  // Return the response
  return response;
}



}
