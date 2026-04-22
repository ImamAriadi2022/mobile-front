import 'package:flutter/material.dart';

import '../widget/detail_booking_widget.dart';

class DetailBookingPage extends StatelessWidget {
  const DetailBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Booking')),
      body: const SafeArea(
        child: DetailBookingWidget(),
      ),
    );
  }
}
