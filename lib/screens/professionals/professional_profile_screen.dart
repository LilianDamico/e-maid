import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../booking/booking_screen.dart';

class ProfessionalProfileScreen extends StatelessWidget {
  final Map<String, dynamic> professional;

  const ProfessionalProfileScreen({
    super.key,
    required this.professional,
  });

  @override
  Widget build(BuildContext context) {
    final professionalId = professional['id'] as String;

    // Faz uma consulta dinâmica só pra garantir dados atualizados
    final docRef =
        FirebaseFirestore.instance.collection('professionals').doc(professionalId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Profissional'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar perfil: ${snapshot.error}'),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(child: Text('Profissional não encontrado.'));
          }

          // --- Campos
          final name = data['name'] ?? '';
          final photo = data['photo'] ?? '';
          final description = data['bio'] ?? 'Sem descrição';
          final price = data['price']?.toString() ?? '0';
          final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
          final reviews = (data['reviews'] ?? 0).toString();

          // Pega o primeiro serviço apenas para o botão agendar
          final services = List<String>.from(data['services'] ?? []);
          final String firstService = services.isNotEmpty ? services.first : 'Serviço';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(photo),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text('$rating ($reviews avaliações)'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'R\$ $price/h',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Serviços oferecidos:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: services
                      .map((s) => Chip(
                            label: Text(s),
                            backgroundColor: Colors.teal.shade50,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal),
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Agendar Serviço'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingScreen(
                            professional: {
                              'id': professionalId,
                              'name': name,
                              'price': price,
                              'photo': photo,
                            },
                            serviceName: firstService,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
