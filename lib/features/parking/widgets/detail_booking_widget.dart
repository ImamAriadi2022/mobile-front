import 'package:flutter/material.dart';
import 'package:mobile_front/core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/storage/active_ticket_storage.dart';
import '../../../core/storage/active_reservation_storage.dart';
import 'package:mobile_front/shared/widgets/shared_widgets.dart';
import 'floor_tab_widget.dart';
import 'parking_slot_item_widget.dart';
import 'parking_slot_map_widget.dart';
import 'package:mobile_front/features/parking/services/booking_service.dart';
import 'package:mobile_front/features/profile/services/profile_service.dart';

/// DetailBookingWidget: Composer untuk halaman peta slot parkir.
class DetailBookingWidget extends StatefulWidget {
  final String areaId;

  const DetailBookingWidget({super.key, required this.areaId});

  @override
  State<DetailBookingWidget> createState() => _DetailBookingWidgetState();
}

class _DetailBookingWidgetState extends State<DetailBookingWidget> {
  int _selectedFloorTab = 0;
  int _navIndex = 1;
  bool _isLoading = true;
  bool _showVisualMap = false;

  List<ParkingSlotData> _leftSlots = [];
  List<ParkingSlotData> _rightSlots = [];

  @override
  void initState() {
    super.initState();
    _fetchSlots();
  }

  Future<void> _fetchSlots() async {
    if (widget.areaId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final service = BookingService();
    final slots = await service.getSlots(widget.areaId);

    if (mounted) {
      setState(() {
        final half = (slots.length / 2).ceil();

        SlotStatus mapStatus(String st) {
          switch (st.toLowerCase()) {
            case 'available':
              return SlotStatus.kosong;
            case 'occupied':
              return SlotStatus.terisi;
            case 'booked':
              return SlotStatus.terpesan;
            case 'maintenance':
              return SlotStatus.pemeliharaan;
            default:
              return SlotStatus.alatRusak;
          }
        }

        _leftSlots = slots
            .take(half)
            .map((s) => ParkingSlotData(
                id: s.id, label: s.slotNumber, status: mapStatus(s.status)))
            .toList();

        _rightSlots = slots
            .skip(half)
            .map((s) => ParkingSlotData(
                id: s.id, label: s.slotNumber, status: mapStatus(s.status)))
            .toList();

        _isLoading = false;
      });
    }
  }

  static const _floorTabs = ['Semua', 'Lantai 1', 'Lantai 2'];

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom app bar
            _DetailAppBarWidget(
              title: 'Peta Slot Parkir FT Unila',
              onBack: () => Navigator.pop(context),
              showVisualMap: _showVisualMap,
              onToggleMap: () => setState(() => _showVisualMap = !_showVisualMap),
            ),

            // Search bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SearchBarWidget(
                hintText: 'Cari slot (contoh: Lantai 1 Slot A4)',
                readOnly: true,
              ),
            ),

            // Floor tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _floorTabs.asMap().entries.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(
                        right: e.key < _floorTabs.length - 1 ? 8 : 0),
                    child: FloorTabWidget(
                      label: e.value,
                      isSelected: _selectedFloorTab == e.key,
                      onTap: () => setState(() => _selectedFloorTab = e.key),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Visual Map preview PNG vs Slot grid
            if (_showVisualMap)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'lib/assets/parking/peta_parkir_ft_unila.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Text(
                          'Gambar Peta Denah Tidak Ditemukan',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else ...[
              // Zone header
              const _ZoneHeaderWidget(zoneName: 'Zona A - Lantai 1'),
              const SizedBox(height: 8),

              // Peta slot parkir
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.accent))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ParkingSlotMapWidget(
                          leftSlots: _leftSlots,
                          rightSlots: _rightSlots,
                          onSlotTap: (slot) => _handleSlotBooking(slot),
                        ),
                      ),
              ),
            ],

            // Bottom nav
            AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSlotBooking(ParkingSlotData slot) async {
    if (slot.status != SlotStatus.kosong) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slot tidak tersedia.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final profileService = ProfileService();
    final vehicleService = VehicleService();
    final profile = await profileService.getProfile();
    final vehicles = await vehicleService.getVehicles();

    final name = profile?.name ?? 'User';
    final plateNumber =
        vehicles.isNotEmpty ? vehicles.first.plateNumber : 'UNKNOWN';

    final activeTicket = await ActiveTicketStorage().load();
    final ticketId = activeTicket?.ticketCode ?? 'unknown';

    if (activeTicket == null) {
      if (mounted) {
        setState(() => _isLoading = false);
        NoTicketDialog.show(context);
      }
      return;
    }

    final bookingService = BookingService();
    final result = await bookingService.createReservation(
      slotId: slot.id ?? '',
      ticketId: ticketId,
      name: name,
      plateNumber: plateNumber,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (result.success && result.reservationId.isNotEmpty) {
        final reservation = ActiveReservation(
          reservationId: result.reservationId,
          status: result.status,
          slotId: slot.id ?? '',
          slotName: slot.label,
          areaId: widget.areaId,
          ticketId: ticketId,
          startTime: DateTime.now().toIso8601String(),
        );
        await ActiveReservationStorage().save(reservation);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result.message), backgroundColor: Colors.green),
        );
        _fetchSlots();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}

class _DetailAppBarWidget extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final bool showVisualMap;
  final VoidCallback onToggleMap;

  const _DetailAppBarWidget({
    required this.title,
    required this.onBack,
    required this.showVisualMap,
    required this.onToggleMap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onToggleMap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: showVisualMap ? AppColors.accent : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Icon(
                showVisualMap ? Icons.grid_view_rounded : Icons.map_rounded,
                color: showVisualMap ? Colors.white : AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneHeaderWidget extends StatelessWidget {
  final String zoneName;

  const _ZoneHeaderWidget({required this.zoneName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_back_ios,
              color: AppColors.textSecondary, size: 16),
          Text(
            zoneName,
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              color: AppColors.textSecondary, size: 16),
        ],
      ),
    );
  }
}
