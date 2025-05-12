import 'package:banking_app/widgets/screens/auth_screen.dart';
import 'package:banking_app/widgets/screens/boards_screen.dart';
import 'package:banking_app/widgets/screens/transactions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 223, 208, 184),
);

final kThemeData = ThemeData.dark().copyWith(
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromRGBO(223, 208, 184, 1),
  ),
  scaffoldBackgroundColor: Color.fromRGBO(34, 40, 49, 1),
  colorScheme: kColorScheme,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banking App',
      theme: kThemeData,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const BoardsScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
