import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../styles/app_colors.dart';
import '../styles/theme_provider.dart';

/// Widget shared: Header halaman dengan avatar, nama user, greeting,
/// tombol sakelar Tema (Light/Dark Mode), dan tombol notifikasi.
class UserHeaderWidget extends StatelessWidget {
  final String name;
  final String greeting;
  final String? photoUrl;
  final String title;
  final VoidCallback? onNotificationTap;

  const UserHeaderWidget({
    super.key,
    required this.name,
    required this.greeting,
    this.title = 'Beranda',
    this.photoUrl,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppColors.getCardBg(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);
    final borderColor = AppColors.getBorderColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBg2Dark : const Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: photoUrl != null && photoUrl!.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: photoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF2563EB),
                        size: 24,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF2563EB),
                    size: 24,
                  ),
          ),
          const SizedBox(width: 12),

          // Title / Name & Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isNotEmpty ? title : name,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (greeting.isNotEmpty)
                  Text(
                    greeting,
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          // Theme Toggle Icon
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: isDark ? Colors.amber : const Color(0xFF2563EB),
              size: 22,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme(!isDark);
            },
            tooltip: isDark ? 'Mode Terang' : 'Mode Gelap',
          ),

          // Notification Bell Icon
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF2563EB),
              size: 24,
            ),
            onPressed: onNotificationTap ?? () {},
            tooltip: 'Notifikasi',
          ),
        ],
      ),
    );
  }
}
