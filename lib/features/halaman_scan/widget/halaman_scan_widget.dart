import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class HalamanScanWidget extends StatelessWidget {
  const HalamanScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: const Center(
              child: Text('Area kamera / scan'),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.scanBerhasil);
            },
            child: const Text('Scan Sekarang'),
          ),
        ],
      ),
    );
  }
}
