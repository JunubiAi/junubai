import 'package:buai/ui/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(_isDarkMode
                      ? 'assets/images/buai-dark.png'
                      : 'assets/images/buai.png')
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppButtons.authButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signin');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                          weight: 2,
                          size: 21,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Continue with Email",
                          style: GoogleFonts.kanit(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .slideY(
                        begin: 0.5,
                        duration: const Duration(milliseconds: 850),
                      )
                      .fade(),
                  const SizedBox(height: 5),
                  AppButtons.authButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signin');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google.png', width: 16),
                        const SizedBox(width: 6),
                        Text(
                          "Continue with Google",
                          style: GoogleFonts.kanit(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .slideY(
                        begin: 0.5,
                        duration: const Duration(milliseconds: 850),
                        delay: const Duration(milliseconds: 200),
                      )
                      .fade(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
