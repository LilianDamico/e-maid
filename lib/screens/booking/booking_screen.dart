// lib/screens/booking/booking_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/commission_service.dart';
import '../payment/payment_method_screen.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> professional;
  final String serviceName;

  const BookingScreen({
    super.key,
    required this.professional,
    required this.serviceName,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _duration = 2;
  String _frequency = 'única';
  final _addressController = TextEditingController();
  final _observationsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Serviço'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações do profissional
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(widget.professional['photo']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.professional['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.serviceName,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'R\$ ${widget.professional['price']}/h',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Seleção de data
              _buildSectionTitle('Data do Serviço'),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                child: _buildInputBox(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Selecione a data',
                ),
              ),
              const SizedBox(height: 16),

              // Seleção de horário
              _buildSectionTitle('Horário'),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 9, minute: 0),
                  );
                  if (time != null) {
                    setState(() {
                      _selectedTime = time;
                    });
                  }
                },
                child: _buildInputBox(
                  _selectedTime != null
                      ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                      : 'Selecione o horário',
                ),
              ),
              const SizedBox(height: 16),

              // Duração
              _buildSectionTitle('Duração (horas)'),
              Row(
                children: [1, 2, 3, 4, 5, 6].map((hours) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text('${hours}h'),
                        selected: _duration == hours,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _duration = hours);
                          }
                        },
                        selectedColor: Colors.teal.shade100,
                        labelStyle: TextStyle(
                          color: _duration == hours ? Colors.teal : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Frequência
              _buildSectionTitle('Frequência'),
              DropdownButtonFormField<String>(
                value: _frequency,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'única', child: Text('Única vez')),
                  DropdownMenuItem(value: 'semanal', child: Text('Semanal')),
                  DropdownMenuItem(value: 'quinzenal', child: Text('Quinzenal')),
                  DropdownMenuItem(value: 'mensal', child: Text('Mensal')),
                ],
                onChanged: (value) => setState(() => _frequency = value!),
              ),
              const SizedBox(height: 16),

              // Endereço
              _buildSectionTitle('Endereço'),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Digite o endereço completo',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // Observações
              _buildSectionTitle('Observações (opcional)'),
              TextFormField(
                controller: _observationsController,
                decoration: const InputDecoration(
                  hintText: 'Instruções especiais, acesso ao local, etc.',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Resumo
              _buildSummary(),

              const SizedBox(height: 24),

              // Botão
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onConfirmPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirmar Agendamento',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================

  Widget _buildSectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

  Widget _buildInputBox(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(color: text.contains('Selecione') ? Colors.grey : Colors.black),
        ),
      );

  Widget _buildSummary() {
    final totalAmount =
        (int.parse(widget.professional['price']) * _duration).toDouble();
    final breakdown =
        CommissionService().getPriceBreakdown(totalAmount);

    return Card(
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo do Agendamento',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Serviço: ${widget.serviceName}'),
            Text('Profissional: ${widget.professional['name']}'),
            if (_selectedDate != null && _selectedTime != null)
              Text(
                'Data/Hora: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} '
                'às ${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
              ),
            Text('Duração: ${_duration}h'),
            Text('Frequência: $_frequency'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total a pagar:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  'R\$ ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Profissional receberá: R\$ ${breakdown['professionalEarnings'].toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onConfirmPressed() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      await _saveAndProceed();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos obrigatórios'),
        ),
      );
    }
  }

  Future<void> _saveAndProceed() async {
    final totalAmount =
        (int.parse(widget.professional['price']) * _duration).toDouble();

    final bookingId = DateTime.now().millisecondsSinceEpoch.toString();
    final bookingData = {
      'id': bookingId,
      'serviceName': widget.serviceName,
      'professionalName': widget.professional['name'],
      'professionalId': widget.professional['id'],
      'clientId': FirebaseAuth.instance.currentUser!.uid,
      'date': _selectedDate,
      'time':
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
      'duration': _duration,
      'frequency': _frequency,
      'address': _addressController.text,
      'observations': _observationsController.text,
      'totalAmount': totalAmount,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set(bookingData);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentMethodScreen(
              bookingData: bookingData,
              totalAmount: totalAmount,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar agendamento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _observationsController.dispose();
    super.dispose();
  }
}
