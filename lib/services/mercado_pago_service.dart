import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class MercadoPagoService {
  /// Cria preferência (Checkout Pro) e retorna o JSON do backend
  /// Esperado: { id, init_point, ... }
  Future<Map<String, dynamic>> createPaymentPreference({
    required String title,
    required double amount,
    required String userEmail,
    required String bookingId,
    Map<String, dynamic>? metadata,
  }) async {
    final uri = Uri.parse(ApiConfig.createPreference);

    final payload = {
      'amount': amount,
      'description': title,
      'payer_email': userEmail,
      'metadata': {
        'bookingId': bookingId,
        ...?metadata,
      },
      // ajudamos o backend a popular os back_urls
      'return_urls': {
        'success': ReturnUrls.success,
        'failure': ReturnUrls.failure,
        'pending': ReturnUrls.pending,
      },
    };

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      if ((data['init_point'] ?? data['sandbox_init_point']) == null) {
        throw Exception('Resposta sem init_point: ${resp.body}');
      }
      return data;
    } else {
      throw Exception('Falha ao criar preferência (${resp.statusCode}): ${resp.body}');
    }
  }

  /// Cria cobrança PIX no backend
  /// Esperado: { qr_code, qr_code_base64, payment_id, ... }
  Future<Map<String, dynamic>> createPixPayment({
    required double amount,
    required String userEmail,
    required String bookingId,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final uri = Uri.parse(ApiConfig.createPix);

    final payload = {
      'amount': amount,
      'description': description,
      'payer_email': userEmail,
      'metadata': {
        'bookingId': bookingId,
        ...?metadata,
      },
    };

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      if (data['qr_code'] == null) {
        throw Exception('Resposta PIX inválida: ${resp.body}');
      }
      return data;
    } else {
      throw Exception('Falha ao criar PIX (${resp.statusCode}): ${resp.body}');
    }
  }
}
