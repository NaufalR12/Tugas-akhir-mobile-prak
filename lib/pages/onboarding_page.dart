import 'package:flutter/material.dart';
import 'auth_choice_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFB6E5F8), Color(0xFFFDFCFB)],
                stops: [0.0, 0.7],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    'assets/onboarding1.png',
                    height: 240,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bandingkan Ongkir,',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Kirim Lebih\nHemat!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 0.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0, bottom: 24.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.black,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthChoicePage(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
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
