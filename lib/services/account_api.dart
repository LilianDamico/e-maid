import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AccountApi {
  // Coloque sua base da API (prod)
  static const String baseUrl = 'https://e-maid-api.onrender.com';

  static Future<void> deleteMyAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Não autenticado');

    final idToken = await user.getIdToken(true);
    final uri = Uri.parse('$baseUrl/api/account');

    final resp = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $idToken'},
    );

    if (resp.statusCode != 200) {
      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      throw Exception(body['error'] ?? 'Falha ao excluir conta');
    }
  }
}
