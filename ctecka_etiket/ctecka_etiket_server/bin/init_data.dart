import 'package:postgres/postgres.dart';

void main() async {
  final conn = await Connection.open(
    Endpoint(
      host: 'localhost',
      port: 5432,
      database: 'ctecka_etiket',
      username: 'postgres',
      password: 'postgres',
    ),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );

  print('Connected to database');

  // Insert admin user
  try {
    await conn.execute('''
      INSERT INTO app_user (username, "passwordHash", email, role, "isActive", "createdAt")
      VALUES (
        'admin',
        '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
        'admin@example.com',
        'admin',
        true,
        NOW()
      )
      ON CONFLICT (username) DO NOTHING
    ''');
    print('✓ Admin user created (username: admin, password: admin123)');
  } catch (e) {
    print('Admin user may already exist: $e');
  }

  // Insert sample coffee
  try {
    final result = await conn.execute('''
      INSERT INTO coffee (name, description, composition, "moreInfo", "videoUrl", "imageUrl", "createdAt", "updatedAt")
      VALUES (
        'Podzimní směs',
        'Lahodná káva s tóny karamelu a oříšků',
        'Arabica 80%, Robusta 20%. Původ: Brazílie, Kolumbie',
        'Naše podzimní směs je pečlivě vybrána z nejkvalitnějších zrn z Latinské Ameriky. Pražení probíhá při středně vysoké teplotě pro dokonalou vyváženost chutí.',
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        'https://picsum.photos/seed/coffee1/400/400',
        NOW(),
        NOW()
      )
      RETURNING id
    ''');
    
    if (result.isNotEmpty) {
      final coffeeId = result.first[0];
      print('✓ Sample coffee created (ID: $coffeeId)');
      
      // Insert QR code mapping
      await conn.execute('''
        INSERT INTO qr_code_mapping ("qrCode", "coffeeId", "isActive", "createdAt")
        VALUES (
          'TEST_QR_001',
          $coffeeId,
          true,
          NOW()
        )
        ON CONFLICT ("qrCode") DO NOTHING
      ''');
      print('✓ QR code created (TEST_QR_001)');
    }
  } catch (e) {
    print('Sample data may already exist: $e');
  }

  await conn.close();
  print('\n✅ Database initialized successfully!');
  print('Login to admin panel with: admin / admin123');
}
