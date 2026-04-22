import 'package:flutter/material.dart';

import '../widget/tutor_popup_widget.dart';

class TutorPopupPage extends StatelessWidget {
  const TutorPopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutor Pop Up')),
      body: const SafeArea(
        child: TutorPopupWidget(),
      ),
    );
  }
}
