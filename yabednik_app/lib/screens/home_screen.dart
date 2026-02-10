import 'package:flutter/material.dart';
import 'package:yabednik_app/models/user_session.dart';
import 'package:yabednik_app/shared_preferences_helper.dart';

class HomeScreen extends StatelessWidget {
  final String role;

  const HomeScreen({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String roleLabel = role == 'student' ? 'студент' : 'преподаватель';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Страница в разработке',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Вы вошли как: $roleLabel',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                // Выход из системы
                await SharedPreferencesHelper.clearSession();
                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}