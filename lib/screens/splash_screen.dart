import 'dart:async';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart'; // usa seu AuthService

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
      duration: const Duration(milliseconds: 700),
    );

    _scale = Tween<double>(begin: 0.92, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_controller);

    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_controller);

    _controller.forward();

    // pequeno delay p/ a animação acontecer
    Timer(const Duration(milliseconds: 1200), _decideNext);
  }

  Future<void> _decideNext() async {
    final user = AuthService().currentUser; // seu getter
    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
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
    // fundo simples; troque por gradient se quiser
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
                  // logo
                  Image.asset('assets/logo.png', width: 160),
                  const SizedBox(height: 24),
                  
                  const SizedBox(height: 12),
                  const Text(
                    'Conectando você a profissionais de limpeza\nde forma prática e segura.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.black54,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 28),
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
