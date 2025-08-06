import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../professional/earnings_screen.dart';
import '../admin/platform_stats_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  Future<bool> _isProfessional() async {
    try {
      final authService = AuthService();
      final user = authService.currentUser;
      if (user == null) return false;
      
      // Verificar se o usuário tem perfil de profissional
      // Isso pode ser feito verificando uma coleção 'professionals' no Firestore
      // Por enquanto, vamos simular baseado no email ou outro critério
      return user.email?.contains('professional') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _isAdmin() async {
    try {
      final authService = AuthService();
      final user = authService.currentUser;
      if (user == null) return false;
      
      // Verificar se o usuário é administrador
      // Por enquanto, vamos simular baseado no email
      return user.email?.contains('admin') ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navegar para edição de perfil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header do perfil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.teal, Colors.teal.shade300],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'João Silva',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'joao.silva@email.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Cliente Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Estatísticas
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Serviços\nContratados',
                      '12',
                      Icons.cleaning_services,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Avaliação\nMédia',
                      '4.8',
                      Icons.star,
                      Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Economia\nTotal',
                      'R\$ 240',
                      Icons.savings,
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu de opções
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMenuSection(
                    'Conta',
                    [
                      _buildMenuItem(
                        Icons.person,
                        'Informações Pessoais',
                        'Editar nome, telefone, endereço',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.security,
                        'Segurança',
                        'Alterar senha, autenticação',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.payment,
                        'Métodos de Pagamento',
                        'Cartões, PIX, carteira digital',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.location_on,
                        'Endereços Salvos',
                        'Gerenciar endereços favoritos',
                        () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Seção específica para profissionais
                  FutureBuilder<bool>(
                    future: _isProfessional(),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return Column(
                          children: [
                            _buildMenuSection(
                              'Área do Profissional',
                              [
                                _buildMenuItem(
                                  Icons.account_balance_wallet,
                                  'Meus Ganhos',
                                  'Visualizar comissões e estatísticas',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EarningsScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _buildMenuItem(
                                  Icons.work_outline,
                                  'Meus Trabalhos',
                                  'Histórico de serviços prestados',
                                  () {},
                                ),
                                _buildMenuItem(
                                  Icons.schedule,
                                  'Disponibilidade',
                                  'Gerenciar horários disponíveis',
                                  () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  _buildMenuSection(
                    'Preferências',
                    [
                      _buildMenuItem(
                        Icons.notifications,
                        'Notificações',
                        'Configurar alertas e lembretes',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.language,
                        'Idioma',
                        'Português (Brasil)',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.dark_mode,
                        'Tema',
                        'Claro, escuro ou automático',
                        () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Seção de Administração
                  FutureBuilder<bool>(
                    future: _isAdmin(),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return Column(
                          children: [
                            _buildMenuSection(
                              'Administração',
                              [
                                _buildMenuItem(
                                  Icons.analytics,
                                  'Estatísticas da Plataforma',
                                  'Visualizar dados da plataforma',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PlatformStatsScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _buildMenuItem(
                                  Icons.account_balance,
                                  'Gerenciar Comissões',
                                  'Configurar comissões dos profissionais',
                                  () {
                                    // TODO: Implementar tela de gerenciamento de comissões
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Funcionalidade em desenvolvimento'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  _buildMenuSection(
                     'Suporte',
                     [
                      _buildMenuItem(
                        Icons.help,
                        'Central de Ajuda',
                        'FAQ e tutoriais',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.chat,
                        'Fale Conosco',
                        'Chat, e-mail ou telefone',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.star_rate,
                        'Avaliar App',
                        'Deixe sua avaliação na loja',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.share,
                        'Indicar Amigos',
                        'Compartilhe e ganhe desconto',
                        () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildMenuSection(
                    'Legal',
                    [
                      _buildMenuItem(
                        Icons.description,
                        'Termos de Uso',
                        'Condições de utilização',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.privacy_tip,
                        'Política de Privacidade',
                        'Como tratamos seus dados',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.info,
                        'Sobre o App',
                        'Versão 1.0.0',
                        () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Botão de logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Sair da Conta',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.teal,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text(
          'Tem certeza que deseja sair da sua conta?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.splash,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}