import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
// Importe outras telas só se for navegar até elas, senão pode remover os imports abaixo
import '../professional/earnings_screen.dart';
import '../admin/platform_stats_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Simulação: Verifica se é profissional (ajuste para Firestore se quiser)
  Future<bool> _isProfessional() async {
    final user = AuthService().currentUser;
    return user?.email?.contains('professional') ?? false;
  }

  // Simulação: Verifica se é admin (ajuste para Firestore se quiser)
  Future<bool> _isAdmin() async {
    final user = AuthService().currentUser;
    return user?.email?.contains('admin') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold é o container padrão das telas no Flutter
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho com avatar, nome, e-mail etc
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
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'João Silva', // Troque para seu nome dinâmico
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'joao.silva@email.com', // Troque para seu e-mail dinâmico
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Cliente Premium', // Dinamize conforme sua regra
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Estatísticas simples
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatCard('Serviços', '12', Icons.cleaning_services, Colors.blue),
                  const SizedBox(width: 12),
                  _buildStatCard('Avaliação', '4.8', Icons.star, Colors.amber),
                  const SizedBox(width: 12),
                  _buildStatCard('Economia', 'R\$ 240', Icons.savings, Colors.green),
                ],
              ),
            ),

            // Menu de opções do usuário
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuSection(
                    'Conta',
                    [
                      _buildMenuItem(Icons.person, 'Informações Pessoais', () {}),
                      _buildMenuItem(Icons.security, 'Segurança', () {}),
                      _buildMenuItem(Icons.payment, 'Métodos de Pagamento', () {}),
                      _buildMenuItem(Icons.location_on, 'Endereços Salvos', () {}),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Opções para profissional
                  FutureBuilder<bool>(
                    future: _isProfessional(),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return _buildMenuSection(
                          'Área do Profissional',
                          [
                            _buildMenuItem(Icons.account_balance_wallet, 'Meus Ganhos', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const EarningsScreen()),
                              );
                            }),
                            _buildMenuItem(Icons.work_outline, 'Meus Trabalhos', () {}),
                            _buildMenuItem(Icons.schedule, 'Disponibilidade', () {}),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildMenuSection(
                    'Preferências',
                    [
                      _buildMenuItem(Icons.notifications, 'Notificações', () {}),
                      _buildMenuItem(Icons.language, 'Idioma', () {}),
                      _buildMenuItem(Icons.dark_mode, 'Tema', () {}),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Opções para administrador
                  FutureBuilder<bool>(
                    future: _isAdmin(),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return _buildMenuSection(
                          'Administração',
                          [
                            _buildMenuItem(Icons.analytics, 'Estatísticas da Plataforma', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PlatformStatsScreen()),
                              );
                            }),
                            _buildMenuItem(Icons.account_balance, 'Gerenciar Comissões', () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Funcionalidade em desenvolvimento'),
                                ),
                              );
                            }),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildMenuSection(
                    'Suporte',
                    [
                      _buildMenuItem(Icons.help, 'Central de Ajuda', () {}),
                      _buildMenuItem(Icons.chat, 'Fale Conosco', () {}),
                      _buildMenuItem(Icons.star_rate, 'Avaliar App', () {}),
                      _buildMenuItem(Icons.share, 'Indicar Amigos', () {}),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildMenuSection(
                    'Legal',
                    [
                      _buildMenuItem(Icons.description, 'Termos de Uso', () {}),
                      _buildMenuItem(Icons.privacy_tip, 'Política de Privacidade', () {}),
                      _buildMenuItem(Icons.info, 'Sobre o App', () {}),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botão de logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text('Sair da Conta', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // **Botão de exclusão de conta**
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showDeleteAccountDialog(context),
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      label: const Text('Excluir Conta', style: TextStyle(color: Colors.red)),
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

  // Card de estatísticas simples
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  // Seção do menu
  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  // Itens do menu
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.teal, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Diálogo de logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Faça seu logout real aqui, depois:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.splash,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Diálogo de exclusão de conta
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text('Tem certeza que deseja excluir sua conta? Essa ação é irreversível e todos os seus dados serão apagados!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final scaffold = ScaffoldMessenger.of(context);
              try {
                await AuthService().deleteAccount();
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text('Conta excluída com sucesso.'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.splash,
                  (route) => false,
                );
              } catch (e) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text('Erro ao excluir conta: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
