import 'package:banking_app/widgets/components/my_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:banking_app/models/board_model.dart';
import 'package:icons_flutter/icons_flutter.dart';

class BoardsItem extends StatelessWidget {
  final BoardModel board;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BoardsItem({
    super.key,
    required this.board,
    this.onEdit,
    this.onDelete,
  });

  /// Fetches each member's name from `/users` by their IDs
  Future<List<String>> _fetchMemberNames() async {
    if (board.members.isEmpty) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: board.members)
        .get();

    return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {},
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
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesome.remove,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: onDelete,
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
                FutureBuilder<List<String>>(
                  future: _fetchMemberNames(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const MyText('No members');
                    }
                    return Wrap(
                      spacing: 8,
                      children: snapshot.data!
                          .map((name) => Chip(label: MyText(name)))
                          .toList(),
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
