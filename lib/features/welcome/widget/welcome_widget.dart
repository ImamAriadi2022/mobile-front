import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({super.key});

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

// CDN base for remote assets used by welcome page
const String _cdnBaseUrl = 'https://storage.googleapis.com/parkfinderbucket';

class _WelcomeWidgetState extends State<WelcomeWidget> {
  bool _isDark = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Top image area – parking building illustration
        SizedBox(
          height: size.height * 0.62,
          width: double.infinity,
          child: _isDark
              ? _buildDarkParkingIllustration()
              : _buildLightParkingIllustration(),
        ),

        // Bottom content area
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            decoration: BoxDecoration(
              color: _isDark ? const Color(0xFF1A2D6B) : const Color(0xFF1A2D6B),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'ParkFinder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Temukan Slot Parkir Anda dengan Cepat.',
                  style: TextStyle(
                    color: Color(0xFFB0BEC5),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Mulai',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Theme toggle top right
        Positioned(
          top: 48,
          right: 16,
          child: GestureDetector(
            onTap: () => setState(() => _isDark = !_isDark),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isDark ? 'Terang' : 'Gelap',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _isDark ? Icons.wb_sunny : Icons.nightlight_round,
                    color: Colors.amber,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDarkParkingIllustration() {
    final imageUrl = '$_cdnBaseUrl/background/bg-wellcome-dark.png';
    return _buildNetworkBackground(
      imageUrl: imageUrl,
      fallbackGradient: const LinearGradient(
        colors: [Color(0xFF2C3E6B), Color(0xFF0D1628)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildLightParkingIllustration() {
    final imageUrl = '$_cdnBaseUrl/background/bg-wellcome-light.png';
    return _buildNetworkBackground(
      imageUrl: imageUrl,
      fallbackGradient: const LinearGradient(
        colors: [Color(0xFF87CEEB), Color(0xFFB0D9F5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildNetworkBackground({
    required String imageUrl,
    required LinearGradient fallbackGradient,
  }) {
    return SizedBox.expand(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            decoration: BoxDecoration(gradient: fallbackGradient),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white54,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(gradient: fallbackGradient),
          );
        },
      ),
    );
  }

}
