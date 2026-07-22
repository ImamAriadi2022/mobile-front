import 'package:flutter/material.dart';
import 'package:mobile_front/core/routes/app_routes.dart';
import '../../../shared/styles/app_colors.dart';
import '../../../shared/styles/app_text_styles.dart';
import '../../../core/storage/active_ticket_storage.dart';
import '../../../core/storage/active_reservation_storage.dart';
import 'package:mobile_front/shared/widgets/shared_widgets.dart';
import 'floor_tab_widget.dart';
import 'parking_slot_item_widget.dart';
import 'parking_slot_map_widget.dart';
import 'package:mobile_front/features/parking/services/booking_service.dart';
import 'package:mobile_front/features/profile/services/profile_service.dart';

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
  ParkingSlotData? _selectedSlot;

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

        if (_leftSlots.isNotEmpty) {
          _selectedSlot = _leftSlots.firstWhere(
            (s) => s.status == SlotStatus.kosong,
            orElse: () => _leftSlots.first,
          );
        }

        _isLoading = false;
      });
    }
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = AppColors.getBackgroundColor(context);
    final cardBg = AppColors.getCardBg(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);

    final availableCount = _leftSlots.where((s) => s.status == SlotStatus.kosong).length +
        _rightSlots.where((s) => s.status == SlotStatus.kosong).length;
    final totalCount = _leftSlots.length + _rightSlots.length;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar Header
            UserHeaderWidget(
              name: 'User',
              greeting: '',
              title: 'Peta Parkir',
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Area Title & Location Subtitle
                    Text(
                      'Teknik elektro universitas lampung',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          'Sisi Timur, Lantai 1',
                          style: TextStyle(
                            fontSize: 13,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Status Legend Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderColorDark : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildLegendItem(const Color(0xFF22C55E), 'Tersedia', isDark),
                          const SizedBox(width: 16),
                          _buildLegendItem(const Color(0xFFDC2626), 'Terisi', isDark),
                          const SizedBox(width: 16),
                          _buildLegendItem(const Color(0xFF94A3B8), 'Pemeliharaan', isDark),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEDD5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.directions_car_filled_rounded, size: 14, color: Color(0xFFC2410C)),
                                const SizedBox(width: 4),
                                Text(
                                  '$availableCount/$totalCount',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFC2410C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Interactive Slot Map Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardBg2Dark : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.borderColorDark : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column (A01 - A05)
                          Expanded(
                            child: Column(
                              children: _leftSlots.map((slot) {
                                return ParkingSlotItemWidget(
                                  slot: slot,
                                  isSelected: _selectedSlot?.id == slot.id,
                                  onTap: () {
                                    setState(() => _selectedSlot = slot);
                                  },
                                );
                              }).toList(),
                            ),
                          ),

                          // Middle Road Divider with Arrows
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                const Icon(Icons.arrow_upward_rounded, size: 20, color: Color(0xFF1E40AF)),
                                const SizedBox(height: 36),
                                const Icon(Icons.arrow_upward_rounded, size: 20, color: Color(0xFF1E40AF)),
                                const SizedBox(height: 36),
                                const Icon(Icons.arrow_upward_rounded, size: 20, color: Color(0xFF1E40AF)),
                                const SizedBox(height: 36),
                                const Text(
                                  'MASUK\n↑',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E40AF),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right Column (B01 - B05)
                          Expanded(
                            child: Column(
                              children: _rightSlots.map((slot) {
                                return ParkingSlotItemWidget(
                                  slot: slot,
                                  isSelected: _selectedSlot?.id == slot.id,
                                  onTap: () {
                                    setState(() => _selectedSlot = slot);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bottom Confirmation Banner Box
                    if (_selectedSlot != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF061E3D),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pilih Slot ini?',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Slot ${_selectedSlot!.label}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _handleSlotBooking(_selectedSlot!);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF97316),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Pilih',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
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

  Widget _buildLegendItem(Color color, String label, bool isDark) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white70 : const Color(0xFF475569),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
