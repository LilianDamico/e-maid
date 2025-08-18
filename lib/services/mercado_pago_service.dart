// lib/services/mercado_pago_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class MercadoPagoService {
  Future<Map<String, dynamic>> createPaymentPreference({
    required String title,
    required double amount,
    required String userEmail,
    required String bookingId,
    Map<String, dynamic>? metadata,
  }) async {
    final uri = Uri.parse(ApiConfig.createPreference);

    final payload = {
      'title'            : title,
      'amount'           : amount,
      'userEmail'        : userEmail,
      'externalReference': bookingId,
      if (metadata != null) 'metadata': metadata,
    };

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return data['body'] as Map<String, dynamic>;
    } else {
      throw Exception('Falha ao criar preferência (${resp.statusCode}): ${resp.body}');
    }
  }

  Future<Map<String, dynamic>> createPixPayment({
    required double amount,
    required String userEmail,
    required String bookingId,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final uri = Uri.parse(ApiConfig.createPix);

    final payload = {
      'amount'           : amount,
      'userEmail'        : userEmail,
      'description'      : description,
      'externalReference': bookingId,
      if (metadata != null) 'metadata': metadata,
    };

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return data['body'] as Map<String, dynamic>;
    } else {
      throw Exception('Falha ao criar PIX (${resp.statusCode}): ${resp.body}');
    }
  }
}
