import 'package:banking_app/models/board_model.dart';
import 'package:banking_app/models/user_model.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BoardSheet extends StatefulWidget {
  final BoardModel? board;
  final DocumentReference? reference;

  const BoardSheet({super.key, this.board, this.reference});

  @override
  State<BoardSheet> createState() => _BoardSheetState();
}

class _BoardSheetState extends State<BoardSheet> {
  final _formKey = GlobalKey<FormState>();
  var _name = '';
  var _description = '';
  var _isUpdating = false;

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    try {
      if (widget.board == null && widget.reference == null) {
        final ref = FirebaseFirestore.instance.collection('boards').doc();

        // Board Data
        await ref.set({
          'name': _name,
          'description': _description,
          'memberIDs': [FirebaseAuth.instance.currentUser!.uid],
        });

        // Members collection info
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        await ref
            .collection('members')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(userData.data()!);
      } else {
        await widget.reference!.update({
          'name': _name,
          'description': _description,
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Board added successfully!'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.board != null) {
      _name = widget.board!.name;
      _description = widget.board!.description;
      _isUpdating = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        color: Theme.of(context).colorScheme.onSecondaryFixed,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              initialValue: _name,
              onSaved: (newValue) => _name = newValue!,
              validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
              decoration: InputDecoration(
                label: MyText('Name'),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              initialValue: _description,
              onSaved: (newValue) => _description = newValue!,
              validator: (val) =>
                  val!.isEmpty ? 'Please enter a description' : null,
              decoration: InputDecoration(
                label: MyText('Description'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: MyText(_isUpdating ? 'Update Board' : 'Add Board'),
            ),
          ],
        ),
      ),
    );
  }
}
