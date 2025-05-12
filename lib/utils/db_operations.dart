import 'package:banking_app/models/board_model.dart';
import 'package:banking_app/models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbOperations {
  static Future<void> addTransaction(
      BoardModel board, TransactionModel transaction) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(board.id)
        .collection('transactions')
        .doc(transaction.id)
        .set(transaction.toMap());
  }

  static Future<void> updateTransaction(
      BoardModel board, TransactionModel transaction) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(board.id)
        .collection('transactions')
        .doc(transaction.id)
        .update(transaction.toMap());
  }

  static Future<void> deleteTransaction(
      BoardModel board, TransactionModel transaction) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(board.id)
        .collection('transactions')
        .doc(transaction.id)
        .delete();
  }
}
