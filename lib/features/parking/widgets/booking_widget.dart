import 'package:flutter/material.dart';
import 'package:mobile_front/core/routes/app_routes.dart';
import '../../../shared/styles/app_colors.dart';
import '../../../shared/styles/app_text_styles.dart';
import 'package:mobile_front/shared/widgets/shared_widgets.dart';
import '../services/booking_service.dart';

class BookingWidget extends StatefulWidget {
  const BookingWidget({super.key});

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  final _searchCtrl = TextEditingController();
  int _navIndex = 1;
  int _selectedFilterIndex = 0;
  bool _isLoading = true;

  List<ParkingItemData> _allParking = [];

  final List<String> _filters = ['Semua', 'Terdekat', 'Populer', 'Baru'];

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    final service = BookingService();
    final areas = await service.getAreas();

    if (mounted) {
      setState(() {
        _allParking = areas.map((a) {
          final total = a.totalSlot;
          final available = a.availableSlots;
          final occupancy =
              total > 0 ? ((total - available) / total * 100) : 0.0;
          return ParkingItemData(
            id: a.id,
            name: a.name,
            occupancyPercent: occupancy,
            availableSlotLabel: '$available Slot Tersedia',
          );
        }).toList();
        _isLoading = false;
      });
    }
  }

  List<ParkingItemData> get _filtered {
    final q = _searchCtrl.text.toLowerCase();
    if (q.isEmpty) return _allParking;
    return _allParking.where((e) => e.name.toLowerCase().contains(q)).toList();
  }

  void _onNavTap(int idx) {
    setState(() => _navIndex = idx);
    switch (idx) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.statusKendaraan);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.history);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.profil);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = AppColors.getBackgroundColor(context);
    final cardBg = AppColors.getCardBg(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Bar (Cari Lokasi Parkir)
                    UserHeaderWidget(
                      name: 'User',
                      greeting: '',
                      title: 'Cari Lokasi Parkir',
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SearchBarWidget(
                        controller: _searchCtrl,
                        hintText: 'Cari gedung atau area...',
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Filter Pills Horizontal Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: _filters.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final label = entry.value;
                          final isSelected = _selectedFilterIndex == idx;

                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                setState(() => _selectedFilterIndex = idx);
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF1D4ED8)
                                      : (isDark ? AppColors.cardBg2Dark : const Color(0xFFE0F2FE)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? Colors.white70 : const Color(0xFF1E40AF)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // List Area Cards
                    _isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: _filtered.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isDark ? AppColors.borderColorDark : const Color(0xFFE2E8F0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.detailBooking,
                                        arguments: item.id,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Header Image with Tag
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                              child: SizedBox(
                                                height: 160,
                                                width: double.infinity,
                                                child: Image.asset(
                                                  index == 0
                                                      ? 'lib/assets/parking/denah_parkir.png'
                                                      : 'lib/assets/home/dashboard_parkir.png',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => Container(
                                                    color: const Color(0xFFF1F5F9),
                                                    child: const Icon(Icons.apartment_rounded, size: 60),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (index == 0)
                                              Positioned(
                                                top: 12,
                                                right: 12,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF1D4ED8),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'Mitra Utama',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                        // Body Details
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    item.name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: textPrimary,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFDBEAFE),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons.star_rounded, color: Color(0xFF2563EB), size: 14),
                                                        SizedBox(width: 2),
                                                        Text(
                                                          '4.9',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFF1E40AF),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Fakultas Teknik Unila, Gedung B',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              const Divider(height: 1),
                                              const SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration: const BoxDecoration(
                                                          color: Color(0xFF10B981),
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        item.availableSlotLabel,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF10B981),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.near_me_outlined, size: 14, color: Color(0xFF64748B)),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '0.8 km',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: textSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }
}
