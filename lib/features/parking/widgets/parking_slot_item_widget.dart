import 'package:flutter/material.dart';
import '../../../shared/styles/app_colors.dart';

enum SlotStatus { alatRusak, kosong, terisi, terpesan, pemeliharaan }

extension SlotStatusExtension on SlotStatus {
  Color get bgColor {
    switch (this) {
      case SlotStatus.kosong:
        return const Color(0xFF22C55E); // Green
      case SlotStatus.terisi:
        return const Color(0xFFDC2626); // Red
      case SlotStatus.terpesan:
        return const Color(0xFFEA580C); // Orange
      case SlotStatus.pemeliharaan:
      case SlotStatus.alatRusak:
        return const Color(0xFFE2E8F0); // Light Grey
    }
  }

  Color get textColor {
    switch (this) {
      case SlotStatus.kosong:
      case SlotStatus.terisi:
      case SlotStatus.terpesan:
        return Colors.white;
      case SlotStatus.pemeliharaan:
      case SlotStatus.alatRusak:
        return const Color(0xFF475569);
    }
  }

  String get label {
    switch (this) {
      case SlotStatus.alatRusak:
        return 'Alat Rusak';
      case SlotStatus.kosong:
        return 'Tersedia';
      case SlotStatus.terisi:
        return 'Terisi';
      case SlotStatus.terpesan:
        return 'Terpesan';
      case SlotStatus.pemeliharaan:
        return 'Pemeliharaan';
    }
  }
}

class ParkingSlotData {
  final String? id;
  final String label;
  final SlotStatus status;

  const ParkingSlotData({this.id, required this.label, required this.status});
}

class ParkingSlotItemWidget extends StatelessWidget {
  final ParkingSlotData slot;
  final bool showIconOnLeft;
  final bool isSelected;
  final VoidCallback? onTap;

  const ParkingSlotItemWidget({
    super.key,
    required this.slot,
    this.showIconOnLeft = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = slot.status.bgColor;
    final textCol = slot.status.textColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 64,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: Colors.white, width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: bg.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: slot.status == SlotStatus.pemeliharaan || slot.status == SlotStatus.alatRusak
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.build_rounded, size: 16, color: Color(0xFF475569)),
                    const SizedBox(height: 2),
                    Text(
                      slot.label,
                      style: TextStyle(
                        color: textCol,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : Text(
                  slot.label,
                  style: TextStyle(
                    color: textCol,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }
}
