class MercadoPagoConfig {
  // IMPORTANTE: Substitua pelos seus tokens reais antes do deploy
  // Recomenda-se usar Firebase Remote Config para gerenciar estes valores
  static const String accessToken = 'APP_USR-YOUR_ACCESS_TOKEN_HERE';
  static const String publicKey = 'APP_USR-YOUR_PUBLIC_KEY_HERE';
  
  // URLs de webhook (configure no seu backend)
  static const String webhookUrl = 'https://e-maid-api.onrender.com/webhooks/mercadopago';
  
  // URLs de retorno padronizadas
  static const String successUrl = 'https://e-maid-app.web.app/pay/success';
  static const String failureUrl = 'https://e-maid-app.web.app/pay/failure';
  static const String pendingUrl = 'https://e-maid-app.web.app/pay/pending';
}
