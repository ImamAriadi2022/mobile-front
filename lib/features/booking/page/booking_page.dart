import 'package:flutter/material.dart';

import '../widget/booking_widget.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: const SafeArea(
        child: BookingWidget(),
      ),
    );
  }
}
