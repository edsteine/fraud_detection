import 'dart:convert';
import 'dart:async';
import 'package:fraud_mobile/services/token_service.dart';
import 'package:fraud_mobile/widgets/common_widgets.dart';
import 'package:fraud_mobile/utils/app_config.dart';
import 'package:fraud_mobile/models/transaction.dart';

class ApiService {
  final TokenService _tokenService;

  ApiService(this._tokenService);

  // Get transaction details by ID
  Future<Transaction> getTransactionDetail(String transactionId) async {
    try {
      print(AppConfig.transactionDetailUrl(transactionId)); // Call the function with transactionId
print(transactionId);
final response = await _tokenService.makeRequest(
  url: AppConfig.transactionDetailUrl(transactionId), // Correct function call
  method: 'GET',
);
      if (response.statusCode == 200) {
        return Transaction.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load transaction detail: ${response.statusCode}');
      }
    } catch (e) {
      SnackbarHelper.showSnackbar("Error fetching transaction detail: $e");
      rethrow;
    }
  }

  // Fetch all transactions
 Future<List<Transaction>> fetchTransactions() async {
  try {
    final response = await _tokenService.makeRequest(
      url: AppConfig.transactionsUrl,
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      // Try parsing each transaction and log potential issues
      return jsonData.map((transaction) {
        try {
          return Transaction.fromJson(transaction);
        } catch (e) {
          print("Error parsing transaction: $transaction. Error: $e");
          throw Exception("Failed to parse transaction: $e");
        }
      }).toList();
    } else {
      throw Exception("Failed to fetch transactions: ${response.statusCode}");
    }
  } catch (e) {
    SnackbarHelper.showSnackbar("Error fetching transactions: $e");
    return []; // or consider rethrowing the exception
  }
}


  // Create a new transaction
  Future<Transaction> createTransaction(double amount, String transactionType, String description, String username, String category, bool isFraud) async {
    try {
      final response = await _tokenService.makeRequest(
        url: AppConfig.transactionCreateUrl,
        method: 'POST',
        body: {
          'amount': amount,
          'transaction_type': transactionType,
          'description': description,
          'username': username,
          'category': category,
          'is_fraud': isFraud,
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Transaction.fromJson(data);
      } else {
        throw Exception("Failed to create transaction: ${response.statusCode}");
      }
    } catch (e) {
      SnackbarHelper.showSnackbar("Error creating transaction: $e");
      rethrow; // or return a default transaction
    }
  }

  // Process a transaction
  Future<bool> processTransaction(Transaction transaction) async {
    try {
      final response = await _tokenService.makeRequest(
        url: AppConfig.transactionProcessUrl(transaction.transactionId!),
        method: 'POST',
        body: {
          'amount': transaction.amount,
          'transaction_type': transaction.transactionType,
          'description': transaction.description,
          'username': transaction.username,
          'category': transaction.category,
          'is_fraud': transaction.isFraud,
        },
      );

      if (response.statusCode == 200) {
        SnackbarHelper.showSnackbar("Transaction processed successfully");
        return true;
      } else {
        throw Exception("Failed to process transaction: ${response.statusCode}");
      }
    } catch (e) {
      SnackbarHelper.showSnackbar("Error processing transaction: $e");
      return false;
    }
  }

  // Check if a transaction is fraudulent
  Future<bool> checkFraud(String transactionId) async {
    try {
      final response = await _tokenService.makeRequest(
        url: AppConfig.fraudCheckUrl(transactionId),
        method: 'GET',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['is_fraudulent'];
      } else {
        throw Exception("Failed to check fraud status: ${response.statusCode}");
      }
    } catch (e) {
      SnackbarHelper.showSnackbar("Error checking fraud: $e");
      return false;
    }
  }
}
