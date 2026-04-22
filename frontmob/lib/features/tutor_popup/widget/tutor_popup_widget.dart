import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';

class TutorPopupWidget extends StatelessWidget {
  const TutorPopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Coba tampilkan pop up tutorial sederhana di sini.',
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Tutorial Singkat'),
                    content: const Text(
                      '1. Pilih menu scan.\n2. Arahkan kamera ke objek.\n3. Simpan hasilnya.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Tampilkan Pop Up'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.booking);
            },
            child: const Text('Lanjut ke Booking'),
          ),
        ],
      ),
    );
  }
}
