// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:banking_app/models/category_model.dart';

class TransactionModel {
  final String description;
  final String amount;
  final CategoryModel category;
  final bool isExpense;
  final bool isCash;

  const TransactionModel({
    String? description,
    required this.amount,
    required this.category,
    required this.isExpense,
    required this.isCash,
  }) : description = description ?? '';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'amount': amount,
      'category': category.toMap(),
      'isExpense': isExpense,
      'isCash': isCash,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      description: map['description'] as String,
      amount: map['amount'] as String,
      category: CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
      isExpense: map['isExpense'] as bool,
      isCash: map['isCash'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
