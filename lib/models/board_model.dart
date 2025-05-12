// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:banking_app/models/transaction_model.dart';

class BoardModel {
  final String name;
  final String description;
  final List<String> members;
  final List<TransactionModel> transactions;

  const BoardModel({
    required this.name,
    required this.description,
    required this.members,
    required this.transactions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'members': members,
      'transactions': transactions.map((x) => x.toMap()).toList(),
    };
  }

  factory BoardModel.fromMap(Map<String, dynamic> map) {
    return BoardModel(
      name: map['name'] as String,
      description: map['description'] as String,
      members: map['members'] != null
          ? List<String>.from(map['members'] as List)
          : [],
      transactions: map['transactions'] != null
          ? List<TransactionModel>.from(
              (map['transactions'] as List).map<TransactionModel>(
                (x) => TransactionModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory BoardModel.fromJson(String source) =>
      BoardModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
