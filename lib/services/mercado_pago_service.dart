import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class MercadoPagoService {
  static const String _baseUrl = 'https://api.mercadopago.com';
  // IMPORTANTE: Substitua pelo seu token real do Mercado Pago
  // Para testes, use o token de sandbox
  static const String _accessToken = 'TEST-SEU_TOKEN_AQUI'; // Para sandbox
  // static const String _accessToken = 'APP_USR-SEU_TOKEN_AQUI'; // Para produção

  // Criar preferência de pagamento
  Future<Map<String, dynamic>> createPaymentPreference({
    required String title,
    required double amount,
    required String userEmail,
    required String bookingId,
  }) async {
    final url = Uri.parse('$_baseUrl/checkout/preferences');

    final body = {
      'items': [
        {
          'title': title,
          'quantity': 1,
          'unit_price': amount,
          'currency_id': 'BRL',
        },
      ],
      'payer': {'email': userEmail},
      'external_reference': bookingId,
      // Substitua pelas suas URLs reais
      'notification_url': 'https://sua-api.com/webhook/mercadopago',
      'back_urls': {
        'success': 'emaid://payment/success',
        'failure': 'emaid://payment/failure',
        'pending': 'emaid://payment/pending',
      },
      'auto_return': 'approved',
      'payment_methods': {'excluded_payment_types': [], 'installments': 12},
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao criar preferência: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Verificar status do pagamento
  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    final url = Uri.parse('$_baseUrl/v1/payments/$paymentId');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao verificar pagamento: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Criar pagamento PIX
  Future<Map<String, dynamic>> createPixPayment({
    required double amount,
    required String userEmail,
    required String bookingId,
    required String description,
  }) async {
    final url = Uri.parse('$_baseUrl/v1/payments');

    final body = {
      'transaction_amount': amount,
      'description': description,
      'payment_method_id': 'pix',
      'payer': {'email': userEmail},
      'external_reference': bookingId,
      'notification_url': 'https://seu-webhook-url.com/webhook',
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao criar PIX: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
