import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Halo!', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Silakan login atau daftar untuk melanjutkan.'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.login);
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.register);
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
