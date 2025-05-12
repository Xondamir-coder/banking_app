import 'package:banking_app/widgets/auth/login_form.dart';
import 'package:banking_app/widgets/auth/register_form.dart';
import 'package:banking_app/widgets/components/my_text.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          !_isLogin ? 'Login' : 'Register',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-.5, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: _isLogin ? const RegisterForm() : const LoginForm(),
          ),
          TextButton(
            child: MyText(
              !_isLogin ? 'Not a member? Register' : 'Already a member? Login',
              color: Theme.of(context).colorScheme.primaryFixedDim,
            ),
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
          ),
        ],
      ),
    );
  }
}
