import 'package:flutter/material.dart';

import '../widget/history_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const SafeArea(
        child: HistoryWidget(),
      ),
    );
  }
}
