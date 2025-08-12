import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class PaymentPreference {
  final String id;
  final String initPoint; // URL que abriremos no WebView

  PaymentPreference({required this.id, required this.initPoint});

  factory PaymentPreference.fromMap(Map<String, dynamic> map) {
    // backend deve retornar algo como { id, init_point }
    return PaymentPreference(
      id: map['id']?.toString() ?? '',
      initPoint: (map['init_point'] ?? map['sandbox_init_point'] ?? '').toString(),
    );
  }
}

class PaymentApi {
  /// Cria uma preferência no backend e retorna a URL (init_point)
  static Future<PaymentPreference> createPreference({
    required double amount,
    required String description,
    required String payerEmail,
    Map<String, dynamic>? metadata,
  }) async {
    final uri = Uri.parse(ApiConfig.createPreference);

    final body = {
      'amount': amount,
      'description': description,
      'payer_email': payerEmail,
      'metadata': metadata ?? {},
      // se no backend você espera also return_urls, mande também:
      'return_urls': {
        'success': ReturnUrls.success,
        'failure': ReturnUrls.failure,
        'pending': ReturnUrls.pending,
      },
    };

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return PaymentPreference.fromMap(data);
    } else {
      throw Exception(
        'Falha ao criar preferência (${resp.statusCode}): ${resp.body}',
      );
    }
  }
}
