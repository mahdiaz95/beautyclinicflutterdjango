// models/wallet_and_transactions.dart

class WalletAndTransactions {
  final String balance;
  final List<TransactionModel> transactions;

  WalletAndTransactions({required this.balance, required this.transactions});

  factory WalletAndTransactions.fromJson(Map<String, dynamic> json) {
    return WalletAndTransactions(
      balance: json['balance'],
      transactions: (json['transactions'] as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList(),
    );
  }
}

class TransactionModel {
  final int id;
  final String transactionType;
  final String transactionTypeDisplay;
  final String amount;
  final String? description;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.transactionType,
    required this.transactionTypeDisplay,
    required this.amount,
    this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      transactionType: json['transaction_type'],
      transactionTypeDisplay: json['transaction_type_display'],
      amount: json['amount'].toString(),
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
