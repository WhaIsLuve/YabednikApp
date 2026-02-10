import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class ApiClient {
  final String baseUrl = AppConstants.apiUrl;

  // Метод для входа: просто проверяем, принимает ли сервер Basic Auth
  Future<String> login(String username, String password) async {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'), // или любой защищённый endpoint
      headers: {
        'Authorization': 'Basic $credentials',
      },
    );

    if (response.statusCode == 200) {
      // Предположим, что сервер возвращает: {"role": "student"}
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final role = data['role'] as String?;
      if (role == null || (role != 'student' && role != 'teacher')) {
        throw Exception('Некорректная роль: $role');
      }
      return role;
    } else if (response.statusCode == 401) {
      throw Exception('Неверный логин или пароль');
    } else {
      throw Exception('Ошибка сервера: ${response.statusCode}');
    }
  }

  // Утилита для создания авторизованного клиента (для других запросов)
  http.Client createAuthorizedClient(String username, String password) {
    return _AuthorizedHttpClient(username, password);
  }
}

// Вспомогательный клиент, который автоматически добавляет Basic Auth
class _AuthorizedHttpClient extends http.BaseClient {
  final String username;
  final String password;
  final _client = http.Client();

  _AuthorizedHttpClient(this.username, this.password);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    request.headers['Authorization'] = 'Basic $credentials';
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}