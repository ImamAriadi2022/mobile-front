import 'package:flutter/material.dart';

import '../widget/login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const SafeArea(
        child: LoginWidget(),
      ),
    );
  }
}
