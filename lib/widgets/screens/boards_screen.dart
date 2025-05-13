import 'package:banking_app/models/board_model.dart';
import 'package:banking_app/widgets/boards/boards_item.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:banking_app/widgets/sheets/board_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BoardsScreen extends StatelessWidget {
  const BoardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText('Boards', fontSize: 24, fontWeight: FontWeight.bold),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const BoardSheet(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
        leading: IconButton(
          onPressed: () => FirebaseAuth.instance.signOut(),
          icon: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('boards')
              .where(
                'members',
                arrayContains: FirebaseAuth.instance.currentUser!.uid,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return MyText('Error: ${snapshot.error}');
            }

            final boards = snapshot.data?.docs
                    .map((e) => BoardModel.fromMap(e.data()))
                    .toList() ??
                [];

            if (snapshot.hasData && boards.isEmpty) {
              return const MyText('No boards present');
            }

            return ListView.builder(
              itemCount: boards.length,
              itemBuilder: (context, index) => BoardsItem(
                board: boards[index],
                ref: snapshot.data!.docs[index].reference,
              ),
            );
          },
        ),
      ),
    );
  }
}
