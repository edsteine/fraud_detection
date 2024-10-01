import 'package:flutter/material.dart';
import 'package:fraud_mobile/models/transaction.dart';
import 'package:fraud_mobile/services/api_service.dart';
import 'package:fraud_mobile/widgets/common_widgets.dart';

class TransactionProvider extends ChangeNotifier {
  final ApiService _apiService;

  TransactionProvider(this._apiService);

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method to load transactions from the API
  Future<void> loadTransactions() async {
    _setLoadingState(true); // Set loading to true and notify listeners
    try {
      _transactions = await _apiService.fetchTransactions(); // Fetch transactions
      print('Transactions fetched: $_transactions'); // Debugging line
      _errorMessage = null; // Clear previous errors
    } catch (e) {
      _handleError('Failed to load transactions: $e');
    } finally {
      _setLoadingState(false); // Set loading to false and notify listeners
    }
  }

  // Method to clear transactions, for example, when a user logs out
  void clearTransactions() {
    _transactions.clear();
    notifyListeners(); // Notify listeners about the change
  }

  // Helper method to handle loading state
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  // Helper method to handle errors and notify listeners
  void _handleError(String message) {
    _errorMessage = message;
    SnackbarHelper.showSnackbar(message); // Display the error message in a Snackbar
    notifyListeners(); // Notify listeners about the error
  }
}
