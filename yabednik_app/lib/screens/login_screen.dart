import 'package:flutter/material.dart';
import 'package:yabednik_app/api_client.dart';
import 'package:yabednik_app/constants.dart';
import 'package:yabednik_app/models/user_session.dart';
import 'package:yabednik_app/screens/home_screen.dart';
import 'package:yabednik_app/widgets/app_button.dart';
import 'package:yabednik_app/shared_preferences_helper.dart'; // см. ниже

// Презентер (можно вынести, но пока здесь)
class LoginPresenter {
  final ApiClient _apiClient = ApiClient();

  Future<UserSession> login(String username, String password) async {
    final role = await _apiClient.login(username, password);
    return UserSession(username: username, password: password, role: role);
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final LoginPresenter _presenter = LoginPresenter();

  void _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final session = await _presenter.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      // Сохраняем сессию
      await SharedPreferencesHelper.saveSession(session);

      // Навигация по роли
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(role: session.role),
          ),
        );
      }
    } catch (e) {
      _showError('Неверный логин или пароль');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Логотип
                Image.asset(
                  AppConstants.logoAsset,
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),

                // Поле логина
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите логин';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Поле пароля
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Кнопка входа
                AppButton(
                  text: 'Войти',
                  onPressed: _onLoginPressed,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
