import 'package:banking_app/models/board_model.dart';
import 'package:banking_app/models/user_model.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:banking_app/widgets/screens/members_screen.dart';
import 'package:banking_app/widgets/transaction/transactions_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BoardScreen extends StatelessWidget {
  final BoardModel board;
  final DocumentReference ref;

  const BoardScreen({required this.board, required this.ref, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          board.name,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 30,
          children: [
            Column(
              spacing: 10,
              children: [
                MyText(
                  'Members:',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                StreamBuilder(
                  stream: ref.collection('members').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No members found.'));
                    }
                    final members = snapshot.data!.docs
                        .map((doc) => UserModel.fromMap(doc.data()))
                        .toList();
                    return Row(
                      spacing: 10,
                      children: [
                        for (final user in members)
                          OutlinedButton.icon(
                            onPressed: () {
                              ref.update({
                                'members': FieldValue.arrayRemove([user.id])
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${user.name} removed'),
                                ),
                              );
                              if (user.id ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                Navigator.of(context).pop();
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            label: MyText(user.name),
                          ),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MembersScreen(
                                  ref: ref,
                                ),
                              ),
                            );
                          },
                          label: MyText('Invite'),
                          icon: Icon(Icons.add),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
            Expanded(child: TransactionsList(ref: ref)),
          ],
        ),
      ),
    );
  }
}
