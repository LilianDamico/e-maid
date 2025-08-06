class PaymentConfig {
  // ATENÇÃO: Em produção, use variáveis de ambiente ou Firebase Remote Config
  static const String mercadoPagoAccessToken = 'SEU_ACCESS_TOKEN_AQUI';
  static const String mercadoPagoPublicKey = 'SEU_PUBLIC_KEY_AQUI';
  
  // URLs de callback
  static const String successUrl = 'https://emaid.com.br/payment/success';
  static const String failureUrl = 'https://emaid.com.br/payment/failure';
  static const String pendingUrl = 'https://emaid.com.br/payment/pending';
  static const String webhookUrl = 'https://emaid.com.br/webhooks/mercadopago';
}