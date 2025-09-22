import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:page_transition/page_transition.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import '../theme_provider.dart';
import 'search_screen.dart';
import 'splash_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToSearch(BuildContext context, String category) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: SearchScreen(category: category),
      ),
    );
  }

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
    final logoImage = isDarkMode ? 'assets/images/logo_dark.png' : 'assets/images/logo_light.png';
    final gradientImage = isDarkMode
        ? 'assets/images/gradient_dark.png'
        : 'assets/images/gradient_light.png';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(gradientImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: -20,
            left: -50,
            child: Transform.rotate(
              angle: 150 * (pi / 180),
              child: Image.asset(
                logoImage,
                width: 300,
                color: const Color.fromRGBO(255, 255, 255, 0.1),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -25,
            child: Image.asset(
              logoImage,
              width: 300,
              color: const Color.fromRGBO(255, 255, 255, 0.1),
              colorBlendMode: BlendMode.modulate,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
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
                      DayNightSwitcher(
                        isDarkModeEnabled: isDarkMode,
                        onStateChanged: (bool isDarkModeEnabled) {
                          final provider = Provider.of<ThemeProvider>(context, listen: false);
                          provider.toggleTheme(isDarkModeEnabled);
                        },
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FadeInLeft(
                            delay: const Duration(milliseconds: 200),
                            child: CategoryButton(
                              label: 'Movie',
                              imageName: 'movie_cat',
                              onPressed: () => navigateToSearch(context, 'Movie'),
                            ),
                          ),
                          const SizedBox(height: 25),
                          FadeInLeft(
                            delay: const Duration(milliseconds: 400),
                            child: CategoryButton(
                              label: 'Music',
                              imageName: 'music_cat',
                              onPressed: () => navigateToSearch(context, 'Music'),
                              isImageLeft: true,
                            ),
                          ),
                          const SizedBox(height: 25),
                          FadeInLeft(
                            delay: const Duration(milliseconds: 600),
                            child: CategoryButton(
                              label: 'Book',
                              imageName: 'book_cat',
                              onPressed: () => navigateToSearch(context, 'Book'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final String imageName;
  final VoidCallback onPressed;
  final bool isImageLeft;

  const CategoryButton({
    super.key,
    required this.label,
    required this.imageName,
    required this.onPressed,
    this.isImageLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final buttonTextColor = isDarkMode ? Colors.white : Colors.black;
    final fullImagePath = isDarkMode
        ? 'assets/images/${imageName}_dark.png'
        : 'assets/images/${imageName}_light.png';

    final textWidget = Text(
      label,
      style: TextStyle(
        fontFamily: 'Jersey20',
        fontSize: 45,
        color: buttonTextColor,
      ),
    );

    final imageWidget = Image.asset(
      fullImagePath,
      height: 98,
      fit: BoxFit.contain,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.grey.shade800.withOpacity(0.5) : Colors.white.withOpacity(0.7),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 5,
      ),
      child: SizedBox(
        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: isImageLeft ? [imageWidget, textWidget] : [textWidget, imageWidget],
        ),
      ),
    );
  }
}

