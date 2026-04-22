import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class ProfilWidget extends StatelessWidget {
  const ProfilWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 12),
          Text('Nama Pengguna', style: Theme.of(context).textTheme.titleLarge),
          const Text('user@email.com'),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Pengaturan Akun'),
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privasi'),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
            child: const Text('Kembali ke Home'),
          ),
        ],
      ),
    );
  }
}
