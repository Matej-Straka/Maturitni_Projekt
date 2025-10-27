import 'package:ctecka_etiket_client/ctecka_etiket_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QRScannerPage(), // start on scanner
      routes: {
        '/home': (context) => const MyHomePage(title: 'Serverpod Example'),
      },
    );
  }
}

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

// ...existing code...
  Future<void> _onScanned(String code) async {
    if (_processing) return;
    _processing = true;
    await _cameraController.stop();

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Scanned'),
        content: SelectableText(code), // show exact QR text, selectable
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processing = false;
              _cameraController.start();
            },
            child: const Text('Scan again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processing = false;
              // optional: go to app home without touching server
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: const Text('Go to app'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () => _cameraController.switchCamera(),
          ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _cameraController.toggleTorch(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: _cameraController,
        onDetect: (capture) {
          final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
          // prefer rawValue, fall back to displayValue
          final raw = barcode?.rawValue ?? barcode?.displayValue;
          if (raw != null) _onScanned(raw);
        },
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String? _resultMessage;
  String? _errorMessage;
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _callHello() async {
    try {
      final result = await client.greeting.hello(_textEditingController.text);
      setState(() {
        _errorMessage = null;
        _resultMessage = result.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(hintText: 'Enter your name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _callHello,
                child: const Text('Send to Server'),
              ),
            ),
            ResultDisplay(
              resultMessage: _resultMessage,
              errorMessage: _errorMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class ResultDisplay extends StatelessWidget {
  final String? resultMessage;
  final String? errorMessage;

  const ResultDisplay({super.key, this.resultMessage, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    String text;
    Color backgroundColor;
    if (errorMessage != null) {
      backgroundColor = Colors.red[300]!;
      text = errorMessage!;
    } else if (resultMessage != null) {
      backgroundColor = Colors.green[300]!;
      text = resultMessage!;
    } else {
      backgroundColor = Colors.grey[300]!;
      text = 'No server response yet.';
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 50),
      child: Container(
        color: backgroundColor,
        child: Center(child: Text(text)),
      ),
    );
  }
}



