import 'package:flutter/material.dart';

import '../features/animasi_scan/page/animasi_scan_page.dart';
import '../features/booking/page/booking_page.dart';
import '../features/detail_booking/page/detail_booking_page.dart';
import '../features/halaman_scan/page/halaman_scan_page.dart';
import '../features/history/page/history_page.dart';
import '../features/home/page/home_page.dart';
import '../features/login/page/login_page.dart';
import '../features/profil/page/profil_page.dart';
import '../features/register/page/register_page.dart';
import '../features/scan_berhasil/page/scan_berhasil_page.dart';
import '../features/splash_screen/page/splash_screen_page.dart';
import '../features/tutor_popup/page/tutor_popup_page.dart';
import '../features/welcome/page/welcome_page.dart';
import '../features/welcome_scan/page/welcome_scan_page.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String welcomeScan = '/welcome-scan';
  static const String animasiScan = '/animasi-scan';
  static const String halamanScan = '/halaman-scan';
  static const String scanBerhasil = '/scan-berhasil';
  static const String home = '/home';
  static const String tutorPopup = '/tutor-popup';
  static const String booking = '/booking';
  static const String detailBooking = '/detail-booking';
  static const String history = '/history';
  static const String profil = '/profil';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreenPage());
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.welcomeScan:
        return MaterialPageRoute(builder: (_) => const WelcomeScanPage());
      case AppRoutes.animasiScan:
        return MaterialPageRoute(builder: (_) => const AnimasiScanPage());
      case AppRoutes.halamanScan:
        return MaterialPageRoute(builder: (_) => const HalamanScanPage());
      case AppRoutes.scanBerhasil:
        return MaterialPageRoute(builder: (_) => const ScanBerhasilPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.tutorPopup:
        return MaterialPageRoute(builder: (_) => const TutorPopupPage());
      case AppRoutes.booking:
        return MaterialPageRoute(builder: (_) => const BookingPage());
      case AppRoutes.detailBooking:
        return MaterialPageRoute(builder: (_) => const DetailBookingPage());
      case AppRoutes.history:
        return MaterialPageRoute(builder: (_) => const HistoryPage());
      case AppRoutes.profil:
        return MaterialPageRoute(builder: (_) => const ProfilPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan')),
          ),
        );
    }
  }
}
