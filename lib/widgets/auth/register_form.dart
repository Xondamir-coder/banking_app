import 'package:banking_app/widgets/components/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _name = '';
  var _email = '';
  var _password = '';
  var _obscurePass = true;

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(
        {
          'id': userCredential.user!.uid,
          'email': _email,
          'name': _name,
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: MyText(
                  'Name',
                  color: Theme.of(context).colorScheme.secondaryFixedDim,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: MyText(
                  'Email',
                  color: Theme.of(context).colorScheme.secondaryFixedDim,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscurePass,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePass = !_obscurePass;
                    });
                  },
                  icon: Icon(
                    _obscurePass ? Icons.visibility_off : Icons.remove_red_eye,
                  ),
                ),
                suffixIconColor: Theme.of(context).colorScheme.secondaryFixed,
                label: MyText(
                  'Password',
                  color: Theme.of(context).colorScheme.secondaryFixedDim,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: MyText('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
