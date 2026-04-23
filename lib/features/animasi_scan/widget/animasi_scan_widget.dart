import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class AnimasiScanWidget extends StatefulWidget {
  const AnimasiScanWidget({super.key});

  @override
  State<AnimasiScanWidget> createState() => _AnimasiScanWidgetState();
}

class _AnimasiScanWidgetState extends State<AnimasiScanWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scanAnim;
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Langkah 1',
      'desc':
          'Gunakan kolom pencarian untuk menemukan gedung parkir, dan klik gedung parkir teratas untuk melihat area parkir secara detail',
      'icon': Icons.search,
    },
    {
      'title': 'Langkah 2',
      'desc':
          'Pilih lantai dan slot parkir yang tersedia, lalu lakukan booking untuk mengamankan tempat parkir Anda',
      'icon': Icons.map_outlined,
    },
    {
      'title': 'Langkah 3',
      'desc':
          'Scan tiket parkir Anda saat tiba di lokasi untuk mengaktifkan sesi parkir',
      'icon': Icons.qr_code_scanner,
    },
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _scanAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Preview area
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  // Preview content simulating app UI
                  _buildPreviewContent(),
                  // Scan highlight arrows
                  AnimatedBuilder(
                    animation: _scanAnim,
                    builder: (context, _) {
                      if (_currentStep == 0) {
                        return Positioned(
                          top: 60 + _scanAnim.value * 10,
                          left: 16,
                          child: const Icon(Icons.arrow_forward,
                              color: AppColors.accent, size: 28),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // Info area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Text(
                _steps[_currentStep]['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _steps[_currentStep]['desc'],
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _steps.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _currentStep ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _currentStep
                          ? AppColors.accent
                          : AppColors.borderColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentStep < _steps.length - 1) {
                      setState(() => _currentStep++);
                    } else {
                      Navigator.pushNamed(context, AppRoutes.halamanScan);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardBg,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: AppColors.accent),
                  ),
                  child: Text(
                    _currentStep < _steps.length - 1
                        ? 'Selanjutnya'
                        : 'Mulai Scan',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Page indicator line
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewContent() {
    return Container(
      color: const Color(0xFF0D1628),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Search bar mock
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.cardBg2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: const [
                SizedBox(width: 10),
                Icon(Icons.search, color: AppColors.textSecondary, size: 18),
                SizedBox(width: 8),
                Text('Cari Gedung Parkir',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Gedung Parkir yang Tersedia',
            style: TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._buildParkingListItems(),
        ],
      ),
    );
  }

  List<Widget> _buildParkingListItems() {
    final items = [
      {'name': 'Jurusan Teknik Elektro Universitas Lampung', 'pct': 78.0},
      {'name': 'Mall Boemi Kedaton', 'pct': 81.0},
      {'name': 'Lampung City Mall', 'pct': 81.0},
    ];
    return items.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined,
                color: AppColors.accent, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (item['pct'] as double) / 100,
                    backgroundColor: AppColors.borderColor,
                    color: AppColors.accent,
                    minHeight: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${item['pct'].toInt()}%',
              style:
                  const TextStyle(color: AppColors.accent, fontSize: 10),
            ),
          ],
        ),
      );
    }).toList();
  }
}
