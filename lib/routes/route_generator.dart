import 'package:flutter/material.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        // TODO: retorne sua Splash real
        return _page(const _PlaceholderScreen(title: 'Splash'));
      // Conta
      case AppRoutes.accountSecurity:
        return _page(const _PlaceholderScreen(title: 'Segurança da Conta'));
      case AppRoutes.paymentMethods:
        return _page(const _PlaceholderScreen(title: 'Métodos de Pagamento'));
      case AppRoutes.savedAddresses:
        return _page(const _PlaceholderScreen(title: 'Endereços Salvos'));

      // Profissional
      case AppRoutes.earnings:
        return _page(const _PlaceholderScreen(title: 'Meus Ganhos'));
      case AppRoutes.professionalJobs:
        return _page(const _PlaceholderScreen(title: 'Meus Trabalhos'));
      case AppRoutes.availability:
        return _page(const _PlaceholderScreen(title: 'Disponibilidade'));

      // Preferências
      case AppRoutes.notificationsSettings:
        return _page(const _PlaceholderScreen(title: 'Notificações'));
      case AppRoutes.language:
        return _page(const _PlaceholderScreen(title: 'Idioma'));
      case AppRoutes.theme:
        return _page(const _PlaceholderScreen(title: 'Tema'));

      // Administração
      case AppRoutes.platformStats:
        return _page(const _PlaceholderScreen(title: 'Estatísticas da Plataforma'));
      case AppRoutes.manageCommissions:
        return _page(const _PlaceholderScreen(title: 'Gerenciar Comissões'));

      // Suporte
      case AppRoutes.helpCenter:
        return _page(const _PlaceholderScreen(title: 'Central de Ajuda'));
      case AppRoutes.contactUs:
        return _page(const _PlaceholderScreen(title: 'Fale Conosco'));
      case AppRoutes.rateApp:
        return _page(const _PlaceholderScreen(title: 'Avaliar App'));
      case AppRoutes.inviteFriends:
        return _page(const _PlaceholderScreen(title: 'Indicar Amigos'));

      // Legal
      case AppRoutes.terms:
        return _page(const _PlaceholderScreen(title: 'Termos de Uso'));
      case AppRoutes.privacy:
        return _page(const _PlaceholderScreen(title: 'Política de Privacidade'));
      case AppRoutes.about:
        return _page(const _PlaceholderScreen(title: 'Sobre o App'));

      default:
        return _page(const _PlaceholderScreen(title: 'Rota não encontrada'));
    }
  }

  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Center(
        child: Text('Tela "$title" – em breve', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
