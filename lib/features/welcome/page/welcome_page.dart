import 'package:flutter/material.dart';

import '../widget/welcome_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wellcome')),
      body: const SafeArea(
        child: WelcomeWidget(),
      ),
    );
  }
}
