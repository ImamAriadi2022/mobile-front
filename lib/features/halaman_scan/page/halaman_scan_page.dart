import 'package:flutter/material.dart';

import '../widget/halaman_scan_widget.dart';

class HalamanScanPage extends StatelessWidget {
  const HalamanScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Scan')),
      body: const SafeArea(
        child: HalamanScanWidget(),
      ),
    );
  }
}
