// lib/screens/bookings/bookings_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = AuthService().currentUser?.uid;
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado.')),
      );
    }

    final bookingsQuery = FirebaseFirestore.instance
        .collection('bookings')
        .where('clientId', isEqualTo: uid)
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: bookingsQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Você ainda não possui agendamentos.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, idx) {
              final data = docs[idx].data();
              final date = (data['date'] as Timestamp?)?.toDate();
              final time = data['time'] as String?;
              final dateStr = date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Data';
              final total = data['totalAmount']?.toStringAsFixed(2) ?? '';
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Serviço: ${data['serviceName']}'),
                  subtitle: Text('$dateStr às $time\nTotal: R\$ $total'),
                  trailing: Text(
                    data['status'] == 'paid' ? 'Pago' : 'Pendente',
                    style: TextStyle(
                      color: data['status'] == 'paid' ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
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
