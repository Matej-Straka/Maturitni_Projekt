import 'package:ctecka_etiket_client/ctecka_etiket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import 'theme/app_theme.dart';

late Client client;
const String serverUrl = 'https://ctecka-etiket.duckdns.org/';
const String staticServerUrl = 'https://ctecka-etiket.duckdns.org/';

// Helper function to get full URL for media files
String getMediaUrl(String url) {
  if (url.startsWith('http')) {
    return url;
  }
  final cleanUrl = url;
  final base = staticServerUrl.endsWith('/')
      ? staticServerUrl.substring(0, staticServerUrl.length - 1)
      : staticServerUrl;
  final path = cleanUrl.startsWith('/') ? cleanUrl.substring(1) : cleanUrl;
  final baseUri = Uri.parse('$base/');
  final uri = baseUri.resolveUri(Uri(path: path));
  return uri.toString();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Čtečka etiket',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const OnboardingFlow(),
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

  static const List<String> _onboardingImages = [
    'web/icons/Icon-192.png',
    'web/icons/Icon-maskable-192.png',
    'web/icons/Icon-512.png',
  ];

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Widget _buildPage(String title, String body, String imagePath) {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
      child: Column(
        children: [
          const Spacer(flex: 2),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: Container(
              key: ValueKey(imagePath),
              width: 220,
              height: 220,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  body,
                  style: const TextStyle(
                    fontFamily: 'Faustina',
                    fontSize: 16,
                    color: Color(0xFF797979),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                3,
                (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? const Color(0xFF4CAF50)
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    )),
          ),

          const Spacer(flex: 1),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                if (_page < 2) {
                  _pc.nextPage( 
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                } else {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const QRScannerPage()));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.black,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 1,
              ),
              child: Text(_page < 2 ? 'POKRAČOVAT' : 'POJĎME NA TO',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Snug Variable',
                      letterSpacing: 0.5)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.surface,

      body: SafeArea(
        child: PageView(
          controller: _pc,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (i) => setState(() => _page = i),
          children: [
            _buildPage(
              'VÍTEJTE U PŘEDSTAVENÍ KÁV',
              'Tato aplikace slouží jako interaktivní představení naších káv pomocí QR kódů na jejich obalu',
              _onboardingImages[0],
            ),
            _buildPage(
              '1. KROK',
              'Načtete QR kód na obalu jedné z naších káv',
              _onboardingImages[1],
            ),
            _buildPage(
              '2. KROK',
              'Přehraje se video a poté vyskočí menu kde můžete najít složení a více informací o kávě',
              _onboardingImages[2],
            ),
          ],
        ),
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

class _QRScannerPageState extends State<QRScannerPage>
    with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isProcessing = false;
  bool _cameraActive = true;
  bool _scannerVisible = true;

  void _deactivateScanner() {
    controller?.pauseCamera();
    controller?.dispose();
    controller = null;
    if (mounted) {
      setState(() {
        _cameraActive = false;
        _scannerVisible = false;
      });
    } else {
      _cameraActive = false;
      _scannerVisible = false;
    }
  }

  void _activateScanner() {
    if (!mounted) return;
    setState(() {
      _scannerVisible = true;
      _cameraActive = false;
      _isProcessing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null) return;

    if (state == AppLifecycleState.inactive) {
      controller?.pauseCamera();
      _cameraActive = false;
    } else if (state == AppLifecycleState.resumed) {
      if (_scannerVisible && !_cameraActive && !_isProcessing) {
        controller?.resumeCamera();
        _cameraActive = true;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (_isProcessing) return;
      if (scanData.code == null) return;

      setState(() => _isProcessing = true);
      _deactivateScanner();

      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (_) => LoadingCoffeePage(qrCode: scanData.code!),
        ),
      )
          .then((_) {
        if (!mounted) return;
        _activateScanner();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Stack(
        children: [
          if (_scannerVisible)
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppTheme.primary,
                borderRadius: 20,
                borderLength: 40,
                borderWidth: 8,
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
                overlayColor: Colors.black.withAlpha(420),
              ),
            )
          else
            Container(color: AppTheme.surface),
          // Info text nahoře
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.transparent],
                  ),
                ),
                child: const Text(
                  'Namiřte fotoaparát na QR kód',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Snug Variable",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
              child: SafeArea(
  
                top: false,
                child: ElevatedButton(
                        onPressed: () async {
                          // Zobraz dialog pro manuální zadání QR kódu
                          final qrInputController = TextEditingController();
                          final result = await showDialog<String>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Zadat QR kód'),
                              content: TextField(
                                controller: qrInputController,
                                decoration: const InputDecoration(
                                  labelText: 'QR kód',
                                  hintText: 'Zadejte QR kód kávy',
                                ),
                                autofocus: true,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Zrušit'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, qrInputController.text),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );

                          if (result != null && result.isNotEmpty) {
                            setState(() => _isProcessing = true);
                            try {
                              final coffee =
                                  await client.coffee.getCoffeeByQR(result);
                              if (coffee == null) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('QR kód nenalezen'),
                                      backgroundColor: Colors.red),
                                );
                              } else {
                                if (!mounted) return;
                                _deactivateScanner();
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => VideoPage(coffee: coffee),
                                  ),
                                );
                                if (!mounted) return;
                                _activateScanner();
                              }
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Chyba: $e'),
                                    backgroundColor: Colors.red),
                              );
                            } finally {
                              if (mounted) {
                                setState(() => _isProcessing = false);
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.closebutton,
                          foregroundColor:  const Color(0xFF000000),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: const Text('Zadat kávu ručně',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Snug Variable",
                                letterSpacing: 0.5)),
                      ),
                    ),
                ),
              ),
        ],
      ),
    );
  }
}

/* ---------------------- Loading Coffee Page ---------------------- */
class LoadingCoffeePage extends StatefulWidget {
  final String qrCode;
  const LoadingCoffeePage({super.key, required this.qrCode});

  @override
  State<LoadingCoffeePage> createState() => _LoadingCoffeePageState();
}

class _LoadingCoffeePageState extends State<LoadingCoffeePage> {
  @override
  void initState() {
    super.initState();
    _loadCoffee();
  }

  Future<void> _loadCoffee() async {
    try {
      final coffee = await client.coffee.getCoffeeByQR(widget.qrCode);
      if (!mounted) return;

      if (coffee == null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('QR kód nenalezen'), backgroundColor: Colors.red),
        );
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => VideoPage(coffee: coffee)),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chyba: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primary),
            SizedBox(height: 24),
            Text(
              'Načítání...',
              style: TextStyle(
                  color: AppTheme.black,
                  fontSize: 18,
                  fontFamily: "Snug Variable",
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------------- Video Page ---------------------- */
class VideoPage extends StatefulWidget {
  final Coffee coffee;
  const VideoPage({super.key, required this.coffee});
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _error;
  bool _hasNavigatedToInfo = false;

  void _openInfoMenu() {
    if (!mounted || _hasNavigatedToInfo) return;
    _hasNavigatedToInfo = true;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InfoMenuPage(coffee: widget.coffee),
      ),
    );
  }

  void _onVideoProgress() {
    if (_hasNavigatedToInfo || !_videoController.value.isInitialized) return;

    final duration = _videoController.value.duration;
    final position = _videoController.value.position;
    if (duration.inMilliseconds <= 0) return;

    if (position >= duration - const Duration(milliseconds: 300)) {
      _openInfoMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final videoUrl = getMediaUrl(widget.coffee.videoUrl);
      print('🎥 DEBUG: Loading video from: $videoUrl');
      print('🎥 DEBUG: Original URL from DB: ${widget.coffee.videoUrl}');

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await _videoController.initialize();
      _videoController.addListener(_onVideoProgress);
      if (!mounted) return;

      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: false,
          aspectRatio: _videoController.value.aspectRatio,
          allowFullScreen: false,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: AppTheme.primary,
            handleColor: AppTheme.primary,
            backgroundColor: AppTheme.surface,
            bufferedColor: Colors.grey.shade400,
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void deactivate() {
    // Pause video when navigating away
    _videoController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _videoController.removeListener(_onVideoProgress);
    _videoController.pause();
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _error != null
              ? Center(
                  child: Text('Chyba: $_error',
                      style: const TextStyle(color: Colors.white)))
              : Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: _chewieController != null
                            ? Chewie(controller: _chewieController!)
                            : const SizedBox(),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _openInfoMenu();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.secondbutton,
                                  foregroundColor: AppTheme.black,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 2,
                                ),
                                child: const Text('POKRAČOVAT',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Snug Variable",
                                        letterSpacing: 0.5)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

/* ---------------------- Info Menu ---------------------- */
class InfoMenuPage extends StatelessWidget {
  final Coffee coffee;
  const InfoMenuPage({super.key, required this.coffee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: coffee.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(getMediaUrl(coffee.imageUrl),
                                  fit: BoxFit.cover),
                            )
                          : Icon(Icons.coffee,
                              size: 80, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      coffee.name,
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      coffee.description,
                      style: const TextStyle(
                          fontSize: 16, fontFamily: "Faustina", fontWeight: FontWeight.normal ,color: AppTheme.black, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => InfoDetailPage(
                            coffee: coffee,
                            title: 'VÍCE INFORMACÍ',
                            content: coffee.moreInfo,
                          ),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.firstbutton,
                        foregroundColor: AppTheme.black,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: const Text('VÍCE INFORMACÍ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Snug Variable",
                              letterSpacing: 0.5)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => InfoDetailPage(
                            coffee: coffee,
                            title: 'SLOŽENÍ',
                            content: coffee.composition,
                          ),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondbutton,
                        foregroundColor: AppTheme.black,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: const Text('SLOŽENÍ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Snug Variable",
                              letterSpacing: 0.5)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.closebutton,
                        padding: EdgeInsets.zero,
                        foregroundColor: AppTheme.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: const Text('ZAVŘÍT',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Snug Variable",
                              letterSpacing: 0.5)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------------- Info Detail ---------------------- */
class InfoDetailPage extends StatelessWidget {
  final Coffee coffee;
  final String title;
  final String content;

  const InfoDetailPage({
    super.key,
    required this.coffee,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      color: AppTheme.surface,
                      child: Column(
                        children: [
                          Container(
                            width: 160,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ],
                            ),
                            child: coffee.imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                        getMediaUrl(coffee.imageUrl),
                                        fit: BoxFit.cover),
                                  )
                                : Icon(Icons.coffee,
                                    size: 60, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            content,
                            style: const TextStyle(fontSize: 16, fontFamily: "Faustina", fontWeight: FontWeight.normal ,color: AppTheme.black, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              color: AppTheme.surface,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.closebutton,
                      foregroundColor: AppTheme.black,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                    ),
                    child: const Text('ZPĚT',
                        style: 
                          TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Snug Variable",
                              letterSpacing: 0.5)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

