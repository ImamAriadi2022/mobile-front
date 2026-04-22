import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mobile_friendly, size: 72),
            const SizedBox(height: 16),
            Text(
              'Splash Screen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Selamat datang di aplikasi front mobile modular.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.welcome);
              },
              child: const Text('Mulai'),
            ),
          ],
        ),
      ),
    );
  }
}
