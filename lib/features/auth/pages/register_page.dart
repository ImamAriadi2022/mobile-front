import 'package:flutter/material.dart';
import '../widgets/register_widget.dart';

/// RegisterPage — Wrapper halaman untuk RegisterWidget.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D1628),
      body: RegisterWidget(),
    );
  }
}
