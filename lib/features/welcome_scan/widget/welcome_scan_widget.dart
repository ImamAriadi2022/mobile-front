import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScanWidget extends StatefulWidget {
  const WelcomeScanWidget({super.key});

  @override
  State<WelcomeScanWidget> createState() => _WelcomeScanWidgetState();
}

class _WelcomeScanWidgetState extends State<WelcomeScanWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rotAnim;
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 8))
      ..repeat();
    _rotAnim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Theme toggle
        Positioned(
          top: 8,
          right: 16,
          child: GestureDetector(
            onTap: () => setState(() => _isDark = !_isDark),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isDark ? 'Terang' : 'Gelap',
                    style:
                        const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _isDark ? Icons.wb_sunny : Icons.nightlight_round,
                    color: Colors.amber,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Center QR icon with orbiting elements
        Positioned.fill(
          top: 60,
          bottom: 200,
          child: AnimatedBuilder(
            animation: _rotAnim,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // QR scanner icon in center
                  _buildQrIcon(),
                  // Orbiting emojis/icons
                  ..._buildOrbitingItems(_rotAnim.value),
                ],
              );
            },
          ),
        ),

        // Bottom content
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
            child: Column(
              children: [
                const Text(
                  'ParkFinder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aplikasi Pencari Slot Parkir',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.animasiScan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Mulai',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(Icons.qr_code_scanner_rounded,
          color: AppColors.accent, size: 60),
    );
  }

  List<Widget> _buildOrbitingItems(double progress) {
    final items = [
      Icons.directions_car,
      Icons.local_parking,
      Icons.location_on,
      Icons.access_time,
      Icons.business,
      Icons.school,
      Icons.local_mall,
      Icons.celebration,
    ];
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.amber,
      Colors.orange,
      Colors.teal,
      Colors.purple,
      Colors.red,
      Colors.cyan,
    ];

    final radius = 130.0;
    return List.generate(items.length, (i) {
      final angle = (2 * 3.14159 * i / items.length) + (progress * 2 * 3.14159);
      final x = radius * (0.5 + 0.5 * (angle / (2 * 3.14159) * 2 - 1).clamp(-1, 1));
      final dx = radius * 0 + radius * (0.95 * (i % 2 == 0 ? 1 : -1));
      // Use real orbit math
      final ox = radius * (i % 2 == 0 ? 1 : -1) *
          (0.5 +
              0.5 *
                  (progress * 2 * 3.14159 * (i + 1)).abs() %
                  1);
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Align(
          alignment: Alignment(
            (0.8 * (i % 3 - 1)).clamp(-0.9, 0.9),
            (0.8 * (i ~/ 3 - 0.5) * (i % 2 == 0 ? 1 : -1)).clamp(-0.9, 0.9),
          ),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors[i].withOpacity(0.85),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(items[i], color: Colors.white, size: 22),
          ),
        ),
      );
    });
  }
}
