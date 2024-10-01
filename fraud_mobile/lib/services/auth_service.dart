import 'dart:convert';
import 'package:fraud_mobile/services/token_service.dart';
import 'package:fraud_mobile/widgets/common_widgets.dart';
import 'package:fraud_mobile/utils/app_config.dart';
import 'package:fraud_mobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final TokenService _tokenService;

  AuthService(this._tokenService);


  // User registration
  Future<bool> registerUser(String username, String password, String email) async {
    try {
      final response = await _tokenService.makeRequest(
        url: AppConfig.registerUrl,
        method: 'POST',
        useHeaders: false,
        body: {
          'username': username,
          'password': password,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        SnackbarHelper.showSnackbar("User registered successfully: ${data['message']}");
        return true;
      } else {
        SnackbarHelper.showSnackbar("Registration failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      SnackbarHelper.showSnackbar('Error during registration: $e');
      return false;
    }
  }

  // User login
  Future<bool?> loginUser(String username, String password) async {
    try {
      await _removeToken();
      final response = await _tokenService.makeRequest(
        url: AppConfig.loginUrl,
        useHeaders: false,
        method: 'POST',
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Save token in Shared Preferences
        final token = data['token'];
        await _saveToken(token);
        return true;
      } else {
        SnackbarHelper.showSnackbar("Login failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      SnackbarHelper.showSnackbar('Error during login: $e');
      return false;
    }
  }

  // User logout
  Future<bool> logoutUser() async {
    try {
      final response = await _tokenService.makeRequest(
        url: AppConfig.logoutUrl,
        method: 'GET',
      );

      if (response.statusCode == 200) {
        await _removeToken(); // Remove token on logout
        SnackbarHelper.showSnackbar("Logout successful");
        return true;
      } else {
        SnackbarHelper.showSnackbar("Logout failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      SnackbarHelper.showSnackbar('Error during logout: $e');
      return false;
    }
  }

  // Get user profile
  Future<User?> getUserProfile() async {
    try {
      final response = await _tokenService.makeRequest(
        url: AppConfig.profileUrl,
        method: 'GET',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        SnackbarHelper.showSnackbar("Failed to load user profile: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      SnackbarHelper.showSnackbar('Error during fetching user profile: $e');
      return null;
    }
  }

  // Shared Preferences methods for token management
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }
}
