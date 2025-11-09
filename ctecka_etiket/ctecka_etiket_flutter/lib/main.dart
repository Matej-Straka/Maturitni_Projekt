
import 'package:ctecka_etiket_client/ctecka_etiket_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

late final Client client;
late String serverUrl;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  serverUrl = serverUrlFromEnv.isEmpty ? 'http://localhost:8080/' : serverUrlFromEnv;
  client = Client(serverUrl)..connectivityMonitor = FlutterConnectivityMonitor();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Čtečka etiket',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F5F0),
        primaryColor: const Color(0xFF3A8E2F),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (c) => const OnboardingFlow(),
        '/scanner': (c) => const QRScannerPage(),
        '/video': (c) => const VideoPage(),
        '/info': (c) => const InfoMenuPage(),
      },
    );
  }
}

/* ---------------------- Onboarding ---------------------- */
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});
  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pc = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Widget _buildPage(String title, String body, {String imageUrl = ''}) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: imageUrl.isEmpty
                ? Icon(Icons.image, size: 120, color: Colors.grey[400])
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(imageUrl, fit: BoxFit.cover, width: 260, height: 260),
                  ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF6F0),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _page ? const Color(0xFF3A8E2F) : Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                )),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    if (_page < 2) {
                      _pc.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    } else {
                      Navigator.of(context).pushReplacementNamed('/scanner');
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF66BB6A)),
                  child: Text(_page < 2 ? 'POKRAČOVAT' : 'ZAČÍT', style: const TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pc,
        onPageChanged: (i) => setState(() => _page = i),
        children: [
          _buildPage('VÍTĚJTE U PŘEDSTAVENÍ KÁV', 'Tato aplikace slouží jako interaktivní představení našich káv pomocí QR kódů na jejich obalu.', imageUrl: 'https://picsum.photos/seed/coffee1/400/400'),
          _buildPage('1. KROK', 'Najeďte QR kód na obalu jedné z našich káv.', imageUrl: 'https://picsum.photos/seed/coffee2/400/400'),
          _buildPage('2. KROK', 'Přehráje se video a poté vyskočí menu, kde najdete složení a více informací.', imageUrl: 'https://picsum.photos/seed/coffee3/400/400'),
        ],
      ),
    );
  }
}

/* ---------------------- QR Scanner ---------------------- */
class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});
  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _processing = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _onScanned(String code) async {
    if (_processing) return;
    setState(() => _processing = true);
    await _cameraController.stop();
  // code scanned (handled in the modal actions)

    // small dialog that mimics design: play video or open info
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (c) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('QR nalezen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(code, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/video');
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF66BB6A)),
                child: const Text('PUSŤ VIDEO', style: TextStyle(color: Colors.black)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/info');
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7043)),
                child: const Text('VÍCE INFO', style: TextStyle(color: Colors.white)),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cameraController.start();
              setState(() => _processing = false);
            },
            child: const Text('SCAN AGAIN'),
          )
        ]),
      ),
    );
    setState(() => _processing = false);
    _cameraController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        MobileScanner(
          controller: _cameraController,
          fit: BoxFit.cover,
          onDetect: (capture) {
            final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
            final raw = barcode?.rawValue ?? barcode?.displayValue;
            if (raw != null) _onScanned(raw);
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(icon: const Icon(Icons.flash_on, color: Colors.white), onPressed: () => _cameraController.toggleTorch()),
              IconButton(icon: const Icon(Icons.flip_camera_android, color: Colors.white), onPressed: () => _cameraController.switchCamera()),
              const SizedBox(width: 6),
            ]),
          ),
        ),
        // subtle bottom panel like design
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: const Color(0xFFFAF6F0),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            child: Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/onboarding'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF66BB6A)),
                  child: const Text('NÁVOD', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/info'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7043)),
                  child: const Text('MANUÁL', style: TextStyle(color: Colors.white)),
                ),
              ),
            ]),
          ),
        ),
        if (_processing) const Center(child: CircularProgressIndicator(color: Colors.white)),
      ]),
    );
  }
}

/* ---------------------- Video page ---------------------- */
class VideoPage extends StatelessWidget {
  const VideoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video'), backgroundColor: const Color(0xFFF7F5F0), foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Icon(Icons.play_circle_fill, size: 72, color: Colors.black54)),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Prostě se přehrává video...', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/info'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF66BB6A)),
              child: const Text('VÍCE INFORMACÍ', style: TextStyle(color: Colors.black)),
            ),
          ),
        ]),
      ),
    );
  }
}

/* ---------------------- Info menu and pages ---------------------- */
class InfoMenuPage extends StatelessWidget {
  const InfoMenuPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Káva XY'), backgroundColor: const Color(0xFFF7F5F0), foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Image.network('https://picsum.photos/seed/package/300/300', height: 220),
          ),
          const SizedBox(height: 18),
          const Text('Krátké info o kávě...', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InfoDetailPage(title: 'Více informací', body: 'Dlouhé info...'))),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBEE7B6), foregroundColor: Colors.black),
            child: const Text('VÍCE INFORMACÍ'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InfoDetailPage(title: 'Složení', body: 'Složení kávy...'))),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBEE7B6), foregroundColor: Colors.black),
            child: const Text('SLOŽENÍ'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7043)),
            child: const Text('ZAVŘÍT', style: TextStyle(color: Colors.white)),
          ),
        ]),
      ),
    );
  }
}

class InfoDetailPage extends StatelessWidget {
  final String title;
  final String body;
  const InfoDetailPage({super.key, required this.title, required this.body});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFFF7F5F0), foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(height: 260, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Center(child: Image.network('https://picsum.photos/seed/package2/260/260'))),
          const SizedBox(height: 18),
          Text(body, textAlign: TextAlign.center),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7043)),
              child: const Text('ZPĚT', style: TextStyle(color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }
}



