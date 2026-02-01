import 'package:ctecka_etiket_client/ctecka_etiket_client.dart';

void main() async {
  print('Connecting...');
  final client = Client('http://localhost:8080/');
  
  try {
    print('Login...');
    final user = await client.admin.login('admin', 'admin123');
    print('Result: $user');
  } catch (e) {
    print('Error: $e');
  }
  
  client.close();
}
