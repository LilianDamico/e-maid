import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _scale = Tween(begin: 0.92, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_controller);
    _fade = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_controller);

    _controller.forward();

    _decideNext();
  }

  Future<void> _decideNext() async {
    try {
      // Aguarda o primeiro valor da stream (ou timeout de 4s).
      final user = await FirebaseAuth.instance
          .authStateChanges()
          .first
          .timeout(const Duration(seconds: 4));

      if (!mounted) return;
      if (user != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } on TimeoutException {
      if (!mounted) return;
      // Se demorar demais (ex.: Web bloqueou cookies / rede lenta), manda pro login.
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', width: 160),
                  const SizedBox(height: 20),
                  const Text(
                    'Conectando você a profissionais de limpeza\n'
                    'de forma prática e segura.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.black54,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
