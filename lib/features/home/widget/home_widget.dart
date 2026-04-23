import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../public_widget/bottom_nav_bar.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _navIndex = 0;
  final _searchCtrl = TextEditingController();

  final List<Map<String, dynamic>> _parkingList = [
    {
      'name': 'Jurusan Teknik Elektro Universitas Lampung',
      'pct': 78.0,
      'kosong': '4/5 Kosong',
    },
    {
      'name': 'Mall Boemi Kedaton',
      'pct': 81.0,
      'kosong': '635/1384 Kosong',
    },
    {
      'name': 'Lampung City Mall',
      'pct': 81.0,
      'kosong': '635/1384 Kosong',
    },
  ];

  void _onNavTap(int idx) {
    setState(() => _navIndex = idx);
    switch (idx) {
      case 1:
        Navigator.pushNamed(context, AppRoutes.booking);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.history);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.profil);
        break;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 16),
                // Banner
                _buildHeroBanner(),
                const SizedBox(height: 16),
                // Status cards
                _buildStatusCards(),
                const SizedBox(height: 20),
                // Search bar
                _buildSearchBar(),
                const SizedBox(height: 20),
                // Parking list
                _buildParkingSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // Avatar
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
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const Icon(Icons.notifications_outlined,
                color: Colors.white70, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3A5C), Color(0xFF0D1628)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Stack(
        children: [
          // Background parking building pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2C5C8A), Color(0xFF1A3A5C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            color: const Color(0xFF0D1E35),
                            child: const Text(
                              'PARKFINDER 150',
                              style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            color: const Color(0xFF0D1E35),
                            child: const Text(
                              'PARKFINDER',
                              style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: const Color(0xFF0A1828),
                      child: const Center(
                        child: Icon(Icons.directions_car_filled,
                            color: AppColors.textMuted, size: 80),
                      ),
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

  Widget _buildStatusCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatusCard(
            title: 'Status Tiket\nAktif',
            icon: Icons.confirmation_number_outlined,
            iconColor: Colors.orange,
            subtitle: 'Diaktifkan Sejak\n01:43:02',
            width: 130,
          ),
          const SizedBox(width: 10),
          _buildStatusCard(
            title: 'Status Booking\nMenunggu Aktivasi',
            icon: Icons.timelapse,
            iconColor: AppColors.accent,
            subtitle: 'Slot A4 – Lantai 1\nAktivasi dalam 15 menit',
            width: 148,
          ),
          const SizedBox(width: 10),
          _buildStatusCard(
            title: 'Parkir Aktif\nLantai 1 - Zona A- Slot A3',
            icon: Icons.directions_car,
            iconColor: AppColors.orange,
            subtitle: '01:43:02',
            width: 140,
            actions: [
              _buildCardAction('Lihat Detail', () {}),
              _buildCardAction('Akhiri Sesi', () {
                _showEndSessionDialog();
              }, isRed: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String subtitle,
    required double width,
    List<Widget>? actions,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Icon(icon, color: iconColor, size: 36),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 10),
          ),
          if (actions != null) ...[
            const SizedBox(height: 8),
            Row(children: actions),
          ],
        ],
      ),
    );
  }

  Widget _buildCardAction(String label, VoidCallback onTap,
      {bool isRed = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          label,
          style: TextStyle(
            color: isRed ? AppColors.red : AppColors.accent,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.booking),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: const [
              SizedBox(width: 14),
              Icon(Icons.search, color: AppColors.textSecondary, size: 20),
              SizedBox(width: 10),
              Text('Cari Gedung Parkir',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParkingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gedung Parkir yang Tersedia',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._parkingList.map((item) => _buildParkingItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildParkingItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.detailBooking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined,
                color: AppColors.accent, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: item['pct'] / 100,
                      backgroundColor: AppColors.borderColor,
                      color: AppColors.accent,
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item['pct'].toInt()}%',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item['kosong'],
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEndSessionDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D6B6B), Color(0xFF1A2D5F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Akhiri Sesi Parkir?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sesi parkir untuk kendaraan D 12345 FE akan diakhiri.\n'
                'Total waktu parkir Anda adalah 3 Jam 10 Menit.\n'
                'Apakah Anda yakin ingin keluar sekarang?',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text('Ya, Keluar Sekarang',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white38),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text('Batal',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
