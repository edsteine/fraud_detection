import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fraud_mobile/models/transaction.dart';
import 'package:fraud_mobile/services/api_service.dart';
import 'package:fraud_mobile/services/token_service.dart';
import 'package:intl/intl.dart';

class TransactionDetailView extends StatefulWidget {
  final String transactionId;

  const TransactionDetailView({Key? key, required this.transactionId}) : super(key: key);

  @override
  _TransactionDetailViewState createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  Transaction? _transaction;
  bool _showAmount = false;
  bool _isLoading = true;
  String? _errorMessage;

  late final TokenService _tokenService;
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _tokenService = TokenService();
    _apiService = ApiService(_tokenService);
    _fetchTransactionDetails();
  }

  Future<void> _fetchTransactionDetails() async {
    try {
      _transaction = await _apiService.getTransactionDetail(widget.transactionId);
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load transaction details';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showLoadingDialog(Function apiCall) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Processing...', style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );

    try {
      final result = await apiCall();
      Navigator.of(context).pop(); // Dismiss the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), duration: const Duration(seconds: 2)),
      );
    } catch (error) {
      Navigator.of(context).pop(); // Dismiss the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $error'), duration: const Duration(seconds: 2)),
      );
    }
  }

  Future<void> _processTransaction() async {
    await _showLoadingDialog(() async {
      final response = await _apiService.processTransaction(_transaction!);
      return 'Transaction processed: $response';
    });
  }

  Future<void> _checkFraud() async {
    await _showLoadingDialog(() async {
      final isFraud = await _apiService.checkFraud(widget.transactionId);
      return isFraud ? 'Fraud detected' : 'No fraud detected';
    });
  }

  Future<void> _toggleAmountVisibility() async {
    setState(() {
      _showAmount = !_showAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorScreen(_errorMessage!);
    }

    if (_transaction == null) {
      return _buildErrorScreen('Transaction not found');
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 0,
        title: const Text('Transaction Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24.0),
              _buildDetailSection('Transaction Information', [
                _buildDetailItem('Transaction ID:', _transaction!.transactionId.toString()),
                Text(
                  'Transaction Date: ${_transaction!.date != null ? DateFormat('yyyy-MM-dd').format(_transaction!.date!) : 'No Date Available'}',
                ),
                Text(
                  'Transaction Time: ${_transaction!.time ?? 'No Time Available'}',
                ),
                _buildDetailItem('Amount:', _showAmount ? '\$${_transaction!.amount ?? 'N/A'}' : '*****'),
                _buildDetailItem('Type:', _transaction!.transactionType ?? 'N/A'),
              ]),
              const SizedBox(height: 16.0),
              _buildDetailSection('Card Information', [
                _buildDetailItem('Card Type:', _transaction!.cardType ?? 'N/A'),
                _buildDetailItem('Entry Mode:', _transaction!.entryMode ?? 'N/A'),
              ]),
              const SizedBox(height: 16.0),
              _buildDetailSection('Merchant Information', [
                _buildDetailItem('Merchant Group:', _transaction!.merchantGroup ?? 'N/A'),
                if (_transaction!.merchantName != null)
                  _buildDetailItem('Merchant Name:', _transaction!.merchantName!),
              ]),
              const SizedBox(height: 16.0),
              _buildDetailSection('Location Information', [
                _buildDetailItem('Country of Transaction:', _transaction!.countryOfTransaction ?? 'N/A'),
                _buildDetailItem('Shipping Address:', _transaction!.shippingAddress ?? 'N/A'),
                _buildDetailItem('Country of Residence:', _transaction!.countryOfResidence ?? 'N/A'),
              ]),
              const SizedBox(height: 16.0),
              _buildDetailSection('Additional Information', [
                _buildDetailItem('Day of Week:', _transaction!.dayOfWeek ?? 'N/A'),
                if (_transaction!.description != null)
                  _buildDetailItem('Description:', _transaction!.description!),
                if (_transaction!.paymentMethod != null)
                  _buildDetailItem('Payment Method:', _transaction!.paymentMethod!),
                _buildDetailItem(
                  'Fraud:',
                  _transaction!.fraud == true ? 'Yes' : 'No',
                  textColor: _transaction!.fraud == true ? Colors.red : Colors.green,
                ),
              ]),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    label: _showAmount ? 'Hide Amount' : 'Show Amount',
                    color: Colors.blue,
                    onPressed: _toggleAmountVisibility,
                  ),
                  _buildActionButton(
                    label: 'Process',
                    color: Colors.orange,
                    onPressed: _processTransaction,
                  ),
                  _buildActionButton(
                    label: 'Check Fraud',
                    color: Colors.red,
                    onPressed: _checkFraud,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.receipt, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction ID: ${_transaction!.transactionId ?? 'N/A'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${_transaction!.date != null ? DateFormat('yyyy-MM-dd').format(_transaction!.date!) : 'No Date'} at ${_transaction!.time ?? 'No Time'}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D3E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: textColor ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 80),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: const Text('Back', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
