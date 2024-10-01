/* import 'dart:convert';
import 'package:fraud_mobile/utils/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:fraud_mobile/models/transaction.dart';
import 'package:fraud_mobile/models/user.dart';

/// Fetch transactions from the backend API.
Future<List<Transaction>> fetchTransactions() async {
  try {
    // Send a GET request to the transactions API endpoint
    final response = await http.get(Uri.parse(AppConfig.transactionsUrl));

    // Check if the response was successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the JSON response body
      List<dynamic> jsonData = jsonDecode(response.body);
      
      // Map each dynamic object to a Transaction model and return the list
      return jsonData.map((transaction) => Transaction.fromJson(transaction)).toList();
    } else {
      // Handle server-side errors
      print("Error fetching transactions: ${response.statusCode}");
      return [];
    }
  } catch (error) {
    // Handle any errors during the HTTP request
    print("Error fetching transactions: $error");
    return [];
  }
}

/// Fetch users from the backend API.
Future<List<User>> fetchUsers() async {
  try {
    // Send a GET request to the users API endpoint
    final response = await http.get(Uri.parse(AppConfig.usersUrl)); // Use the static URL getter

    // Check if the response was successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the JSON response body
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Extract the list of users and map each to a User model
      List<dynamic> usersData = jsonData['users'];
      return usersData.map((user) => User.fromJson(user)).toList();
    } else {
      // Handle server-side errors
      print("Error fetching users: ${response.statusCode}");
      return [];
    }
  } catch (error) {
    // Handle any errors during the HTTP request
    print("Error fetching users: $error");
    return [];
  }
}
 */