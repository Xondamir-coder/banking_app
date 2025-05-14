import 'package:banking_app/models/user_model.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MembersScreen extends StatelessWidget {
  final DocumentReference ref;

  const MembersScreen({required this.ref, super.key});
  Future<List<UserModel>> _getUsers() async {
    final query = await FirebaseFirestore.instance.collection('users').get();
    final users =
        query.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          'Invite members',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search for users',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                // TODO: implement search
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                  future: _getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: MyText(snapshot.error.toString()));
                    } else if (snapshot.hasData &&
                        snapshot.data?.isEmpty == true) {
                      return const Center(child: MyText('No users found'));
                    }
                    final users = snapshot.data as List<UserModel>;
                    return ListView.separated(
                      itemCount: users.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          leading: Icon(
                            Icons.person,
                            color:
                                Theme.of(context).colorScheme.secondaryFixedDim,
                          ),
                          title: MyText(user.name),
                          subtitle: MyText(user.email),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.add,
                              color:
                                  Theme.of(context).colorScheme.tertiaryFixed,
                            ),
                            onPressed: () async {
                              await ref.update({
                                'memberIDs': FieldValue.arrayUnion([user.id])
                              });
                              ref
                                  .collection('members')
                                  .doc(user.id)
                                  .set(user.toMap());
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: MyText('${user.name} added'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                          textColor: Theme.of(context).colorScheme.onSecondary,
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
