import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/page/home_page.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  static const String _cdnBaseUrl = 'https://storage.googleapis.com/parkfinderbucket';
  static const String _logoPath = '/foto/logo.png';

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const HomePage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CachedNetworkImage(
            imageUrl: '$_cdnBaseUrl$_logoPath',
            width: 250,
            fit: BoxFit.contain,
            placeholder: (context, url) => SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accent.withOpacity(0.25),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error_outline_rounded,
              color: AppColors.accent,
              size: 44,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: Center(
            child: GestureDetector(
              onTap: () => _goToHome(context),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: AppColors.accent,
                  size: 34,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
