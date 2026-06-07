import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../service/scan_service.dart';

class HalamanScanWidget extends StatefulWidget {
  const HalamanScanWidget({super.key});

  @override
  State<HalamanScanWidget> createState() => _HalamanScanWidgetState();
}

class _HalamanScanWidgetState extends State<HalamanScanWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scanLineAnim;
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _scanLineAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final code = barcodes.first.rawValue!;
      setState(() => _isProcessing = true);
      
      final scanService = ScanService();
      final isValid = await scanService.verifyTicket(code);

      if (mounted) {
        setState(() => _isProcessing = false);
        if (isValid) {
          Navigator.pushNamed(context, AppRoutes.scanBerhasil);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tiket tidak valid atau gagal verifikasi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final now = TimeOfDay.now();

    return Stack(
      children: [
        // Camera area (gray background simulating camera)
        // Camera area
        Container(
          width: double.infinity,
          height: size.height * 0.65,
          color: const Color(0xFF5A5A5A),
          child: Stack(
            children: [
              MobileScanner(
                controller: _cameraController,
                onDetect: _onDetect,
              ),

              // Scan frame overlay
              Center(
                child: SizedBox(
                  width: 220,
                  height: 250,
                  child: AnimatedBuilder(
                    animation: _scanLineAnim,
                    builder: (context, _) {
                      return Stack(
                        children: [
                          // Corner brackets
                          _buildCornerBracket(isTop: true, isLeft: true),
                          _buildCornerBracket(isTop: true, isLeft: false),
                          _buildCornerBracket(isTop: false, isLeft: true),
                          _buildCornerBracket(isTop: false, isLeft: false),
                          // Scan line
                          Positioned(
                            top: _scanLineAnim.value * 230,
                            left: 10,
                            right: 10,
                            child: Container(
                              height: 2,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              if (_isProcessing)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
            ],
          ),
        ),

        // Bottom panel
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: size.height * 0.38,
            decoration: const BoxDecoration(
              color: Color(0xFF0D1628),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Diakses pada ${now.format(context)}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Selamat Datang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Silahkan Scan terlebih dahulu',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.flashlight_on_outlined,
                      label: 'Hidupkan Center',
                      onTap: () {
                        _cameraController.toggleTorch();
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Ambil Foto',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.scanBerhasil);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Theme toggle top right
        Positioned(
          top: 48,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Terang',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                SizedBox(width: 6),
                Icon(Icons.wb_sunny, color: Colors.amber, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCornerBracket({required bool isTop, required bool isLeft}) {
    return Positioned(
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      child: SizedBox(
        width: 32,
        height: 32,
        child: CustomPaint(
          painter: _CornerPainter(isTop: isTop, isLeft: isLeft),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;

  _CornerPainter({required this.isTop, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isTop && isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
