
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void navigateToHome(BuildContext context) {
    // Menggunakan PageTransition untuk efek fade
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
    final logoImage = isDarkMode ? 'assets/images/dark_logo.png' : 'assets/images/logo.png';

    return GestureDetector(
      onTap: () => navigateToHome(context),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Konten utama di tengah
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animasi ayunan (Swing) pada logo dan judul
                  Swing(
                    duration: const Duration(seconds: 2),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          logoImage,
                          width: 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Text(
                            'PiCat',
                            style: TextStyle(
                              fontFamily: 'Jersey20',
                              fontSize: 80,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Animasi fade-in dari bawah untuk subjudul
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
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
            // Tombol ganti tema di pojok kanan atas
            Positioned(
              top: 50,
              right: 20,
              child: CupertinoSwitch(
                value: isDarkMode,
                onChanged: (value) {
                  final provider = Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                },
                activeColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}