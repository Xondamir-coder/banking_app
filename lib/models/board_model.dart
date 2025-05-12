// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:banking_app/models/transaction_model.dart';
import 'package:banking_app/models/user_model.dart';

class BoardModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final List<UserModel> members;
  final List<TransactionModel> transactions;

  const BoardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.members,
    required this.transactions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'members': members.map((x) => x.toMap()).toList(),
      'transactions': transactions.map((x) => x.toMap()).toList(),
    };
  }

  factory BoardModel.fromMap(Map<String, dynamic> map) {
    return BoardModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      members: List<UserModel>.from(
        (map['members'] as List<int>).map<UserModel>(
          (x) => UserModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      transactions: List<TransactionModel>.from(
        (map['transactions'] as List<int>).map<TransactionModel>(
          (x) => TransactionModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BoardModel.fromJson(String source) =>
      BoardModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
