class PaymentConfig {
  // ATENÇÃO: Configure estas variáveis com os valores reais em produção
  // Recomenda-se usar Firebase Remote Config ou variáveis de ambiente
  static const String mercadoPagoAccessToken = 'APP_USR-YOUR_ACCESS_TOKEN_HERE';
  static const String mercadoPagoPublicKey = 'APP_USR-YOUR_PUBLIC_KEY_HERE';
  
  // URLs de callback padronizadas
  static const String successUrl = 'https://e-maid-app.web.app/pay/success';
  static const String failureUrl = 'https://e-maid-app.web.app/pay/failure';
  static const String pendingUrl = 'https://e-maid-app.web.app/pay/pending';
  static const String webhookUrl = 'https://e-maid-api.onrender.com/webhooks/mercadopago';
}
