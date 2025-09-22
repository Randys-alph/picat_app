import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:page_transition/page_transition.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import '../theme_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
        child: const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final logoImage = isDarkMode ? 'assets/images/logo_dark.png' : 'assets/images/logo_light.png';

    final gradientImage = isDarkMode
    ? 'assets/images/gradient_dark.png'
    : 'assets/images/gradient_light.png';

    return GestureDetector(
      onTap: () => navigateToHome(context),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(gradientImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Swing(
                    duration: const Duration(seconds: 2),
                    child: Image.asset(
                      logoImage,
                      width: 150,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      'PiCat',
                      style: TextStyle(
                        fontFamily: 'Jersey20',
                        fontSize: 80,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: Text(
                      'Tap to Start ...',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 50,
              right: 20,
              child: DayNightSwitcher(
                isDarkModeEnabled: isDarkMode,
                onStateChanged: (bool isDarkModeEnabled) {
                  final provider = Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(isDarkModeEnabled);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}