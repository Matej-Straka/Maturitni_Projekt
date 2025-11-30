import 'package:ctecka_etiket_client/ctecka_etiket_client.dart';

void main() async {
  print('Connecting to server...');
  final client = Client('http://localhost:8080/');
  
  try {
    print('Calling login...');
    final user = await client.admin.login('admin', 'admin123');
    
    if (user != null) {
      print('✓ Login successful!');
      print('  Username: ${user.username}');
      print('  Email: ${user.email}');
      print('  Role: ${user.role}');
    } else {
      print('✗ Login failed - wrong credentials');
    }
  } catch (e, stack) {
    print('✗ Error: $e');
    print('Stack: $stack');
  } finally {
    await client.close();
  }
}
