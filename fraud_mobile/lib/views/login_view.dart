import 'package:flutter/material.dart';
import 'package:fraud_mobile/routes.dart';
import 'package:provider/provider.dart';
import 'package:fraud_mobile/providers/user_provider.dart';

class LoginView extends StatefulWidget {
  final ValueNotifier<bool> isDarkTheme; // Change to ValueNotifier

  const LoginView({Key? key, required this.isDarkTheme}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkTheme.value ? const Color(0xFF1E1E2E) : Colors.white, // Change background based on theme
      appBar: AppBar(
        title: Text('Login View'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: widget.isDarkTheme,
            builder: (context, isDark, child) {
              return IconButton(
                icon: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay),
                onPressed: () {
                  widget.isDarkTheme.value = !isDark; // Toggle the ValueNotifier
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form( // Wrap with Form widget
              key: _formKey, // Assign the _formKey here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 60),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: TextStyle(
                      color: Colors.grey[600], // Adjust color for light theme
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    value: "edsteine",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    value: "password123",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Navigate to the forgot password screen
                      Navigator.of(context).pushReplacementNamed(Routes.dashboardRoute);
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String value,
    required IconData icon,
    bool isPassword = false,
  }) {
    // Initialize the controller text if empty
    if (controller.text.isEmpty) {
      controller.text = value;
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && _isObscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[400],
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your ${label.toLowerCase()}';
          }
          return null;
        },
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      try {
        bool success = await userProvider.login(
          _usernameController.text,
          _passwordController.text,
          context,
        );
        setState(() {
          _isLoading = false;
        });
        if (success) {
          Navigator.of(context).pushReplacementNamed(Routes.dashboardRoute);
        } else {
          _showErrorSnackBar('Invalid credentials');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('An error occurred. Please try again.');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
