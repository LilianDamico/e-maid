import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/professional_register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/services/services_screen.dart';
import '../screens/professionals/professionals_screen.dart';
import '../screens/professionals/professional_profile_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/bookings/bookings_screen.dart';
import '../screens/profile/profile_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.professionalRegister:
        return MaterialPageRoute(builder: (_) => const ProfessionalRegisterScreen());
      
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case AppRoutes.services:
        return MaterialPageRoute(builder: (_) => const ServicesScreen());
      
      case AppRoutes.professionals:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProfessionalsScreen(
            serviceName: args?['serviceName'] ?? 'Serviço',
          ),
        );
      
      case AppRoutes.professionalProfile:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProfessionalProfileScreen(
            professional: args['professional'],
          ),
        );
      
      case AppRoutes.booking:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BookingScreen(
            professional: args['professional'],
            serviceName: args['serviceName'],
          ),
        );
      
      case AppRoutes.bookings:
        return MaterialPageRoute(builder: (_) => const BookingsScreen());
      
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      default:
        return _errorRoute();
    }
  }
  
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Erro'),
        ),
        body: const Center(
          child: Text('Página não encontrada'),
        ),
      ),
    );
  }
}