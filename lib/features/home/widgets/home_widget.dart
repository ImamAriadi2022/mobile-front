import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_front/core/routes/app_routes.dart';
import '../../../shared/styles/app_colors.dart';
import '../../../shared/styles/app_text_styles.dart';
import '../../../core/storage/active_ticket_storage.dart';
import '../../../core/storage/active_reservation_storage.dart';
import 'package:mobile_front/features/scan/models/ticket_data.dart';
import 'package:mobile_front/features/scan/services/scan_service.dart';
import 'package:mobile_front/features/parking/services/booking_service.dart';
import 'package:mobile_front/features/profile/services/profile_service.dart';
import 'package:mobile_front/shared/widgets/shared_widgets.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _navIndex = 0;
  bool _isLoading = true;
  String? _error;
  List<ParkingItemData> _parkingList = [];
  String _userName = 'User';
  String _greeting = 'Selamat Datang';
  String? _photoUrl;

  bool _hasActiveTicket = false;
  TicketData? _activeTicket;
  ActiveReservation? _activeReservation;

  @override
  void initState() {
    super.initState();
    _fetchAreas();
    _loadProfile();
    _checkActiveTicket();
  }

  Future<void> _checkActiveTicket() async {
    var ticket = await ActiveTicketStorage().load();
    var reservation = await ActiveReservationStorage().load();
    if (mounted) {
      setState(() {
        _activeTicket = ticket;
        _hasActiveTicket = ticket != null &&
            ticket.ticketCode.isNotEmpty &&
            (ticket.status == 'active' || ticket.status == 'claimed');
        _activeReservation = reservation;
      });
    }

    final accessService = AccessService();
    final apiTicket = await accessService.getActiveTicket();
    if (apiTicket != null) {
      await ActiveTicketStorage().save(apiTicket);
    }

    ticket = await ActiveTicketStorage().load();
    reservation = await ActiveReservationStorage().load();
    if (mounted) {
      setState(() {
        _activeTicket = ticket;
        _hasActiveTicket = ticket != null &&
            ticket.ticketCode.isNotEmpty &&
            (ticket.status == 'active' || ticket.status == 'claimed');
        _activeReservation = reservation;
      });
    }
  }

  void _loadProfile() {
    ProfileService().getProfile().then((profile) {
      if (!mounted) return;
      if (profile != null) {
        setState(() {
          _userName = profile.name;
          _photoUrl = profile.photoUrl;
        });
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
          availableSlotLabel: '$available Slot Kosong',
        );
      }).toList();
      _isLoading = false;
    });
  }

  void _onNavTap(int idx) {
    setState(() => _navIndex = idx);
    switch (idx) {
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.booking)
            .then((_) => _checkActiveTicket());
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
    final textPrimary = AppColors.getTextPrimary(context);

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
                    // ① User Header Bar
                    UserHeaderWidget(
                      name: _userName,
                      greeting: '',
                      title: 'Beranda',
                      photoUrl: _photoUrl,
                    ),
                    const SizedBox(height: 16),

                    // ② Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SearchBarWidget(
                        hintText: 'Cari Gedung Parkir',
                        readOnly: true,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.booking)
                              .then((_) => _checkActiveTicket());
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ③ Section 1: Parkir Aktif
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Parkir Aktif',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Banner Card Parkir Aktif
                    _buildActiveParkingBanner(isDark),
                    const SizedBox(height: 24),

                    // ④ Section 2: Gedung Parkir Header Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gedung Parkir',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.booking);
                            },
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Daftar Gedung Parkir Cards
                    _buildBuildingCards(isDark),
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

  void _showQrCodeDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppColors.getCardBg(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);

    final ticketCode = _activeTicket?.ticketCode ?? 'TCK-8891234';
    final slotName = _activeReservation?.slotName ?? 'A-12';
    final areaName = _activeTicket?.areaName ?? 'Gedung Teknik Elektro';

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'QR Ticket Masuk',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBg2Dark : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  'lib/assets/scan/qr_scanner.png',
                  height: 180,
                  width: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.qr_code_2_rounded,
                    size: 160,
                    color: Color(0xFF061E3D),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                ticketCode,
                style: const TextStyle(
                  color: Color(0xFFF97316),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$areaName • Slot $slotName',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushNamed(context, AppRoutes.statusKendaraan);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF03192E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Lihat Status Sesi Aktif',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveParkingBanner(bool isDark) {
    final slotName = _activeReservation?.slotName ?? 'A-12';
    final areaName = _activeTicket?.areaName ?? 'GEDUNG TEKNIK ELEKTRO';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF061E3D),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF061E3D).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row: P badge + Area Name
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    areaName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Big Slot Title
            Text(
              _hasActiveTicket ? 'Slot $slotName • Lantai 1' : 'Slot Belum Dipilih',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),

            // Subtitle info
            Text(
              _hasActiveTicket
                  ? 'Masuk: 10:15 WIB (Durasi: 01j 45m)'
                  : 'Silakan lakukan booking slot parkir terlebih dahulu.',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),

            // Orange Button: Tampilkan QR
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_hasActiveTicket) {
                    _showQrCodeDialog(context);
                  } else {
                    Navigator.pushNamed(context, AppRoutes.welcomeScan);
                  }
                },
                icon: Icon(
                  _hasActiveTicket ? Icons.qr_code_2_rounded : Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  _hasActiveTicket ? 'Tampilkan QR' : 'Scan Tiket Parkir',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF97316),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuildingCards(bool isDark) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_parkingList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBgDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderColorDark : AppColors.borderColorLight),
          ),
          child: Center(
            child: Text(
              'Belum ada gedung parkir.',
              style: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondaryLight),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _parkingList.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isAvailable = item.occupancyPercent < 100;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBgDark : Colors.white,
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
                ).then((_) => _checkActiveTicket());
              },
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Header
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: Image.asset(
                        index == 0
                            ? 'lib/assets/home/dashboard_parkir.png'
                            : 'lib/assets/parking/denah_parkir.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(Icons.apartment_rounded, size: 60, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                  ),

                  // Building Info Padding
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.availableSlotLabel,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),

                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isAvailable ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isAvailable ? 'TERSEDIA' : 'PENUH',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isAvailable ? const Color(0xFF059669) : const Color(0xFFDC2626),
                            ),
                          ),
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
    );
  }
}
