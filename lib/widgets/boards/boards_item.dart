import 'package:banking_app/models/user_model.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:banking_app/widgets/screens/board_screen.dart';
import 'package:banking_app/widgets/transaction/transactions_list.dart';
import 'package:banking_app/widgets/sheets/board_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:banking_app/models/board_model.dart';
import 'package:icons_flutter/icons_flutter.dart';

class BoardsItem extends StatelessWidget {
  final DocumentReference ref;
  final BoardModel board;

  const BoardsItem({
    super.key,
    required this.ref,
    required this.board,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BoardScreen(
                board: board,
                ref: ref,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyText(
                        board.name,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesome.edit,
                        color: Theme.of(context).colorScheme.tertiaryFixed,
                      ),
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => BoardSheet(
                            board: board,
                            reference: ref,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesome.remove,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        ref.delete();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                MyText(
                  board.description,
                  fontSize: 16,
                ),

                const SizedBox(height: 16),

                // Members list (names only)
                StreamBuilder(
                  stream: ref.collection('members').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const MyText('No members');
                    }
                    final members = snapshot.data!.docs
                        .map((doc) => UserModel.fromMap(doc.data()))
                        .toList();
                    return Wrap(
                      spacing: 8,
                      children: [
                        for (final member in members)
                          Chip(label: MyText(member.name)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
