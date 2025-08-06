import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../data/services_data.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços Disponíveis'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ServicesData.serviceCategories.length,
        itemBuilder: (context, index) {
          final category = ServicesData.serviceCategories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text(
                category['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(
                category['icon'],
                color: Colors.teal,
                size: 30,
              ),
              children: (category['services'] as List<Map<String, dynamic>>)
                  .map((service) => ListTile(
                        leading: Icon(
                          service['icon'],
                          color: Colors.teal.shade300,
                        ),
                        title: Text(service['name']),
                        subtitle: Text('A partir de R\$ ${service['price']}/hora'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.professionals,
                            arguments: {
                              'serviceName': service['name'],
                            },
                          );
                        },
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}