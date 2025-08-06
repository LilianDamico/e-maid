import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class ProfessionalProfileScreen extends StatelessWidget {
  final Map<String, dynamic> professional;

  const ProfessionalProfileScreen({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(professional['name']),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto e informações básicas
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(professional['photo']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        professional['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            ' ${professional['rating']} (${professional['reviews']} avaliações)',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ ${professional['price']}/hora',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Informações detalhadas
            _buildInfoCard('Experiência', '${professional['experience']} anos'),
            _buildInfoCard('Distância', professional['distance']),
            _buildInfoCard('Verificado', professional['verified'] ? 'Sim' : 'Não'),
            _buildInfoCard('Disponível', professional['available'] ? 'Sim' : 'Não'),
            
            const SizedBox(height: 16),
            
            // Descrição
            const Text(
              'Sobre',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              professional['description'],
              style: const TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 24),
            
            // Especialidades
            const Text(
              'Especialidades',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildSpecialtyChip('Limpeza Geral'),
                _buildSpecialtyChip('Organização'),
                _buildSpecialtyChip('Cozinha'),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Avaliações recentes
            const Text(
              'Avaliações Recentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildReviewCard('Maria Silva', 5, 'Excelente profissional, muito cuidadosa!'),
            _buildReviewCard('João Santos', 4, 'Bom trabalho, pontual e organizada.'),
            
            const SizedBox(height: 32),
            
            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Implementar chat
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funcionalidade de chat em desenvolvimento'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Mensagem'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.teal),
                      foregroundColor: Colors.teal,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: professional['available'] ? () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.booking,
                        arguments: {
                          'professional': professional,
                          'serviceName': 'Serviço Selecionado',
                        },
                      );
                    } : null,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Contratar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(value),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSpecialtyChip(String specialty) {
    return Chip(
      label: Text(specialty),
      backgroundColor: Colors.teal.shade50,
      labelStyle: const TextStyle(color: Colors.teal),
    );
  }
  
  Widget _buildReviewCard(String name, int rating, String comment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment),
          ],
        ),
      ),
    );
  }
}