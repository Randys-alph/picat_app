import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:page_transition/page_transition.dart';
import '../theme_provider.dart';
import 'search_screen.dart';
import 'splash_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Fungsi untuk navigasi ke halaman Search dengan transisi
  void navigateToSearch(BuildContext context, String category) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: SearchScreen(category: category),
      ),
    );
  }

  // Fungsi untuk navigasi kembali ke Splash Screen dengan transisi
  void navigateToSplash(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: const SplashScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final buttonTextColor = isDarkMode ? Colors.white : Colors.black;
    final logoImage = isDarkMode ? 'assets/images/dark_logo.png' : 'assets/images/logo.png';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onTap: () => navigateToSplash(context),
          child: Text(
            'PiCat',
            style: TextStyle(
              fontFamily: 'Jersey20',
              fontSize: 40,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        actions: [
          CupertinoSwitch(
            value: isDarkMode,
            onChanged: (value) {
              final provider = Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(value);
            },
            activeColor: Colors.orange,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Gambar latar belakang di pojok kiri atas
          Positioned(
            top: -50,
            left: -50,
            child: Transform.rotate(
              angle: pi, // Memutar gambar 180 derajat
              child: Image.asset(
                logoImage,
                width: 250,
                color: const Color.fromRGBO(255, 255, 255, 0.2),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          ),
          // Gambar latar belakang di pojok kanan bawah
          Positioned(
            bottom: -80,
            right: -60,
            child: Image.asset(
              logoImage,
              width: 250,
              color: const Color.fromRGBO(255, 255, 255, 0.2),
              colorBlendMode: BlendMode.modulate,
            ),
          ),

          // Konten Utama (Tombol Kategori)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tombol Movies dengan animasi
                  FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: () => navigateToSearch(context, 'Movie'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.grey.shade800.withOpacity(0.5) : Colors.white.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Movie',
                        style: TextStyle(
                          fontFamily: 'Jersey20',
                          fontSize: 40,
                          color: buttonTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Tombol Music dengan animasi
                  FadeInLeft(
                    delay: const Duration(milliseconds: 400),
                    child: ElevatedButton(
                      onPressed: () => navigateToSearch(context, 'Music'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.grey.shade800.withOpacity(0.5) : Colors.white.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Music',
                        style: TextStyle(
                          fontFamily: 'Jersey20',
                          fontSize: 40,
                          color: buttonTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Tombol Books dengan animasi
                  FadeInLeft(
                    delay: const Duration(milliseconds: 600),
                    child: ElevatedButton(
                      onPressed: () => navigateToSearch(context, 'Book'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.grey.shade800.withOpacity(0.5) : Colors.white.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Book',
                        style: TextStyle(
                          fontFamily: 'Jersey20',
                          fontSize: 40,
                          color: buttonTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}