import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../public_widget/bottom_nav_bar.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  int _navIndex = 3;

  final List<Map<String, String>> _history = List.generate(
    8,
    (_) => {
      'dari': '19:33',
      'tglDari': '02 Maret 2026',
      'hingga': '23:01',
      'tglHingga': '02 Maret 2026',
      'slotParkir': 'Mall Bumi Kedaton\n(Lantai 1, A4)',
      'idTiket': 'TXT-20260302-0054',
      'kendaraan': 'D 12345 FE',
    },
  );

  void _onNavTap(int idx) {
    setState(() => _navIndex = idx);
    switch (idx) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.booking);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.profil);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.cardBg2,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent, width: 2),
                ),
                child: const Icon(Icons.person, color: Colors.white70, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Imam Ariadi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Selamat Pagi',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: Colors.white70, size: 20),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'History',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _history.length,
            itemBuilder: (context, i) {
              final item = _history[i];
              return _buildHistoryCard(item);
            },
          ),
        ),

        AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
      ],
    );
  }

  Widget _buildHistoryCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Dari / Hingga
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dari',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 10)),
                  Text(
                    item['dari']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(item['tglDari']!,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 10)),
                  const SizedBox(height: 8),
                  const Text('Hingga',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 10)),
                  Text(
                    item['hingga']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(item['tglHingga']!,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 10)),
                ],
              ),
              const Spacer(),
              // Right: Slot parkir & ID Tiket
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Slot Parkir',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 10)),
                  Text(
                    item['slotParkir']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  const Text('ID Tiket',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 10)),
                  Text(
                    item['idTiket']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.directions_car_outlined,
                  color: AppColors.textSecondary, size: 18),
              const SizedBox(width: 8),
              Text(
                item['kendaraan']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
