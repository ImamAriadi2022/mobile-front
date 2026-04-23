import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({super.key});

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

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
    return Container(
      color: const Color(0xFF1A2840),
      child: Stack(
        children: [
          // Sky gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2C3E6B), Color(0xFF0D1628)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Parking building layers
          Center(child: _buildParkingBuilding(isDark: true)),
        ],
      ),
    );
  }

  Widget _buildLightParkingIllustration() {
    return Container(
      color: const Color(0xFF87CEEB),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF87CEEB), Color(0xFFB0D9F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(child: _buildParkingBuilding(isDark: false)),
        ],
      ),
    );
  }

  Widget _buildParkingBuilding({required bool isDark}) {
    final Color mainBg = isDark ? const Color(0xFF1B3A5C) : const Color(0xFF4ECDC4);
    final Color floorBg = isDark ? const Color(0xFF0D2035) : const Color(0xFF3BB5AC);
    final Color signBg = const Color(0xFF1565C0);
    final Color accentColor = isDark ? const Color(0xFF00D2FF) : const Color(0xFF26C6DA);

    return SizedBox(
      width: 340,
      height: 440,
      child: Stack(
        children: [
          // Main building body
          Positioned(
            left: 20,
            top: 40,
            child: Container(
              width: 80,
              height: 380,
              decoration: BoxDecoration(
                color: mainBg,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4)),
              ),
              child: Column(
                children: List.generate(
                  7,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 24,
                            color: accentColor.withOpacity(0.3),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 24,
                            color: accentColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Parking sign on building
          Positioned(
            left: 36,
            top: 50,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: signBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Multi-floor ramp structure
          Positioned(
            right: 0,
            top: 80,
            child: Column(
              children: [
                _buildParkingFloor(floorBg, accentColor, 'PARKFINDER: 125 SPACES AVA', true),
                const SizedBox(height: 4),
                _buildParkingFloor(floorBg, accentColor, 'PARKFINDER: 125 SPACES AVA', false),
              ],
            ),
          ),

          // Ground floor cars
          Positioned(
            bottom: 20,
            left: 100,
            child: Row(
              children: [
                _buildCarShape(const Color(0xFF26C6DA)),
                const SizedBox(width: 12),
                _buildCarShape(const Color(0xFFFFA726)),
              ],
            ),
          ),

          // Ground
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 18,
              color: isDark ? const Color(0xFF0A1520) : const Color(0xFF78909C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingFloor(Color bg, Color accent, String text, bool hasGreen) {
    return Container(
      width: 230,
      height: 90,
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(color: accent.withOpacity(0.4), width: 2),
          bottom: BorderSide(color: accent.withOpacity(0.4), width: 2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (hasGreen)
                Container(width: 28, height: 8, color: Colors.green[400]),
              Container(width: 28, height: 8, color: Colors.green[300]),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            color: const Color(0xFF0D1E35),
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF00D2FF),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Car silhouette
          _buildCarShape(const Color(0xFFB0BEC5), small: true),
        ],
      ),
    );
  }

  Widget _buildCarShape(Color color, {bool small = false}) {
    final double scale = small ? 0.6 : 1.0;
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 60,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 4,
              left: 8,
              right: 8,
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
