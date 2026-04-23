import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../public_widget/bottom_nav_bar.dart';
import '../../../app/app_routes.dart';

class DetailBookingWidget extends StatefulWidget {
  const DetailBookingWidget({super.key});

  @override
  State<DetailBookingWidget> createState() => _DetailBookingWidgetState();
}

class _DetailBookingWidgetState extends State<DetailBookingWidget> {
  int _selectedFloorTab = 0; // 0=Semua, 1=Lantai 1, 2=Lantai 2
  int _currentZonePage = 0;
  int _navIndex = 1;

  // Slot statuses: 0=Alat Rusak, 1=Kosong, 2=Terisi, 3=Terpesan, 4=Pemeliharaan
  final List<Map<String, dynamic>> _leftSlots = [
    {'label': 'A20', 'status': 0},
    {'label': 'A19', 'status': 0},
    {'label': 'A18', 'status': 0},
    {'label': 'A17', 'status': 0},
    {'label': 'A16', 'status': 0},
    {'label': 'A15', 'status': 0},
    {'label': 'A14', 'status': 0},
    {'label': 'A13', 'status': 0},
    {'label': 'A12', 'status': 0},
    {'label': 'A11', 'status': 0},
  ];

  final List<Map<String, dynamic>> _rightSlots = [
    {'label': 'A01', 'status': 2},
    {'label': 'A02', 'status': 1},
    {'label': 'A03', 'status': 3},
    {'label': 'A04', 'status': 1},
    {'label': 'A05', 'status': 1},
    {'label': 'A06', 'status': 4},
    {'label': 'A07', 'status': 0},
    {'label': 'A08', 'status': 0},
    {'label': 'A09', 'status': 0},
    {'label': 'A10', 'status': 0},
  ];

  Color _slotColor(int status) {
    switch (status) {
      case 0:
        return AppColors.red;
      case 1:
        return AppColors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.purple;
      default:
        return AppColors.borderColor;
    }
  }

  String _slotLabel(int status) {
    switch (status) {
      case 0:
        return 'Alat Rusak';
      case 1:
        return 'Kosong';
      case 2:
        return 'Terisi';
      case 3:
        return 'Terpesan';
      case 4:
        return 'Pemeliharaan';
      default:
        return '';
    }
  }

  void _onNavTap(int idx) {
    setState(() => _navIndex = idx);
    switch (idx) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App bar
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 18),
                ),
              ),
              const Expanded(
                child: Text(
                  'Teknik Elektro Universitas Lampung',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: Colors.white70, size: 20),
              ),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: const [
                SizedBox(width: 12),
                Icon(Icons.search, color: AppColors.textSecondary, size: 18),
                SizedBox(width: 8),
                Text('Cari slot , contoh (lantai 1 Slot A4)',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ),

        // Floor tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _buildFloorTab(0, 'Semua'),
              const SizedBox(width: 8),
              _buildFloorTab(1, 'Lantai 1'),
              const SizedBox(width: 8),
              _buildFloorTab(2, 'Lantai 2'),
            ],
          ),
        ),

        // Zone header with pagination
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.arrow_back_ios,
                  color: AppColors.textSecondary, size: 16),
              const Text(
                'Zona A - Lantai 1',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: AppColors.textSecondary, size: 16),
            ],
          ),
        ),

        // Parking slot map
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Left column
                Expanded(child: _buildSlotColumn(_leftSlots, arrowUp: true)),
                // Divider (road)
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: AppColors.borderColor,
                  child: Column(
                    children: List.generate(
                      10,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 1,
                        height: 14,
                        color: i % 2 == 0
                            ? AppColors.textSecondary
                            : Colors.transparent,
                      ),
                    ),
                  ),
                ),
                // Right column
                Expanded(child: _buildSlotColumn(_rightSlots, arrowUp: false)),
              ],
            ),
          ),
        ),

        AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
      ],
    );
  }

  Widget _buildFloorTab(int idx, String label) {
    final isSelected = _selectedFloorTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedFloorTab = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSlotColumn(List<Map<String, dynamic>> slots,
      {required bool arrowUp}) {
    return Column(
      children: slots.asMap().entries.map((e) {
        final i = e.key;
        final slot = e.value;
        final status = slot['status'] as int;
        final showArrow = (arrowUp && i % 3 == 0) || (!arrowUp && i % 3 == 1);

        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _slotColor(status).withOpacity(0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!arrowUp && status != 0 && status != 4)
                Icon(
                  status == 2
                      ? Icons.directions_car
                      : status == 1
                          ? Icons.local_parking
                          : Icons.bookmark,
                  color: _slotColor(status),
                  size: 22,
                )
              else
                const SizedBox(width: 22),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _slotLabel(status),
                    style: TextStyle(
                        color: _slotColor(status),
                        fontSize: 9,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    slot['label'] as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
