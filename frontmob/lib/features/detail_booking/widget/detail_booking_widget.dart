import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class DetailBookingWidget extends StatelessWidget {
  const DetailBookingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kode Booking: BK-2026-001',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('Lokasi: Cabang A'),
          const Text('Tanggal: 22 April 2026'),
          const Text('Jam: 10:00 - 11:00'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.history);
            },
            child: const Text('Lihat History'),
          ),
        ],
      ),
    );
  }
}
