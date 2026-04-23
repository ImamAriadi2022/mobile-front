import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class ScanBerhasilWidget extends StatefulWidget {
  const ScanBerhasilWidget({super.key});

  @override
  State<ScanBerhasilWidget> createState() => _ScanBerhasilWidgetState();
}

class _ScanBerhasilWidgetState extends State<ScanBerhasilWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final now = TimeOfDay.now();

    return Stack(
      children: [
        // Background parking building gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2C5C8A), Color(0xFF0D1628)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Theme toggle
        Positioned(
          top: 48,
          right: 16,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

        // Main card
        Positioned(
          top: size.height * 0.12,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1A30),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              children: [
                Text(
                  'Diakses pada ${now.format(context)}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),
                // Success check
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x554CAF50),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 54),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Scan Berhasil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tiket Parkir anda telah diaktifkan',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 28),
                // Ticket info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      Text('Kode Tiket:',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                      SizedBox(height: 4),
                      Text(
                        'TXT-20260302-0054',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text('Status:',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                      SizedBox(height: 4),
                      Text(
                        'Aktif',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom buttons
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.booking),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1A30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.borderColor),
                      ),
                    ),
                    child: const Text('Lanjut Booking',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.halamanScan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1A30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.borderColor),
                      ),
                    ),
                    child: const Text('Pindai Ulang',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
