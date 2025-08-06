import 'package:flutter/material.dart';

class ServicesData {
  static final List<Map<String, dynamic>> serviceCategories = [
    {
      'name': 'Limpeza Residencial',
      'icon': Icons.home,
      'services': [
        {
          'name': 'Limpeza Geral',
          'price': '25',
          'icon': Icons.cleaning_services,
        },
        {
          'name': 'Limpeza Pesada',
          'price': '35',
          'icon': Icons.build,
        },
        {
          'name': 'Organização',
          'price': '30',
          'icon': Icons.inventory,
        },
      ],
    },
    {
      'name': 'Limpeza Especializada',
      'icon': Icons.star,
      'services': [
        {
          'name': 'Limpeza de Estofados',
          'price': '40',
          'icon': Icons.chair,
        },
        {
          'name': 'Limpeza de Carpetes',
          'price': '35',
          'icon': Icons.texture,
        },
        {
          'name': 'Limpeza de Vidros',
          'price': '20',
          'icon': Icons.window,
        },
      ],
    },
    {
      'name': 'Serviços de Eventos',
      'icon': Icons.event,
      'services': [
        {
          'name': 'Garçom/Garçonete',
          'price': '45',
          'icon': Icons.room_service,
        },
        {
          'name': 'Cozinheiro(a)',
          'price': '50',
          'icon': Icons.restaurant,
        },
        {
          'name': 'Chef Particular',
          'price': '80',
          'icon': Icons.restaurant_menu,
        },
      ],
    },
    {
      'name': 'Cuidados',
      'icon': Icons.favorite,
      'services': [
        {
          'name': 'Babá',
          'price': '25',
          'icon': Icons.child_care,
        },
        {
          'name': 'Cuidador de Idosos',
          'price': '30',
          'icon': Icons.elderly,
        },
      ],
    },
    {
      'name': 'Serviços Externos',
      'icon': Icons.nature,
      'services': [
        {
          'name': 'Jardineiro',
          'price': '35',
          'icon': Icons.grass,
        },
      ],
    },
    {
      'name': 'Lavanderia',
      'icon': Icons.local_laundry_service,
      'services': [
        {
          'name': 'Lavagem e Passadoria',
          'price': '15',
          'icon': Icons.iron,
        },
      ],
    },
  ];
}