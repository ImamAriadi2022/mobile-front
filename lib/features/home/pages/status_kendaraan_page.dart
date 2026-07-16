import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/storage/active_ticket_storage.dart';
import '../../../core/storage/active_reservation_storage.dart';
import 'package:mobile_front/shared/widgets/shared_widgets.dart';
import 'package:mobile_front/core/routes/app_routes.dart';
import 'package:mobile_front/features/scan/services/scan_service.dart';
import 'package:mobile_front/features/scan/models/ticket_data.dart';
import 'package:mobile_front/features/profile/services/profile_service.dart';
import 'package:mobile_front/features/profile/models/vehicle.dart';
import 'package:mobile_front/features/profile/services/profile_service.dart';
import 'package:mobile_front/features/history/services/history_service.dart';
import 'package:mobile_front/features/history/models/reservation_history.dart';
import 'package:mobile_front/features/parking/services/booking_service.dart';
import 'package:mobile_front/features/parking/models/parking_slot.dart';
import 'package:mobile_front/features/parking/models/reservation_result.dart';

class StatusKendaraanPage extends StatefulWidget {
  const StatusKendaraanPage({super.key});

  @override
  State<StatusKendaraanPage> createState() => _StatusKendaraanPageState();
}

class _StatusKendaraanPageState extends State<StatusKendaraanPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _glowAnim;
  int _navIndex = 2;

  int _elapsedSeconds = 0;
  Timer? _timer;
  TicketData? _activeTicket;
  ActiveReservation? _activeReservation;
  bool _isCancelling = false;
  bool _isLoading = true;
  bool _isArriving = false;
  bool _isSwapping = false;

  // Vehicle data from API
  String _plateNumber = '';
  String _vehicleType = '';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    // Load active ticket from local storage first for instant responsiveness
    var ticket = await ActiveTicketStorage().load();

    // Then check and sync with backend API in the background
    final accessService = AccessService();
    final apiTicket = await accessService.getActiveTicket();
    if (apiTicket != null) {
      await ActiveTicketStorage().save(apiTicket);
      ticket = apiTicket;
    }

    // Sync active reservation state from API (Source of Truth)
    ActiveReservation? reservation = await ActiveReservationStorage().load();
    try {
      final profile = await ProfileService().getProfile();
      if (profile != null) {
        final historyList = await HistoryService().getHistory(profile.userId);
        // Find reservation with status 'active' or 'pending'
        ReservationHistory? activeResFromApi;
        for (final r in historyList) {
          if (r.status == 'active' || r.status == 'pending') {
            activeResFromApi = r;
            break;
          }
        }

        if (activeResFromApi != null) {
          reservation = ActiveReservation(
            reservationId: activeResFromApi.reservationId,
            status: activeResFromApi.status,
            slotId: activeResFromApi.slotId,
            slotName: activeResFromApi.slotName,
            areaId: activeResFromApi.areaId,
            ticketId: activeResFromApi.ticketId,
            startTime: activeResFromApi.timestamps.created ?? '',
          );
          await ActiveReservationStorage().save(reservation);
        } else {
          // If backend says no active/pending reservation exists, clear local storage
          if (reservation != null) {
            await ActiveReservationStorage().clear();
            reservation = null;
          }
        }
      }
    } catch (e) {
      print('Sync active reservation error: $e');
    }

    // Load vehicle data from API
    final vehicleService = VehicleService();
    List<Vehicle> vehicles = [];
    try {
      vehicles = await vehicleService.getVehicles();
    } catch (_) {}

    if (mounted) {
      setState(() {
        _activeTicket = ticket;
        _activeReservation = reservation;

        // Get plate number and vehicle type from vehicle data
        if (vehicles.isNotEmpty) {
          _plateNumber = vehicles.first.plateNumber;
          _vehicleType = vehicles.first.vehicleType;
        } else if (ticket != null && ticket.vehicleType.isNotEmpty) {
          _vehicleType = ticket.vehicleType;
        }

        _isLoading = false;
      });

      // Start timer based on reservation startTime
      _startElapsedTimer();
    }
  }

  void _startElapsedTimer() {
    _timer?.cancel();

    if (_activeReservation != null && _activeReservation!.startTime.isNotEmpty) {
      try {
        final startTime = DateTime.parse(_activeReservation!.startTime);
        _elapsedSeconds = DateTime.now().difference(startTime).inSeconds;
        if (_elapsedSeconds < 0) _elapsedSeconds = 0;
      } catch (_) {
        _elapsedSeconds = 0;
      }
    } else if (_activeTicket != null &&
        _activeTicket!.ticketCode.isNotEmpty &&
        (_activeTicket!.status == 'active' ||
            _activeTicket!.status == 'claimed')) {
      // Fallback: use claimedAt timestamp if available, otherwise start from 0
      if (_activeTicket!.claimedAt.isNotEmpty) {
        try {
          final claimedTime = DateTime.parse(_activeTicket!.claimedAt);
          _elapsedSeconds = DateTime.now().difference(claimedTime).inSeconds;
          if (_elapsedSeconds < 0) _elapsedSeconds = 0;
        } catch (_) {
          _elapsedSeconds = 0;
        }
      } else {
        _elapsedSeconds = 0;
      }
    } else {
      return; // No active session, don't start timer
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _hasActiveSession {
    if (_activeReservation != null && _activeReservation!.reservationId.isNotEmpty) {
      return true;
    }
    if (_activeTicket != null &&
        _activeTicket!.ticketCode.isNotEmpty &&
        (_activeTicket!.status == 'active' ||
            _activeTicket!.status == 'claimed')) {
      return true;
    }
    return false;
  }

  void _onNavTap(int idx) {
    setState(() => _navIndex = idx);
    switch (idx) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.booking);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.history);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.profil);
        break;
    }
  }

  Future<void> _onKeluarParkir() async {
    if (!_hasActiveSession) return;

    setState(() => _isCancelling = true);

    final service = BookingService();

    // Check if reservation is active/arrived to complete it
    if (_activeReservation != null &&
        (_activeReservation!.status == 'active' ||
            _activeReservation!.status == 'arrived')) {
      final result = await service.completeReservation(_activeReservation!.reservationId);
      if (!mounted) return;
      setState(() => _isCancelling = false);

      if (result.success) {
        _timer?.cancel();
        await ActiveTicketStorage().clear();
        await ActiveReservationStorage().clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        _showErrorDialog(result.message);
      }
      return;
    }

    // Default cancel behavior
    CancelResult result;
    if (_activeReservation != null) {
      result = await service.cancelReservation(_activeReservation!.reservationId);
    } else if (_activeTicket != null) {
      result = await service.cancelTicket(_activeTicket!.ticketCode);
    } else {
      await ActiveTicketStorage().clear();
      await ActiveReservationStorage().clear();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    if (!mounted) return;
    setState(() => _isCancelling = false);

    if (result.success) {
      _timer?.cancel();
      await ActiveTicketStorage().clear();
      await ActiveReservationStorage().clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      _showErrorDialog(result.message);
    }
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('Gagal', style: TextStyle(color: Colors.white)),
        content: Text(msg, style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    )
                  : _hasActiveSession
                      ? _buildActiveSessionView()
                      : _buildEmptyStateView(),
            ),
            AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }

  // ── Empty State (No Active Session) ──────────────────────────────────────

  Widget _buildEmptyStateView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardBg,
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.directions_car_outlined,
                color: AppColors.textSecondary,
                size: 56,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tidak Ada Sesi Parkir Aktif',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Anda belum memiliki sesi parkir yang sedang berjalan.\n'
              'Silakan scan tiket dan booking slot parkir terlebih dahulu.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.welcomeScan);
                    },
                    icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                    label: const Text('Scan Tiket'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.booking);
                    },
                    icon: const Icon(Icons.local_parking_rounded, size: 18),
                    label: const Text('Cari Parkir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Active Session View ──────────────────────────────────────────────────

  Widget _buildActiveSessionView() {
    final slotName = _activeReservation?.slotName ?? '';
    final areaName = _activeTicket?.areaName ?? '';
    final displayVehicleType = _vehicleType.isNotEmpty
        ? _vehicleType.toUpperCase()
        : 'KENDARAAN';
    final reservationStatus = _activeReservation?.status ?? 'pending';

    // If reservation status is pending, show the routing/navigation, "Saya Sudah Sampai", "Ganti Slot", and "Batalkan Reservasi"
    if (_activeReservation != null && reservationStatus == 'pending') {
      return _buildPendingReservationView(slotName, areaName);
    }

    return _buildActiveOrArrivedView(slotName, areaName, displayVehicleType);
  }

  Widget _buildPendingReservationView(String slotName, String areaName) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Menunggu Kedatangan',
            style: TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Panduan menuju slot parkir (route map)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Panduan Menuju Slot Parkir Anda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ikuti petunjuk arah di bawah ini untuk mencapai slot.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'lib/assets/denah_pesan_park.png',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: const Color(0xFF132136),
                          child: const Center(
                            child: Icon(Icons.map_outlined, color: Colors.white38, size: 48),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Reservation Info Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox(
                        'Lokasi Parkir',
                        areaName.isNotEmpty ? areaName : '—',
                        icon: Icons.location_on_outlined,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoBox(
                        'Slot Parkir',
                        slotName.isNotEmpty ? slotName : '—',
                        icon: Icons.local_parking_rounded,
                        fontSize: 20,
                        isHighlighted: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_plateNumber.isNotEmpty)
                  _buildInfoBox(
                    'Kendaraan / Plat Nomor',
                    '$_vehicleType - $_plateNumber'.toUpperCase(),
                    icon: Icons.badge_outlined,
                    fontSize: 15,
                    fullWidth: true,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // 1. Saya Sudah Sampai button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isArriving ? null : _onArriveAtSlot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isArriving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Saya Sudah Sampai',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Ganti Slot button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _isSwapping ? null : _showSwapSlotDialog,
                    icon: const Icon(Icons.swap_horiz_rounded, size: 20, color: AppColors.accent),
                    label: const Text(
                      'Ganti Slot Parkir',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Batalkan Reservasi button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton.icon(
                    onPressed: _isCancelling ? null : _onKeluarParkir,
                    icon: const Icon(Icons.cancel_outlined, size: 20, color: Colors.redAccent),
                    label: const Text(
                      'Batalkan Reservasi',
                      style: TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Colors.redAccent, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _onArriveAtSlot() async {
    if (_activeReservation == null) return;
    setState(() => _isArriving = true);

    final service = BookingService();
    final result = await service.arriveReservation(_activeReservation!.reservationId);

    if (!mounted) return;
    setState(() => _isArriving = false);

    if (result.success) {
      // Update local reservation status to active
      final updatedRes = ActiveReservation(
        reservationId: _activeReservation!.reservationId,
        status: 'active',
        slotId: _activeReservation!.slotId,
        slotName: _activeReservation!.slotName,
        areaId: _activeReservation!.areaId,
        ticketId: _activeReservation!.ticketId,
        startTime: DateTime.now().toIso8601String(), // Start timer from arrival timestamp
      );
      await ActiveReservationStorage().save(updatedRes);

      // Show success notification dialog
      _showArriveSuccessDialog(_activeReservation!.slotName);

      // Reload
      await _loadAllData();
    } else {
      _showErrorDialog(result.message);
    }
  }

  void _showArriveSuccessDialog(String slotName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0D2040),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/assets/notifikasi_aktif.png',
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aktivasi Berhasil!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Selamat, Anda sudah berhasil mengaktifkan slot parkir $slotName.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSwapSlotDialog() async {
    if (_activeReservation == null) return;

    setState(() => _isSwapping = true);

    final bookingService = BookingService();
    final allSlots = await bookingService.getSlots(_activeReservation!.areaId);

    if (!mounted) return;
    setState(() => _isSwapping = false);

    // Filter available slots
    final availableSlots = allSlots.where((s) => s.status.toLowerCase() == 'available' && s.id != _activeReservation!.slotId).toList();

    if (availableSlots.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: const Text('Ganti Slot', style: TextStyle(color: Colors.white)),
          content: const Text('Maaf, tidak ada slot parkir kosong lain yang tersedia saat ini.', style: TextStyle(color: AppColors.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup', style: TextStyle(color: AppColors.accent)),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        ParkingSlot? selectedSlot;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0D2040),
              title: const Text(
                'Pilih Slot Baru',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'lib/assets/popup_book.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Silakan pilih salah satu slot parkir kosong di bawah ini:',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<ParkingSlot>(
                          dropdownColor: const Color(0xFF0D2040),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            border: InputBorder.none,
                          ),
                          hint: const Text('Pilih Slot', style: TextStyle(color: Colors.white30)),
                          value: selectedSlot,
                          items: availableSlots.map((slot) {
                            return DropdownMenuItem<ParkingSlot>(
                              value: slot,
                              child: Text(
                                slot.slotNumber,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setDialogState(() {
                              selectedSlot = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: selectedSlot == null
                      ? null
                      : () {
                          Navigator.pop(ctx);
                          _onSwapSlot(selectedSlot!.id, selectedSlot!.slotNumber);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                  child: const Text('Ganti Slot', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _onSwapSlot(String newSlotId, String newSlotName) async {
    if (_activeReservation == null) return;

    setState(() => _isSwapping = true);

    final service = BookingService();
    final result = await service.swapReservation(_activeReservation!.reservationId, newSlotId);

    if (!mounted) return;
    setState(() => _isSwapping = false);

    if (result.success) {
      // Update local reservation details
      final updatedRes = ActiveReservation(
        reservationId: _activeReservation!.reservationId,
        status: _activeReservation!.status,
        slotId: newSlotId,
        slotName: newSlotName,
        areaId: _activeReservation!.areaId,
        ticketId: _activeReservation!.ticketId,
        startTime: _activeReservation!.startTime,
      );
      await ActiveReservationStorage().save(updatedRes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil ganti slot ke $newSlotName!'),
          backgroundColor: Colors.green,
        ),
      );

      await _loadAllData();
    } else {
      _showErrorDialog(result.message);
    }
  }

  Widget _buildActiveOrArrivedView(String slotName, String areaName, String displayVehicleType) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Header
          const Text(
            'Kendaraan Berada di Tempat',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Vehicle type
          Text(
            displayVehicleType,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Plate number
          if (_plateNumber.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(
                _plateNumber,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Car with glow ring
          AnimatedBuilder(
            animation: _glowAnim,
            builder: (context, _) {
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent.withOpacity(_glowAnim.value),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(_glowAnim.value * 0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.directions_car_filled,
                    color: Colors.white70,
                    size: 100,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 28),

          // Info grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Row 1: Plat Nomor + Tipe Kendaraan
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox(
                        'Plat Nomor',
                        _plateNumber.isNotEmpty ? _plateNumber : '—',
                        icon: Icons.badge_outlined,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoBox(
                        'Tipe Kendaraan',
                        displayVehicleType,
                        icon: Icons.directions_car_outlined,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Row 2: Lokasi Parkir + Slot
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox(
                        'Lokasi Parkir',
                        areaName.isNotEmpty ? areaName : '—',
                        icon: Icons.location_on_outlined,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoBox(
                        'Slot Parkir',
                        slotName.isNotEmpty ? slotName : '—',
                        icon: Icons.local_parking_rounded,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Row 3: Durasi Parkir (full width)
                _buildInfoBox(
                  'Durasi Parkir',
                  _formatTime(_elapsedSeconds),
                  icon: Icons.timer_outlined,
                  fontSize: 28,
                  fullWidth: true,
                  isHighlighted: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Keluar button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isCancelling ? null : _onKeluarParkir,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isCancelling
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Selesai Parkir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoBox(
    String label,
    String value, {
    required double fontSize,
    IconData? icon,
    bool fullWidth = false,
    bool isHighlighted = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.accent.withOpacity(0.08)
            : AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlighted
              ? AppColors.accent.withOpacity(0.3)
              : AppColors.borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.textSecondary, size: 14),
                const SizedBox(width: 6),
              ],
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                color: isHighlighted ? AppColors.accent : Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
