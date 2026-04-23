import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../public_widget/bottom_nav_bar.dart';

class BookingWidget extends StatefulWidget {
  const BookingWidget({super.key});

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  final _searchCtrl = TextEditingController();
  int _navIndex = 1;

  final List<Map<String, dynamic>> _allParking = [
    {'name': 'Jurusan Teknik Elektro Universitas Lampung', 'pct': 78.0, 'kosong': '4/5 Kosong'},
    {'name': 'Mall Boemi Kedaton', 'pct': 81.0, 'kosong': '635/1384 Kosong'},
    {'name': 'Jurusan Teknik Elektro Universitas Lampung', 'pct': 78.0, 'kosong': '4/5 Kosong'},
    {'name': 'Lampung City Mall', 'pct': 81.0, 'kosong': '635/1384 Kosong'},
    {'name': 'Jurusan Teknik Elektro Universitas Lampung', 'pct': 78.0, 'kosong': '4/5 Kosong'},
    {'name': 'Lampung City Mall', 'pct': 81.0, 'kosong': '635/1384 Kosong'},
    {'name': 'Mall Boemi Kedaton', 'pct': 81.0, 'kosong': '635/1384 Kosong'},
    {'name': 'Mall Boemi Kedaton', 'pct': 81.0, 'kosong': '635/1384 Kosong'},
    {'name': 'Jurusan Teknik Elektro Universitas Lampung', 'pct': 78.0, 'kosong': '4/5 Kosong'},
    {'name': 'Lampung City Mall', 'pct': 81.0, 'kosong': '635/1384 Kosong'},
    {'name': 'Lampung City Mall', 'pct': 81.0, 'kosong': '635/1384 Kosong'},
    {'name': 'Jurusan Teknik Elektro Universitas Lampung', 'pct': 78.0, 'kosong': '4/5 Kosong'},
    {'name': 'Jurusan Teknik Elektro Universitas Lampung', 'pct': 78.0, 'kosong': '4/5 Kosong'},
    {'name': 'Mall Boemi Kedaton', 'pct': 81.0, 'kosong': '635/1384 Kosong'},
    {'name': 'Jurusan Teknik Elektro Universitas Lampung', 'pct': 78.0, 'kosong': '4/5 Kosong'},
    {'name': 'Jurusan Teknik Elektro Universitas Lampung', 'pct': 78.0, 'kosong': '4/5 Kosong'},
  ];

  List<Map<String, dynamic>> get _filtered {
    final q = _searchCtrl.text.toLowerCase();
    if (q.isEmpty) return _allParking;
    return _allParking
        .where((e) => (e['name'] as String).toLowerCase().contains(q))
        .toList();
  }

  void _onNavTap(int idx) {
    setState(() => _navIndex = idx);
    switch (idx) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.history);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.profil);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Carilah Tempat parkir anda',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          color: Colors.white70, size: 20),
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari Gedung Parkir',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textSecondary, size: 20),
                    filled: true,
                    fillColor: AppColors.cardBg,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: AppColors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: AppColors.accent, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filtered.length,
                  itemBuilder: (context, i) {
                    final item = _filtered[i];
                    return GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.detailBooking),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: AppColors.borderColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: AppColors.accent, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: item['pct'] / 100,
                                      backgroundColor:
                                          AppColors.borderColor,
                                      color: AppColors.accent,
                                      minHeight: 5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${item['pct'].toInt()}%',
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['kosong'],
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 9),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
      ],
    );
  }
}
