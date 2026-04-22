import 'package:flutter/material.dart';

import '../widget/profil_widget.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: const SafeArea(
        child: ProfilWidget(),
      ),
    );
  }
}
