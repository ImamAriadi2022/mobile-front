import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: const Text('Booking selesai - Cabang A'),
            subtitle: const Text('20 April 2026'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: const Text('Booking selesai - Cabang B'),
            subtitle: const Text('18 April 2026'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.profil);
          },
          child: const Text('Ke Profil'),
        ),
      ],
    );
  }
}
