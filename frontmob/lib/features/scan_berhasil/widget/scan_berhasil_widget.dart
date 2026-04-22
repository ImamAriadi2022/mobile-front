import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class ScanBerhasilWidget extends StatelessWidget {
  const ScanBerhasilWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 90),
            const SizedBox(height: 16),
            Text(
              'Scan Berhasil!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Data berhasil terbaca dan disimpan.'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              },
              child: const Text('Ke Home'),
            ),
          ],
        ),
      ),
    );
  }
}
