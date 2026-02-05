import 'package:ctecka_etiket_client/ctecka_etiket_client.dart';
import 'package:flutter/material.dart';
import 'admin_theme.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

late final Client client;
const serverUrl = String.fromEnvironment('SERVER_URL', defaultValue: 'http://34.122.70.47:8080/');
const staticServerUrl = String.fromEnvironment('STATIC_SERVER_URL', defaultValue: 'http://34.122.70.47:8090');

// Helper function to get full URL for media files
String getMediaUrl(String url) {
  if (url.startsWith('http')) {
    return url;
  }
  // Files are served from static server on port 8090
  // Remove /uploads/ prefix since static server serves directly from web/uploads folder
  final cleanUrl = url.startsWith('/uploads/') ? url.substring(8) : url;
  return '$staticServerUrl/$cleanUrl';
}

Future<String?> uploadFile(File file, String type, String username, String password) async {
  try {
    final fileName = file.path.split('/').last;
    final fileData = await file.readAsBytes();
    final fileDataBase64 = base64.encode(fileData);
    
    final url = await client.admin.uploadFileBase64(username, password, fileName, fileDataBase64, type);
    return url;
  } catch (e) {
    print('Upload error: $e');
    return null;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const serverUrl = String.fromEnvironment('SERVER_URL', defaultValue: 'http://34.122.70.47:8080/');
  client = Client(serverUrl)..connectivityMonitor = FlutterConnectivityMonitor();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Čtečka Etiket - Admin',
      theme: AdminTheme.lightTheme,
      darkTheme: AdminTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/* ---------------------- Login Page ---------------------- */
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = await client.admin.login(_usernameCtrl.text.trim(), _passwordCtrl.text);
      if (user == null) {
        if (!mounted) return;
        setState(() => _error = 'Nesprávné údaje');
      } else {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => DashboardPage(username: _usernameCtrl.text.trim(), password: _passwordCtrl.text),
        ));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Chyba připojení k serveru');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(40),
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 4))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.coffee, size: 64, color: Color(0xFF8BC34A)),
              const SizedBox(height: 16),
              const Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(
                controller: _usernameCtrl,
                decoration: InputDecoration(
                  labelText: 'Jméno',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.person),
                ),
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordCtrl,
                decoration: InputDecoration(
                  labelText: 'Heslo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
                onSubmitted: (_) => _login(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('PŘIHLÁSIT SE', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------------- Dashboard ---------------------- */
class DashboardPage extends StatefulWidget {
  final String username;
  final String password;
  const DashboardPage({super.key, required this.username, required this.password});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 240,
            decoration: const BoxDecoration(
              color: Color(0xFFE8DFD3),
              border: Border(right: BorderSide(color: Color(0xFFD0C4B3))),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.coffee, size: 48, color: Color(0xFF8BC34A)),
                      const SizedBox(height: 8),
                      const Text('Admin Panel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(widget.username, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFD0C4B3)),
                _buildMenuItem(0, Icons.home, 'Domů'),
                _buildMenuItem(1, Icons.local_cafe, 'Etikety'),
                _buildMenuItem(2, Icons.qr_code, 'QR kódy'),
                _buildMenuItem(3, Icons.people, 'Správa obsahu'),
                const Spacer(),
                const Divider(height: 1, color: Color(0xFFD0C4B3)),
                _buildMenuItem(4, Icons.logout, 'Odhlásit se', isLogout: true),
              ],
            ),
          ),
          // Content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHome(),
                CoffeeListPage(username: widget.username, password: widget.password),
                QRListPage(username: widget.username, password: widget.password),
                VideosPage(username: widget.username, password: widget.password),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String label, {bool isLogout = false}) {
    final isSelected = _selectedIndex == index && !isLogout;
    return InkWell(
      onTap: () {
        if (isLogout) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8BC34A).withOpacity(0.1) : Colors.transparent,
          border: Border(left: BorderSide(width: 4, color: isSelected ? const Color(0xFF8BC34A) : Colors.transparent)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? const Color(0xFF8BC34A) : (isLogout ? const Color(0xFFFF5722) : Colors.black87)),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isLogout ? const Color(0xFFFF5722) : Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard('Etikety', '0', Icons.local_cafe, const Color(0xFF8BC34A)),
                _buildStatCard('QR kódy', '0', Icons.qr_code, const Color(0xFF8BC34A)),
                _buildStatCard('Videa', '0', Icons.video_library, const Color(0xFFFF5722)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 40, color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

/* ---------------------- Coffee List Page ---------------------- */
class CoffeeListPage extends StatefulWidget {
  final String username;
  final String password;
  const CoffeeListPage({super.key, required this.username, required this.password});
  @override
  State<CoffeeListPage> createState() => _CoffeeListPageState();
}

class _CoffeeListPageState extends State<CoffeeListPage> {
  List<Coffee>? _coffees;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCoffees();
  }

  Future<void> _loadCoffees() async {
    setState(() => _loading = true);
    try {
      final coffees = await client.coffee.getAllCoffees();
      if (mounted) {
        setState(() {
          _coffees = coffees;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chyba: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Etikety', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddEditDialog(),
                icon: const Icon(Icons.add),
                label: const Text('PŘIDAT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _coffees == null || _coffees!.isEmpty
                    ? const Center(child: Text('Žádné etikety'))
                    : ListView.builder(
                        itemCount: _coffees!.length,
                        itemBuilder: (context, index) {
                          final coffee = _coffees![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F1EB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: coffee.imageUrl != null
                                    ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(coffee.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)))
                                    : const Icon(Icons.image, color: Colors.grey),
                              ),
                              title: Text(coffee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (coffee.moreInfo != null) Text(coffee.moreInfo!, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  if (coffee.videoUrl != null) Text('Video: ${coffee.videoUrl}', style: const TextStyle(fontSize: 12, color: Colors.blue)),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Color(0xFF8BC34A)),
                                    onPressed: () => _showAddEditDialog(coffee: coffee),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Color(0xFFFF5722)),
                                    onPressed: () => _deleteCoffee(coffee),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEditDialog({Coffee? coffee}) async {
    final nameCtrl = TextEditingController(text: coffee?.name ?? '');
    final descCtrl = TextEditingController(text: coffee?.description ?? '');
    final compCtrl = TextEditingController(text: coffee?.composition ?? '');
    final infoCtrl = TextEditingController(text: coffee?.moreInfo ?? '');
    final videoCtrl = TextEditingController(text: coffee?.videoUrl ?? '');
    final imageCtrl = TextEditingController(text: coffee?.imageUrl ?? '');

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(coffee == null ? 'Přidat etiketu' : 'Upravit etiketu'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Název', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Popis (krátký)', border: OutlineInputBorder()),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: compCtrl,
                  decoration: const InputDecoration(labelText: 'Složení', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: infoCtrl,
                  decoration: const InputDecoration(labelText: 'Více informací', border: OutlineInputBorder()),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: videoCtrl,
                  decoration: InputDecoration(
                    labelText: 'Video URL',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.video_library),
                      onPressed: () async {
                        final selected = await _showMediaGalleryDialog(ctx, 'video');
                        if (selected != null) {
                          videoCtrl.text = selected;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageCtrl,
                  decoration: InputDecoration(
                    labelText: 'Obrázek URL',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.photo_library),
                      onPressed: () async {
                        final selected = await _showMediaGalleryDialog(ctx, 'image');
                        if (selected != null) {
                          imageCtrl.text = selected;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ZRUŠIT'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newCoffee = Coffee(
                id: coffee?.id,
                name: nameCtrl.text,
                description: descCtrl.text,
                composition: compCtrl.text,
                moreInfo: infoCtrl.text,
                videoUrl: videoCtrl.text,
                imageUrl: imageCtrl.text,
              );

              try {
                if (coffee == null) {
                  await client.coffee.createCoffee(newCoffee);
                } else {
                  await client.coffee.updateCoffee(newCoffee);
                }
                if (ctx.mounted) Navigator.pop(ctx);
                _loadCoffees();
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Chyba: $e'), backgroundColor: Colors.red));
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8BC34A), foregroundColor: Colors.white),
            child: Text(coffee == null ? 'PŘIDAT' : 'ULOŽIT'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCoffee(Coffee coffee) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Smazat etiketu?'),
        content: Text('Opravdu chcete smazat "${coffee.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('ZRUŠIT')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5722), foregroundColor: Colors.white),
            child: const Text('SMAZAT'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await client.coffee.deleteCoffee(coffee.id!);
        _loadCoffees();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chyba: $e'), backgroundColor: Colors.red));
        }
      }
    }
  }

  Future<String?> _showMediaGalleryDialog(BuildContext context, String type) async {
    // Load media
    List<MediaFile>? media;
    try {
      final allMedia = await client.admin.getAllMedia(widget.username, widget.password);
      media = allMedia.where((m) => m.fileType == type).toList();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chyba při načítání: $e'), backgroundColor: Colors.red),
        );
      }
      return null;
    }

    if (media.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Žádná ${type == 'video' ? 'videa' : 'obrázky'}. Nahrajte je na stránce Správa obsahu.'),
            backgroundColor: const Color(0xFFFF5722),
          ),
        );
      }
      return null;
    }

    return showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          width: 800,
          height: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vyberte ${type == 'video' ? 'video' : 'obrázek'}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: media!.length,
                  itemBuilder: (context, index) {
                    final m = media![index];
                    return InkWell(
                      onTap: () => Navigator.pop(ctx, m.url),
                      child: Card(
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                                child: type == 'video'
                                    ? const Center(
                                        child: Icon(Icons.play_circle_outline, size: 48, color: Colors.grey),
                                      )
                                    : Image.network(
                                        getMediaUrl(m.url),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 48, color: Colors.grey),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                m.fileName,
                                style: const TextStyle(fontSize: 11),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('ZRUŠIT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------------- QR List Page ---------------------- */
class QRListPage extends StatefulWidget {
  final String username;
  final String password;
  const QRListPage({super.key, required this.username, required this.password});
  @override
  State<QRListPage> createState() => _QRListPageState();
}

class _QRListPageState extends State<QRListPage> {
  List<QRCodeMapping>? _qrCodes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQRCodes();
  }

  Future<void> _loadQRCodes() async {
    setState(() => _loading = true);
    try {
      final qrCodes = await client.coffee.getAllQRCodes();
      if (mounted) {
        setState(() {
          _qrCodes = qrCodes;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chyba: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('QR kódy', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddDialog(),
                icon: const Icon(Icons.add),
                label: const Text('PŘIDAT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _qrCodes == null || _qrCodes!.isEmpty
                    ? const Center(child: Text('Žádné QR kódy'))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _qrCodes!.length,
                        itemBuilder: (context, index) {
                          final qr = _qrCodes![index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: QrImageView(
                                    data: qr.qrCode,
                                    version: QrVersions.auto,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(qr.qrCode, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                const SizedBox(height: 4),
                                Text('Coffee ID: ${qr.coffeeId}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => _showQRDialog(qr.qrCode),
                                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8BC34A), foregroundColor: Colors.white),
                                        child: const Text('ZOBRAZIT'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Color(0xFFFF5722)),
                                      onPressed: () => _deleteQR(qr),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog() async {
    final qrCtrl = TextEditingController();
    Coffee? selectedCoffee;
    List<Coffee> coffees = [];

    // Load coffees
    try {
      coffees = await client.coffee.getAllCoffees();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chyba při načítání káv: $e'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    if (coffees.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nejdříve vytvořte kávy'), backgroundColor: Color(0xFFFF5722)),
        );
      }
      return;
    }

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Přidat QR kód'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: qrCtrl,
                decoration: const InputDecoration(labelText: 'QR kód', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Coffee>(
                value: selectedCoffee,
                decoration: const InputDecoration(
                  labelText: 'Káva',
                  border: OutlineInputBorder(),
                ),
                items: coffees.map((coffee) {
                  return DropdownMenuItem(
                    value: coffee,
                    child: Text(coffee.name),
                  );
                }).toList(),
                onChanged: (Coffee? value) {
                  setState(() {
                    selectedCoffee = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ZRUŠIT'),
            ),
            ElevatedButton(
              onPressed: selectedCoffee == null ? null : () async {
                final qrCode = QRCodeMapping(
                  id: null,
                  qrCode: qrCtrl.text,
                  coffeeId: selectedCoffee!.id!,
                  isActive: true,
                );

                try {
                  await client.coffee.createQRCode(qrCode);
                  if (ctx.mounted) Navigator.pop(ctx);
                  _loadQRCodes();
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Chyba: $e'), backgroundColor: Colors.red));
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8BC34A), foregroundColor: Colors.white),
              child: const Text('PŘIDAT'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showQRDialog(String qrCode) async {
    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('QR kód', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: QrImageView(
                  data: qrCode,
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(qrCode, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8BC34A), foregroundColor: Colors.white),
                child: const Text('ZAVŘÍT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteQR(QRCodeMapping qr) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Smazat QR kód?'),
        content: Text('Opravdu chcete smazat "${qr.qrCode}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('ZRUŠIT')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5722), foregroundColor: Colors.white),
            child: const Text('SMAZAT'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await client.coffee.deleteQRCode(qr.id!);
        _loadQRCodes();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chyba: $e'), backgroundColor: Colors.red));
        }
      }
    }
  }
}

/* ---------------------- Videos Page ---------------------- */
class VideosPage extends StatefulWidget {
  final String username;
  final String password;
  const VideosPage({super.key, required this.username, required this.password});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  List<MediaFile>? _media;
  bool _loading = true;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    setState(() => _loading = true);
    try {
      final media = await client.admin.getAllMedia(widget.username, widget.password);
      if (mounted) {
        setState(() {
          _media = media;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chyba: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
    );

    if (result != null && result.files.first.path != null) {
      setState(() => _uploading = true);
      
      final file = File(result.files.first.path!);
      final fileName = result.files.first.name;
      final extension = fileName.split('.').last.toLowerCase();
      
      String mimeType;
      if (['jpg', 'jpeg', 'png'].contains(extension)) {
        mimeType = 'image/$extension';
      } else {
        mimeType = 'video/$extension';
      }

      final url = await uploadFile(file, mimeType, widget.username, widget.password);
      
      setState(() => _uploading = false);

      if (url != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Soubor nahrán!'), backgroundColor: Color(0xFF8BC34A)),
          );
          _loadMedia();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chyba při nahrávání'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _deleteMedia(int mediaId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Smazat soubor?'),
        content: const Text('Tuto akci nelze vrátit zpět.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('ZRUŠIT')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('SMAZAT'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await client.admin.deleteMedia(widget.username, widget.password, mediaId);
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Soubor smazán'), backgroundColor: Color(0xFF8BC34A)),
            );
            _loadMedia();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chyba při mazání'), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chyba: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Správa obsahu', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (_uploading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _uploadFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('NAHRÁT SOUBOR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_media == null || _media!.isEmpty)
            const Center(child: Text('Žádné soubory', style: TextStyle(fontSize: 18, color: Colors.grey)))
          else
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _media!.length,
                itemBuilder: (context, index) {
                  final media = _media![index];
                  final isVideo = media.fileType == 'video';
                  
                  return Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                            child: isVideo
                                ? const Center(
                                    child: Icon(Icons.play_circle_outline, size: 64, color: Colors.grey),
                                  )
                                : Image.network(
                                    getMediaUrl(media.url),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 64, color: Colors.grey),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                media.fileName,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(media.fileSize / 1024 / 1024).toStringAsFixed(1)} MB',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () {
                                        // Copy URL to clipboard
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('URL: ${media.url}'), duration: const Duration(seconds: 2)),
                                        );
                                      },
                                      icon: const Icon(Icons.copy, size: 16),
                                      label: const Text('URL', style: TextStyle(fontSize: 11)),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _deleteMedia(media.id!),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

