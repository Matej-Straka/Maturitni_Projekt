import 'package:ctecka_etiket_client/ctecka_etiket_client.dart';

void main() async {
  final client = Client('http://localhost:8080/');
  
  try {
    print('Testing login...');
    final user = await client.admin.login('admin', 'admin123');
    print('Login result: $user');
    if (user != null) {
      print('Username: ${user.username}');
      print('Email: ${user.email}');
      print('Role: ${user.role}');
    }
  } catch (e) {
    print('Error: $e');
  }
  
  client.close();
}
