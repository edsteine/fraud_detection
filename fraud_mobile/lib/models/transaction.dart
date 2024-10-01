class Transaction {
  final DateTime? date; // Nullable DateTime if not provided in the response
  final String? dayOfWeek;
  final String? time;
  final String? cardType;
  final String? entryMode;
  final String username;
  final String category;
  final String? merchantGroup;
  final String? countryOfTransaction;
  final String? shippingAddress;
  final String? countryOfResidence;
  final String? bank;
  final int fraud; // Can be int (1/0) or bool, based on API response
  final String? merchantName;
  final String? paymentMethod;

  final String? transactionId;
  final String? transactionType;
  final double? amount;
  final String? description;
  final bool? isFraud;

  Transaction({
    required this.transactionId,
    required this.username,
    required this.category,
    required this.isFraud,
    this.date, // Nullable
    this.dayOfWeek,
    this.time,
    this.cardType,
    this.entryMode,
    required this.amount,
    required this.transactionType,
    this.merchantGroup,
    this.countryOfTransaction,
    this.shippingAddress,
    this.countryOfResidence,
    this.bank,
    required this.fraud,
    this.merchantName,
    this.description,
    this.paymentMethod,
  });

  // Factory constructor to create a Transaction object from a JSON map
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['id'].toString(),
      username: json['username'],
      category: json['category'],
      isFraud: json['is_fraud'] ?? false, // Assuming 'id' maps to transactionId
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null, // Handle null or invalid date
      dayOfWeek: json['dayOfWeek'], // Handle optional field
      time: json['time'], // Handle optional field
      cardType: json['cardType'], // Handle optional field
      entryMode: json['entryMode'], // Handle optional field
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0, // Handle null or invalid amount
      transactionType: json['transaction_type'] ?? '', // Handle null field
      merchantGroup: json['category'], // Assuming 'category' maps to merchantGroup
      countryOfTransaction: json['countryOfTransaction'], // Handle optional field
      shippingAddress: json['shippingAddress'], // Handle optional field
      countryOfResidence: json['countryOfResidence'], // Handle optional field
      bank: json['bank'], // Handle optional field
      fraud: json['is_fraud'] == true ? 1 : 0, // Convert boolean to int
      merchantName: json['merchantName'], // Handle optional field
      description: json['description'], // Handle optional field
      paymentMethod: json['paymentMethod'], // Handle optional field
    );
  }

  // Convert Transaction object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'username': username,
      'category': category,
      'isFraud': isFraud,
      'date': date?.toIso8601String(), // Convert DateTime to String if not null
      'dayOfWeek': dayOfWeek,
      'time': time,
      'cardType': cardType,
      'entryMode': entryMode,
      'amount': amount,
      'transactionType': transactionType,
      'merchantGroup': merchantGroup,
      'countryOfTransaction': countryOfTransaction,
      'shippingAddress': shippingAddress,
      'countryOfResidence': countryOfResidence,
      'bank': bank,
      'fraud': fraud,
      'merchantName': merchantName,
      'description': description,
      'paymentMethod': paymentMethod,
    };
  }
}
