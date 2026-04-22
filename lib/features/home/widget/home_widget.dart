import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _MenuCard(
            title: 'Booking',
            icon: Icons.calendar_month,
            onTap: () => Navigator.pushNamed(context, AppRoutes.booking),
          ),
          _MenuCard(
            title: 'History',
            icon: Icons.history,
            onTap: () => Navigator.pushNamed(context, AppRoutes.history),
          ),
          _MenuCard(
            title: 'Profil',
            icon: Icons.person,
            onTap: () => Navigator.pushNamed(context, AppRoutes.profil),
          ),
          _MenuCard(
            title: 'Tutor Pop Up',
            icon: Icons.help_center,
            onTap: () => Navigator.pushNamed(context, AppRoutes.tutorPopup),
          ),
          _MenuCard(
            title: 'Scan Ulang',
            icon: Icons.qr_code,
            onTap: () => Navigator.pushNamed(context, AppRoutes.welcomeScan),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
