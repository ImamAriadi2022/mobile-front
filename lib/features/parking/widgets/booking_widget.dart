import 'package:flutter/material.dart';
import 'package:mobile_front/core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:mobile_front/shared/widgets/shared_widgets.dart';
import '../services/booking_service.dart';

/// BookingWidget: Composer untuk halaman pencarian dan pemilihan gedung parkir.
class BookingWidget extends StatefulWidget {
  const BookingWidget({super.key});

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  final _searchCtrl = TextEditingController();
  int _navIndex = 1;
  bool _isLoading = true;

  List<ParkingItemData> _allParking = [];

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
            availableSlotLabel: '$available/$total Kosong',
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const _BookingHeaderWidget(),
                    const SizedBox(height: 12),

                    // Denah Banner Template PNG
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg2,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/denah_parkir.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Icon(
                                      Icons.map_rounded,
                                      size: 60,
                                      color: AppColors.accent.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  color: Colors.black.withValues(alpha: 0.5),
                                  child: const Text(
                                    'Peta Denah Kawasan Parkir FT Unila',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SearchBarWidget(
                        controller: _searchCtrl,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const SectionTitleWidget(
                      title: 'Pilihan Gedung & Area Parkir',
                    ),
                    const SizedBox(height: 12),

                    // Lista Gedung Parkir
                    _isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(color: AppColors.accent),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: _filtered
                                  .map(
                                    (item) => ParkingListItemWidget(
                                      item: item,
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.detailBooking,
                                          arguments: item.id,
                                        );
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Nav
            AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }
}

class _BookingHeaderWidget extends StatelessWidget {
  const _BookingHeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Cari Area Parkir',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
