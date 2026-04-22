import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class AnimasiScanWidget extends StatelessWidget {
  const AnimasiScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.radar, size: 90),
          const SizedBox(height: 20),
          const LinearProgressIndicator(minHeight: 10),
          const SizedBox(height: 16),
          const Text('Animasi scan sedang berjalan...'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.halamanScan);
            },
            child: const Text('Selesai Animasi'),
          ),
        ],
      ),
    );
  }
}
