import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class WelcomeScanWidget extends StatelessWidget {
  const WelcomeScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.qr_code_scanner, size: 72),
          const SizedBox(height: 16),
          Text(
            'Mulai fitur scan',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Halaman ini sebagai pengantar sebelum proses animasi scan.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.animasiScan);
            },
            child: const Text('Lanjut ke Animasi Scan'),
          ),
        ],
      ),
    );
  }
}
