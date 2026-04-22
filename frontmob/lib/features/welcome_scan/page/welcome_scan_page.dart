import 'package:flutter/material.dart';

import '../widget/welcome_scan_widget.dart';

class WelcomeScanPage extends StatelessWidget {
  const WelcomeScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wellcome Scan')),
      body: const SafeArea(
        child: WelcomeScanWidget(),
      ),
    );
  }
}
