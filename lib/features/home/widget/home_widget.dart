import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../booking/service/booking_service.dart';
import '../../profil/service/profile_service.dart';
import '../../public_widget/bottom_nav_bar.dart';
import '../../public_widget/user_header_widget.dart';
import '../../public_widget/search_bar_widget.dart';
import '../../public_widget/section_title_widget.dart';
import '../../public_widget/parking_list_item_widget.dart';
import '../../public_widget/end_session_dialog_widget.dart';
import 'hero_banner_widget.dart';
import 'status_card_widget.dart';

/// HomeWidget: Composer untuk halaman utama (dashboard).
///
/// Tanggung jawab:
/// - Mengelola state [_navIndex] dan data [_parkingList]
/// - Menyusun widget: Header, Banner, StatusCards, SearchBar, ParkingList
/// - Menangani navigasi dan dialog akhiri sesi
class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  // ── State ────────────────────────────────────────────────────────────────
  int _navIndex = 0;
  bool _isLoading = true;
  String? _error;
  List<ParkingItemData> _parkingList = [];
  String _userName = 'User';
  String _greeting = 'Selamat Datang';

  @override
  void initState() {
    super.initState();
    _fetchAreas();
    _loadProfile();
  }

  void _loadProfile() {
    _greeting = greetingFromHour(context);
    ProfileService().getProfile().then((profile) {
      if (mounted && profile != null) {
        setState(() => _userName = profile.name);
      }
    });
  }

  Future<void> _fetchAreas() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final service = BookingService();
    final areas = await service.getAreas();

    if (!mounted) return;

    if (areas.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = 'Gagal memuat data parkir.';
      });
      return;
    }

    setState(() {
      _parkingList = areas.map((a) {
        final total = a.totalSlot;
        final available = a.availableSlots;
        final occupancy = total > 0 ? ((total - available) / total * 100) : 0.0;
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

  // ── Handlers ───────────────────────────────────────────────────────────────
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

  void _showEndSessionDialog() {
    showDialog(
      context: context,
      builder: (_) => EndSessionDialogWidget(
        vehiclePlate: 'D 12345 FE',
        parkingDuration: '3 Jam 10 Menit',
        onConfirm: () => Navigator.pop(context),
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  // ── Build (Composer) ───────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ① Header pengguna
                UserHeaderWidget(
                  name: _userName,
                  greeting: _greeting,
                ),
                const SizedBox(height: 16),

                // ② Hero banner
                const HeroBannerWidget(),
                const SizedBox(height: 16),

                // ③ Status cards (horizontal scroll)
                _buildStatusCards(),
                const SizedBox(height: 20),

                // ④ Search bar (read-only, navigasi ke booking)
                SearchBarWidget(
                  readOnly: true,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.booking),
                ),
                const SizedBox(height: 20),

                // ⑤ Section parkir tersedia
                const SectionTitleWidget(
                  title: 'Gedung Parkir yang Tersedia',
                ),
                const SizedBox(height: 12),

                // ⑥ Daftar parkir / loading / error / empty
                _buildParkingSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // ⑦ Bottom nav bar
        AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
      ],
    );
  }

  // ── Private Builders ───────────────────────────────────────────────────────

  Widget _buildParkingSection() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            children: [
              const Icon(Icons.cloud_off_rounded,
                  color: AppColors.textSecondary, size: 40),
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _fetchAreas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.accent),
                    ),
                  ),
                  child: const Text('Coba Lagi',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_parkingList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Belum ada gedung parkir tersedia.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _parkingList
            .map((item) => ParkingListItemWidget(
                  item: item,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.detailBooking,
                    arguments: item.id,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildStatusCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          StatusCardWidget(
            title: 'Status Tiket\nAktif',
            cardImage: StatusCardImage.tiket,
            subtitle: 'Diaktifkan Sejak\n01:43:02',
            width: 130,
          ),
          const SizedBox(width: 10),
          StatusCardWidget(
            title: 'Status Booking\nMenunggu Aktivasi',
            cardImage: StatusCardImage.waiting,
            subtitle: 'Slot A4 – Lantai 1\nAktivasi dalam 15 menit',
            width: 148,
          ),
          const SizedBox(width: 10),
          StatusCardWidget(
            title: 'Parkir Aktif\nLantai 1 - Zona A- Slot A3',
            cardImage: StatusCardImage.car,
            subtitle: '01:43:02',
            width: 140,
            actions: [
              CardActionTextWidget(
                label: 'Lihat Detail',
                onTap: () {},
              ),
              CardActionTextWidget(
                label: 'Akhiri Sesi',
                onTap: _showEndSessionDialog,
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
