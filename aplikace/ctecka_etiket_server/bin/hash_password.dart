import 'package:bcrypt/bcrypt.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run bin/hash_password.dart <password>');
    return;
  }
  
  final password = args[0];
  final hash = BCrypt.hashpw(password, BCrypt.gensalt());
  
  print('Password: $password');
  print('Bcrypt hash: $hash');
  print('');
  print('SQL příklad:');
  print("INSERT INTO app_user (username, password_hash, email, role, is_active, created_at)");
  print("VALUES ('admin', '$hash', 'admin@example.com', 'admin', true, NOW());");
}
