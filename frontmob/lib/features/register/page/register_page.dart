import 'package:flutter/material.dart';

import '../widget/register_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const SafeArea(
        child: RegisterWidget(),
      ),
    );
  }
}
