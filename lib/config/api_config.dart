// lib/config/api_config.dart

class ApiConfig {
  static const String baseUrl = 'https://e-maid-api.onrender.com/api/mp';

  static const String createPreference = '$baseUrl/payments/preference';
  static const String createPix       = '$baseUrl/payments/pix';

  // URLs de retorno usadas no WebView (apenas comparação de prefixo)
  static const String success = 'https://emaid.app/pagamento/sucesso';
  static const String failure = 'https://emaid.app/pagamento/erro';
  static const String pending = 'https://emaid.app/pagamento/pendente';
}
