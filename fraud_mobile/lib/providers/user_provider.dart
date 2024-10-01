import 'package:flutter/material.dart';
import 'package:fraud_mobile/models/user.dart';
import 'package:fraud_mobile/services/auth_service.dart';
import 'package:fraud_mobile/widgets/common_widgets.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _currentUser;
  User? _userProfile;
  bool _isLoading = false;
  
  final AuthService _authService;

  UserProvider(this._authService); // Constructor injection

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  // Function to load user profile
  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userProfile = await _authService.getUserProfile(); // Fetch user profile data
    } catch (e) {
      SnackbarHelper.showSnackbar('Failed to load user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Function to handle login
  Future<bool> login(String username, String password, BuildContext context) async {
    if (username.isEmpty || password.isEmpty) {
      SnackbarHelper.showSnackbar('Username or password cannot be empty');
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();
      
      final isLogged = await _authService.loginUser(username, password);
      if (isLogged!) {
        _isLoggedIn = true;
        _currentUser = await _authService.getUserProfile(); // Fetch user details after login
        notifyListeners();
        return true;
      } else {
        SnackbarHelper.showSnackbar('Authentication failed');
        return false;
      }
    } catch (e) {
      SnackbarHelper.showSnackbar('Error during login: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Function to handle logout
  void logout() {
    _authService.logoutUser(); // Call logout on AuthService
    _isLoggedIn = false;
    _currentUser = null;
    _userProfile = null; // Clear user profile on logout
    notifyListeners(); // Notify listeners about logout
  }

  // Refresh user details
  Future<void> refreshUserDetails() async {
    if (_currentUser != null) {
      try {
        _currentUser = await _authService.getUserProfile(); // Get current user profile
        notifyListeners(); // Notify listeners about updated user data
      } catch (e) {
        SnackbarHelper.showSnackbar('Error refreshing user details: $e');
      }
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return _isLoggedIn; // You can enhance this to check token validity or make an API call if needed
  }
}
