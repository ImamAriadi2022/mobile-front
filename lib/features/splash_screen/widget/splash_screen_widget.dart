import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.5)),
    );
    _bounceAnim = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToWelcome() {
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          _goToWelcome();
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF0F4F8),
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Logo
            Column(
              children: [
                // Parking icon illustration
                SizedBox(
                  width: 140,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Road
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 140,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3A3A3A),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                        ),
                      ),
                      // Buildings
                      Positioned(
                        left: 8,
                        bottom: 22,
                        child: _buildBuilding(18, 60, const Color(0xFF9E9E9E)),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 22,
                        child: _buildBuilding(18, 60, const Color(0xFF9E9E9E)),
                      ),
                      // Parking sign
                      Positioned(
                        bottom: 20,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'P',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Location pin (green)
                      Positioned(
                        top: 0,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E7D32),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.circle,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // ParkFinder text
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Park',
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      TextSpan(
                        text: 'Finder',
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(flex: 3),
            // Swipe up button
            AnimatedBuilder(
              animation: _bounceAnim,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnim.value),
                  child: GestureDetector(
                    onTap: _goToWelcome,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1565C0),
                          width: 2,
                        ),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: Color(0xFF1565C0),
                        size: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBuilding(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(3)),
      ),
      child: Column(
        children: List.generate(
          4,
          (i) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: 5, height: 7, color: Colors.lightBlue[200]),
                Container(width: 5, height: 7, color: Colors.lightBlue[200]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
