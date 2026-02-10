// lib/main.dart
import 'package:flutter/material.dart';
import 'package:yabednik_app/models/user_session.dart';
import 'package:yabednik_app/screens/login_screen.dart';
import 'package:yabednik_app/screens/home_screen.dart';
import 'package:yabednik_app/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ябедник',
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Placeholder(), // будем передавать роль через параметры
      },
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<UserSession?> _initSession;

  @override
  void initState() {
    super.initState();
    _initSession = SharedPreferencesHelper.getSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSession?>(
      future: _initSession,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final session = snapshot.data;
          if (session != null) {
            return HomeScreen(role: session.role);
          }
        }
        return const LoginScreen();
      },
    );
  }
}