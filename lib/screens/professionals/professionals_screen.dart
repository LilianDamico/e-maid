import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'professional_profile_screen.dart';

class ProfessionalsScreen extends StatelessWidget {
  final String serviceName; // ex.: “Limpeza”, “Passar Roupa”, etc.

  const ProfessionalsScreen({super.key, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    // Consulta filtrando por serviceName dentro de "services"
    final professionalsStream = FirebaseFirestore.instance
        .collection('professionals')
        .where('services', arrayContains: serviceName)
        .orderBy('rating', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profissionais de $serviceName'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: professionalsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar profissionais: ${snapshot.error}'),
            );
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum profissional encontrado.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final id = data['id'] as String;
              final name = data['name'] ?? '';
              final photo = data['photo'] ?? '';
              final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
              final reviews = (data['reviews'] ?? 0).toString();
              final price = data['price']?.toString() ?? '0';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
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
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfessionalProfileScreen(
                                  professional: data..['id'] = id,
                                ),
                              ),
                            );
                          },
                          child: const Text('Ver Perfil'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
