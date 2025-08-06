class MercadoPagoConfig {
  // IMPORTANTE: Substitua pelos seus tokens reais
  static const String accessToken = 'APP_USR-SEU_ACCESS_TOKEN_AQUI';
  static const String publicKey = 'APP_USR-SEU_PUBLIC_KEY_AQUI';
  
  // URLs de webhook (configure no seu backend)
  static const String webhookUrl = 'https://seu-dominio.com/webhook';
  
  // URLs de retorno
  static const String successUrl = 'emaid://payment/success';
  static const String failureUrl = 'emaid://payment/failure';
  static const String pendingUrl = 'emaid://payment/pending';
}