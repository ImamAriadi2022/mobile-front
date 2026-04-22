import 'package:flutter/material.dart';

import '../widget/scan_berhasil_widget.dart';

class ScanBerhasilPage extends StatelessWidget {
  const ScanBerhasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Berhasil')),
      body: const SafeArea(
        child: ScanBerhasilWidget(),
      ),
    );
  }
}
