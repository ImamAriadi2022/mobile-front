import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class BookingWidget extends StatelessWidget {
  const BookingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Booking Cabang A'),
          subtitle: Text('Jam 10:00 - 11:00'),
        ),
        const ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Booking Cabang B'),
          subtitle: Text('Jam 13:00 - 14:00'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.detailBooking);
          },
          child: const Text('Lihat Detail Booking'),
        ),
      ],
    );
  }
}
