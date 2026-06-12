import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/storage/active_ticket_storage.dart';
import '../../../core/storage/active_reservation_storage.dart';
import '../../public_widget/bottom_nav_bar.dart';
import '../../../app/app_routes.dart';
import '../../access/service/access_service.dart';
import '../../welcome_scan/service/scan_service.dart';
import '../service/parking_service.dart';

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

  int _seconds = 0;
  Timer? _timer;
  TicketData? _activeTicket;
  ActiveReservation? _activeReservation;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _loadActiveTicket();
    _loadActiveReservation();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  Future<void> _loadActiveTicket() async {
    final accessService = AccessService();
    final apiTicket = await accessService.getActiveTicket();
    if (apiTicket != null) {
      await ActiveTicketStorage().save(apiTicket);
    }
    final ticket = await ActiveTicketStorage().load();
    if (mounted) setState(() => _activeTicket = ticket);
  }

  Future<void> _loadActiveReservation() async {
    final reservation = await ActiveReservationStorage().load();
    if (mounted) setState(() => _activeReservation = reservation);
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
    return '${h.toString().padLeft(2, '0')} : ${m.toString().padLeft(2, '0')} : ${s.toString().padLeft(2, '0')} Detik';
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
    setState(() => _isCancelling = true);

    final service = ParkingService();
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
      await ActiveTicketStorage().clear();
      await ActiveReservationStorage().clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: const Text('Gagal', style: TextStyle(color: Colors.white)),
          content: Text(result.message, style: const TextStyle(color: AppColors.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup', style: TextStyle(color: AppColors.accent)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Kendaraan Berada di Tempat',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _activeTicket?.vehicleType.toUpperCase() ?? 'KENDARAAN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _activeTicket?.areaName ?? '—',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // Car with glow ring
                  AnimatedBuilder(
                    animation: _glowAnim,
                    builder: (context, _) {
                      return Container(
                        width: 200,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accent
                                .withOpacity(_glowAnim.value),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent
                                  .withOpacity(_glowAnim.value * 0.4),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_car_filled,
                            color: Colors.white70,
                            size: 120,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Info grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoBox(
                                  'Lokasi Parkir',
                                  _activeTicket?.areaName ?? '—',
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildInfoBox(
                                  'Tipe Kendaraan',
                                  _activeTicket?.vehicleType.toUpperCase() ?? '—',
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        _buildInfoBox(
                          'Waktu yang dihabiskan',
                          _formatTime(_seconds),
                          fontSize: 22,
                          fullWidth: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

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
                                'Keluar Parkir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value,
      {required double fontSize, bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
