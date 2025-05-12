import 'package:banking_app/models/board_model.dart';
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

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    try {
      if (widget.board == null && widget.reference == null) {
        await FirebaseFirestore.instance.collection('boards').doc().set({
          'name': _name,
          'description': _description,
          'members': [FirebaseAuth.instance.currentUser!.uid],
          'transactions': [],
        });
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
    print(widget.board);
    if (widget.board != null) {
      _name = widget.board!.name;
      _description = widget.board!.description;
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
              child: MyText('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
