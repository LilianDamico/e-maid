import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PixPaymentScreen extends StatelessWidget {
  final Map<String, dynamic> pixData;        // qr_code, qr_code_base64, payment_id
  final Map<String, dynamic> bookingData;

  const PixPaymentScreen({
    super.key,
    required this.pixData,
    required this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final qrCode = pixData['qr_code']?.toString() ?? '';
    final qrBase64 = pixData['qr_code_base64']?.toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento via PIX')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (qrBase64 != null && qrBase64.isNotEmpty)
              Image.memory(
                base64Decode(qrBase64),
                height: 220,
              ),
            const SizedBox(height: 16),
            const Text('Escaneie o QR Code ou use o código copia e cola:'),
            const SizedBox(height: 8),
            SelectableText(qrCode),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: qrCode));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código PIX copiado!')),
                  );
                }
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copiar código'),
            ),
          ],
        ),
      ),
    );
  }
}
