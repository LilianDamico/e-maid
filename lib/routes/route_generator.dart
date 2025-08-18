// lib/routes/route_generator.dart
import 'package:flutter/material.dart';

import 'app_routes.dart';

// Telas já existentes
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/professional_register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/professionals/professionals_screen.dart';
import '../screens/professionals/professional_profile_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/bookings/bookings_screen.dart';
import '../screens/payment/payment_method_screen.dart';
import '../screens/payment/payment_webview_screen.dart';
import '../screens/payment/pix_payment_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Dados passados (opcional) via Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      // ─────────────────── Base
      case AppRoutes.splash:
        return _page(const SplashScreen());
      case AppRoutes.login:
        return _page(const LoginScreen());
      case AppRoutes.home:
        return _page(const HomeScreen());

      // ─────────────────── Autenticação
      case AppRoutes.register:
        return _page(const RegisterScreen());
      case AppRoutes.professionalRegister:
        return _page(const ProfessionalRegisterScreen());

      // ─────────────────── Perfil
      case AppRoutes.profile:
        return _page(const ProfileScreen());

      // ─────────────────── Serviços / Profissionais
      case AppRoutes.professionals:
        // Espera-se receber: { 'serviceName': '...' }
        final serviceName = (args as Map?)?['serviceName'] as String?;
        return _page(ProfessionalsScreen(serviceName: serviceName ?? ''));

      case AppRoutes.professionalProfile:
        // Espera-se receber: { 'professional': {...} }
        final professional = (args as Map?)?['professional'];
        return _page(ProfessionalProfileScreen(professional: professional));

      case AppRoutes.booking:
        // Espera-se: { 'professional': {...}, 'serviceName': '...' }
        final data = (args as Map?) ?? {};
        return _page(BookingScreen(
          professional: data['professional'],
          serviceName: data['serviceName'],
        ));

      case AppRoutes.bookings:
        return _page(const BookingsScreen());

      // ─────────────────── Pagamentos
      case AppRoutes.paymentMethod:
        // Espera-se: { bookingData, totalAmount }
        final data = (args as Map?) ?? {};
        return _page(PaymentMethodScreen(
          bookingData: data['bookingData'],
          totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0,
        ));

      case AppRoutes.paymentWebview:
        final data = (args as Map?) ?? {};
        return _page(PaymentWebViewScreen(
          checkoutUrl: data['checkoutUrl'],
          bookingData: data['bookingData'],
        ));

      case AppRoutes.pixPayment:
        final data = (args as Map?) ?? {};
        return _page(PixPaymentScreen(
          pixData: data['pixData'],
          bookingData: data['bookingData'],
        ));

      // ─────────────────── fallback
      default:
        return _page(_PlaceholderScreen(title: 'Rota não encontrada'));
    }
  }

  // Helpers
  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, size: 60, color: Colors.grey),
            SizedBox(height: 8),
            Text('Em desenvolvimento'),
          ],
        ),
      ),
    );
  }
}
